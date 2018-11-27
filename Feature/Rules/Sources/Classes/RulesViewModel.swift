//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Domain_Rules_Api

class RulesViewModel {

    private let repository: RulesRepository
    private let schedulers: Schedulers
    private let itemFactory: RuleItemViewModel.Factory

    init(repository: RulesRepository, schedulers: Schedulers, itemFactory: RuleItemViewModel.Factory) {
        self.repository = repository
        self.schedulers = schedulers
        self.itemFactory = itemFactory
    }

    deinit {
        Log.debug("Deinited")
    }

}

class RuleItemViewModel {

    let name: Driver<String>
    let project: Driver<String>
    let task: Driver<String>

    init(rule: UrlCheckRule) {
        name = Driver.just(rule.name)
        project = Driver.just("<todo>")
        task = Driver.just("<todo>")
    }

    class Factory {

        func create(by rule: UrlCheckRule) -> RuleItemViewModel {
            return RuleItemViewModel(rule: rule)
        }

    }

}