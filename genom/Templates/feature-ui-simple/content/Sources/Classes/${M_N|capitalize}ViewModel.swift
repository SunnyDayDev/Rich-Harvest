//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core

class ${M_N|capitalize}ViewModel {

    private let schedulers: Schedulers

    init(schedulers: Schedulers) {
        self.schedulers = schedulers
        Log.debug("Initiated")
    }

    deinit {
        Log.debug("Deinited")
    }

}