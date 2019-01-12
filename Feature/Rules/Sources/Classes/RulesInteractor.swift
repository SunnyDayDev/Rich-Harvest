//
// Created by Александр Цикин on 2018-11-28.
//

import Foundation

import RxSwift

import RichHarvest_Domain_Rules_Api
import RichHarvest_Domain_Harvest_Api

class RulesInteractor {

    private let rulesRepository: RulesRepository
    private let harvestRepository: HarvestRepository

    private var clientsCache: [Int: ClientDetail] = [:]
    private var tasksCache: [Int: TaskDetail] = [:]
    private var projectCache: [Int: ProjectDetail] = [:]

    init(rulesRepository: RulesRepository, harvestRepository: HarvestRepository) {
        self.rulesRepository = rulesRepository
        self.harvestRepository = harvestRepository
    }

    func rules() -> Observable<[UrlCheckRule]> { return rulesRepository.rules() }

    func client(byId id: Int) -> Observable<ClientDetail> {
        if let cached = clientsCache[id] {
            return Observable.just(cached)
        } else {
            return harvestRepository.client(byId: id).asObservable()
                .do(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.clientsCache[id] = $0
                })
        }
    }

    func project(byId id: Int) -> Observable<ProjectDetail> {
        if let cached = projectCache[id] {
            return Observable.just(cached)
        } else {
            return harvestRepository.project(byId: id).asObservable()
                .do(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.projectCache[id] = $0
                })
        }
    }

    func task(byId id: Int) -> Observable<TaskDetail> {
        if let cached = tasksCache[id] {
            return Observable.just(cached)
        } else {
            return harvestRepository.task(byId: id).asObservable()
                .do(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.tasksCache[id] = $0
                })
        }
    }

}