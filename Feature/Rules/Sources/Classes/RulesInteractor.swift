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

    init(rulesRepository: RulesRepository, harvestRepository: HarvestRepository) {
        self.rulesRepository = rulesRepository
        self.harvestRepository = harvestRepository
    }

    func rules() -> Observable<[UrlCheckRule]> { return rulesRepository.rules() }

    func project(byId id: Int) -> Observable<ProjectDetail> {
        return harvestRepository.project(byId: id).asObservable()
    }

    func task(byId id: Int) -> Observable<TaskDetail> {
        return harvestRepository.task(byId: id).asObservable()
    }

}