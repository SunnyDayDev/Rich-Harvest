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

    init(repository: RulesRepository, schedulers: Schedulers) {
        self.repository = repository
        self.schedulers = schedulers
    }

    deinit {
        Log.debug("Deinited")
    }

}