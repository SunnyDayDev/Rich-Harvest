//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_Rules_Api

class RulesRepositoryImplementation: RulesRepository {

    private let mappers: RulesRepositoryMappers

    private let schedulers: Schedulers

    init(mappers: RulesRepositoryMappers, schedulers: Schedulers) {
        self.mappers = mappers
        self.schedulers = schedulers
    }

    func rules() -> Observable<[UrlCheckRule]> {
        fatalError("rules() has not been implemented")
    }

    func store(rule: UrlCheckRule) -> Completable {
        fatalError("store(rule:) has not been implemented")
    }

}
