//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Domain_Harvest_Api

class TimerViewModel {

    private let harvestRepository: HarvestRepository

    init(harvestRepository: HarvestRepository) {
        self.harvestRepository = harvestRepository
    }

}