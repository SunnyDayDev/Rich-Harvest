//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject
import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Domain_Harvest_Api

class TimerViewModel {

    let projects: Driver<[String]>
    let selectedProject = BehaviorRelay(value: -1)

    let url: Driver<String>
    let notes = BehaviorRelay(value: "")

    private let harvestRepository: HarvestRepository
    private let schedulers: Schedulers
    private let eventsSource: TimerEventsSource

    private let projectsRelay = BehaviorRelay<[ProjectDetail]>(value: [])
    private let urlRelay = BehaviorRelay(value: "")

    private let dispose = DisposeBag()

    init(harvestRepository: HarvestRepository, schedulers: Schedulers, eventsSource: TimerEventsSource) {

        self.harvestRepository = harvestRepository
        self.schedulers = schedulers
        self.eventsSource = eventsSource

        self.projects = projectsRelay.map { $0.map { $0.name } } .asDriver(onErrorJustReturn: [])
        self.url = urlRelay.asDriver()

        initSources()

    }

    deinit {
        Log.debug("Deinited.")
    }

    func viewWillAppear() {

        Log.debug("Start update projects.")

        harvestRepository.projects(isActive: true, page: 0)
            .observeOn(schedulers.ui)
            .subscribe(
                onSuccess: { [weak self] in self?.handle(projects: $0) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)

    }

    private func initSources() {
        eventsSource.events
            .subscribe(onNext: { [urlRelay, notes] in
                switch $0 {
                case let .pageOpened(url, title):
                    urlRelay.accept(url?.absoluteString ?? "")
                    notes.accept(title)
                }
            })
            .disposed(by: dispose)

    }

    private func handle(projects: Projects) {
        Log.debug("Projects: \(projects)")

        projectsRelay.accept(projects.projects)

        if projectsRelay.value.count > 0 && selectedProject.value == -1 {
            selectedProject.accept(0)
        }

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