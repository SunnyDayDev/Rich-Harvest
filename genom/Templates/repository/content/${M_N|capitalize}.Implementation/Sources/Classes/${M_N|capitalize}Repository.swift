//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_${M_N|capitalize}_Api

class ${M_N|capitalize}RepositoryImplementation: ${M_N|capitalize}Repository {

    private let mappers: ${M_N|capitalize}RepositoryMappers

    private let schedulers: Schedulers

    init(mappers: ${M_N|capitalize}RepositoryMappers, schedulers: Schedulers) {
        self.mappers = mappers
        self.schedulers = schedulers
    }

}
