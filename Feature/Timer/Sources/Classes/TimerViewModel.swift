//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject
import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Domain_Harvest_Api
import RichHarvest_Domain_Rules_Api

class TimerViewModel {

    let clients: Driver<[String]>
    let selectedClientIndex = BehaviorRelay(value: -1)

    let projects: Driver<[String]>
    let selectedProjectIndex = BehaviorRelay(value: -1)

    let tasks: Driver<[String]>
    let selectedTaskIndex = BehaviorRelay(value: -1)

    let url: Driver<String>
    let notes = BehaviorRelay(value: "")

    let startTap = PublishRelay<()>()

    private let harvestRepository: HarvestRepository
    private let rulesRepository: RulesRepository
    private let schedulers: Schedulers
    private let eventsSource: TimerEventsSource

    private let clientsRelay = BehaviorRelay<[ClientDetail]>(value: [])
    private let projectsRelay = BehaviorRelay<[ProjectDetail]>(value: [])
    private let tasksRelay = BehaviorRelay<[Task]>(value: [])
    
    private let urlRelay = BehaviorRelay(value: "")
    
    private let dispose = DisposeBag()

    init(harvestRepository: HarvestRepository,
         rulesRepository: RulesRepository,
         schedulers: Schedulers,
         eventsSource: TimerEventsSource) {

        self.harvestRepository = harvestRepository
        self.rulesRepository = rulesRepository
        self.schedulers = schedulers
        self.eventsSource = eventsSource

        self.clients = clientsRelay.asDriver().map { $0.map { $0.name } }
        self.projects = projectsRelay.asDriver().map { $0.map { $0.name } }
        self.tasks = tasksRelay.asDriver().map { $0.map { $0.name } }
        self.url = urlRelay.asDriver().map { $0.removingPercentEncoding ?? "" }

        initSources()
        initActions()

    }

    deinit {
        Log.debug("Deinited.")
    }

    func viewWillAppear() {

        Log.debug("Start update projects.")
        refetchClients()

    }
    
    private func refetchClients() {
        
        harvestRepository.clients(isActive: true)
            .observeOn(schedulers.ui)
            .subscribe(
                onSuccess: { [weak self] in self?.handle(clients: $0.clients) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)
        
    }
    
    private func handle(clients: [ClientDetail]) {
        
        Log.debug("Clients: \(clients)")
        
        guard !clients.isEmpty else {
            clientsRelay.accept([])
            selectedClientIndex.accept(-1)
            return
        }
        
        let previousSelectedClient: ClientDetail?
        if selectedClientIndex.value != -1 {
            previousSelectedClient = clientsRelay.value[selectedClientIndex.value]
        } else {
            previousSelectedClient = nil
        }
        
        clientsRelay.accept(clients)
        selectedClientIndex.accept(clients.firstIndex(where: { $0.id == previousSelectedClient?.id }) ?? 0)
        
    }

    private func initSources() {

        eventsSource.events
            .subscribe(onNext: { [urlRelay, notes] (event: TimerEvent) in
                switch event {
                case let .pageOpened(url, title):
                    urlRelay.accept(url?.absoluteString ?? "")
                    notes.accept(title)
                }
            })
            .disposed(by: dispose)

        initProjectsFetching()
        initTasksFetching()

        initUrlRuleChecking()

    }
    
    private func initProjectsFetching() {
        
        Observable<ClientDetail?>.combineLatest(
                selectedClientIndex.distinctUntilChanged(),
                clientsRelay,
                resultSelector: { (i, clients) in clients.getOrNil(i) }
            )
            .distinctUntilChanged()
            .switchMapSingle { [harvestRepository] (selected: ClientDetail?) -> Single<[ProjectDetail]> in
                if let selected = selected {
                    return harvestRepository.projects(clientId: selected.id)
                        .map { $0.projects }
                } else {
                    return Single.just([])
                }
            }
            .observeOn(schedulers.ui)
            .subscribe(
                onNext: { [weak self] in self?.handle(projects: $0) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)
        
    }
    
    private func handle(projects: [ProjectDetail]) {
        
        Log.debug("Projects: \(projects)")
    
        guard !projects.isEmpty else {
            projectsRelay.accept([])
            selectedProjectIndex.accept(-1)
            return
        }
        
        let previousSelectedProject: ProjectDetail?
        if selectedProjectIndex.value != -1 {
            previousSelectedProject = projectsRelay.value[selectedProjectIndex.value]
        } else {
            previousSelectedProject = nil
        }
        
        projectsRelay.accept(projects)
        selectedProjectIndex.accept(projects.firstIndex(where: { $0.id == previousSelectedProject?.id }) ?? 0)
        
    }
    
    private func initTasksFetching() {
        
        let selectedProject: Observable<ProjectDetail?> = Observable<ProjectDetail?>.combineLatest(
                selectedProjectIndex.distinctUntilChanged(),
                projectsRelay,
                resultSelector: { (i, projects) in projects.getOrNil(i) }
            )
            .distinctUntilChanged()
    
        selectedProject
            .switchMapSingle { [harvestRepository] (selected: ProjectDetail?) -> Single<[Task]> in
                if let selected = selected {
                    return harvestRepository.taskAssignments(byProjectId: selected.id)
                        .map { $0.taskAssignments.map { $0.task } }
                } else {
                    return Single.just([])
                }
            }
            .observeOn(schedulers.ui)
            .subscribe(
                onNext: { [weak self] in self?.handle(tasks: $0) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)
        
    }
    
    private func handle(tasks: [Task]) {
        
        Log.debug("Tasks: \(tasks)")
        
        guard !tasks.isEmpty else {
            tasksRelay.accept([])
            selectedTaskIndex.accept(-1)
            return
        }
        
        let previousSelectedTask: Task?
        if selectedTaskIndex.value != -1 {
            previousSelectedTask = tasksRelay.value[selectedTaskIndex.value]
        } else {
            previousSelectedTask = nil
        }
        
        tasksRelay.accept(tasks)
        selectedTaskIndex.accept(tasks.firstIndex(where: { $0.id == previousSelectedTask?.id }) ?? 0)
        
    }

    private func initUrlRuleChecking() {

        let urlSource = eventsSource.events
            .mapNonNil { (event: TimerEvent) -> URL? in
                    if case let .pageOpened(url: url, title: _) = event {
                    return url
                } else {
                    return nil
                }
            }

        let ruleResultSource = Observable.combineLatest(
                urlSource,
                rulesRepository.rules(),
                resultSelector: { [weak self] (url: URL, rules: [UrlCheckRule]) -> UrlCheckRule.Result? in
                    guard let self = self else { return nil }
                    return self.resolveBestRule(forUrl: url, byRules: rules)
                }
            )
            .share(replay: 1)

        Observable.combineLatest(
                ruleResultSource,
                clientsRelay.asObservable().filter { $0.count > 0 },
                resultSelector: { (rule: UrlCheckRule.Result?, clients: [ClientDetail]) in
                    clients.firstIndex(where: { $0.id == rule?.clientId })
                }
            )
            .mapNonNil { $0 }
            .observeOn(schedulers.ui)
            .subscribe(onNext: { [selectedClientIndex] in selectedClientIndex.accept($0) })
            .disposed(by: dispose)

        Observable.combineLatest(
                ruleResultSource,
                projectsRelay.asObservable().filter { $0.count > 0 },
                resultSelector: { (rule: UrlCheckRule.Result?, projects: [ProjectDetail]) in
                    projects.firstIndex(where: { $0.id == rule?.projectId })
                }
            )
            .mapNonNil { $0 }
            .observeOn(schedulers.ui)
            .subscribe(onNext: { [selectedProjectIndex] in selectedProjectIndex.accept($0) })
            .disposed(by: dispose)

        Observable.combineLatest(
                ruleResultSource,
                tasksRelay.asObservable().filter { $0.count > 0 },
                resultSelector: { (rule: UrlCheckRule.Result?, tasks: [Task]) in
                    tasks.firstIndex(where: { $0.id == rule?.taskId })
                }
            )
            .mapNonNil { $0 }
            .observeOn(schedulers.ui)
            .subscribe(onNext: { [selectedTaskIndex] in selectedTaskIndex.accept($0) })
            .disposed(by: dispose)

    }

    private func initActions() {

        startTap.asObservable()
            .switchMapCompletable { [unowned self] in

                let projectId = self.projectsRelay.value[self.selectedProjectIndex.value].id
                let taskId = self.tasksRelay.value[self.selectedTaskIndex.value].id
                let notes = self.notes.value
                let url = self.urlRelay.value

                let timer = StartTimerData(
                    projectID: "\(projectId)",
                    taskID: "\(taskId)",
                    spentDate: Date(),
                    notes: notes,
                    url: url
                )

                return self.harvestRepository.startTimer(withData: timer)
                    .catchError { _ in Completable.empty() }

            }
            .subscribe()
            .disposed(by: dispose)

    }

    private func resolveBestRule(forUrl url: URL, byRules rules: [UrlCheckRule]) -> UrlCheckRule.Result? {
        rules.filter { (rule: UrlCheckRule) in
                switch rule.rule {
                case let .regex(expr):
                    guard let regex = try? NSRegularExpression.init(pattern: expr, options: .caseInsensitive) else {
                        return false
                    }
                    let urlString = url.absoluteString
                    let fullRange = NSRange(location: 0, length: urlString.count)

                    return regex.numberOfMatches(in: urlString, range: fullRange) > 0

                }
            }
            .max(by: { $1.priority > $0.priority })?.result
    }

}

public enum TimerEvent {
    case pageOpened(url: URL?, title: String)
}

public class TimerEventsSource {

    fileprivate let events = PublishSubject<TimerEvent>()

    public init() { }

    public func on(_ event: TimerEvent) {
        events.on(.next(event))
    }

}