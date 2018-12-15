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
    let selectedClient = BehaviorRelay(value: -1)

    let projects: Driver<[String]>
    let selectedProject = BehaviorRelay(value: -1)

    let tasks: Driver<[String]>
    let selectedTask = BehaviorRelay(value: -1)

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

        self.clients = clientsRelay.map { $0.map { $0.name } } .asDriver(onErrorJustReturn: [])
        self.projects = projectsRelay.map { $0.map { $0.name } } .asDriver(onErrorJustReturn: [])
        self.tasks = tasksRelay.map { $0.map { $0.name } } .asDriver(onErrorJustReturn: [])
        self.url = urlRelay.asDriver()

        initSources()
        initActions()

    }

    deinit {
        Log.debug("Deinited.")
    }

    func viewWillAppear() {

        Log.debug("Start update projects.")

        harvestRepository.clients(isActive: true)
            .observeOn(schedulers.ui)
            .subscribe(
                onSuccess: { [weak self] in self?.handle(clients: $0.clients) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)

    }

    private func initSources() {

        eventsSource.events
            .subscribe(onNext: { [urlRelay, notes] (event: TimerEvent) in
                switch event {
                case let .pageOpened(url, title):
                    urlRelay.accept(url?.absoluteString.removingPercentEncoding ?? "")
                    notes.accept(title)
                }
            })
            .disposed(by: dispose)

        selectedClient.distinctUntilChanged()
            .switchMap { [clientsRelay] index in
                clientsRelay.asObservable().mapNonNil { $0.getOrNil(index) }
            }
            .switchMapSingle { [harvestRepository] (selected: ClientDetail) in
                harvestRepository.projects(clientId: selected.id)
            }
            .observeOn(schedulers.ui)
            .subscribe(
                onNext: { [weak self] in self?.handle(projects: $0.projects) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)

        selectedProject.distinctUntilChanged()
            .switchMap { [projectsRelay] index in
                projectsRelay.asObservable().mapNonNil { $0.getOrNil(index) }
            }
            .switchMapSingle { [harvestRepository] (project: ProjectDetail) in
                harvestRepository.taskAssignments(byProjectId: project.id)
            }
            .map { $0.taskAssignments.map { $0.task } }
            .observeOn(schedulers.ui)
            .subscribe(
                onNext: { [weak self] in self?.handle(tasks: $0) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)

        initUrlRuleChecking()

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
            .subscribe(onNext: { [selectedClient] in selectedClient.accept($0) })
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
            .subscribe(onNext: { [selectedProject] in selectedProject.accept($0) })
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
            .subscribe(onNext: { [selectedTask] in selectedTask.accept($0) })
            .disposed(by: dispose)

    }

    private func initActions() {

        startTap.asObservable()
            .switchMapCompletable { [unowned self] in

                let projectId = self.projectsRelay.value[self.selectedProject.value].id
                let taskId = self.tasksRelay.value[self.selectedTask.value].id
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

    private func handle(clients: [ClientDetail]) {

        Log.debug("Clients: \(clients)")

        clientsRelay.accept(clients)

        if clientsRelay.value.count > 0 && selectedClient.value == -1 {
            selectedClient.accept(0)
        }

    }

    private func handle(projects: [ProjectDetail]) {

        Log.debug("Projects: \(projects)")

        projectsRelay.accept(projects)

        if projectsRelay.value.count > 0 && selectedProject.value == -1 {
            selectedProject.accept(0)
        }

    }

    private func handle(tasks: [Task]) {

        Log.debug("Tasks: \(tasks)")

        tasksRelay.accept(tasks)

        if tasksRelay.value.count > 0 && selectedTask.value == -1 {
            selectedTask.accept(0)
        }

    }

    private func resolveBestRule(forUrl url: URL, byRules rules: [UrlCheckRule]) -> UrlCheckRule.Result? {
        return rules.filter { (rule: UrlCheckRule) in
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