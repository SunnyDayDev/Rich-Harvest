//
// Created by Александр Цикин on 2018-11-20.
// Copyright (c) 2018 SunnyDayDev. All rights reserved.
//

import Foundation

import Swinject

import RichHarvest_Core_Core

import RichHarvest_Domain_Networking_Implementation
import RichHarvest_Domain_Auth_Implementation
import RichHarvest_Domain_Harvest_Implementation

import RichHarvest_Feature_Auth

class RichHarvestAssembly {

    func assembly() -> Resolver {

        Log.debug("Start assembly.")

        let container = Container()

        let assembler = Assembler([

            CoreAssembly(),

            NetworkingDomainAssembly(),
            AuthDomainAssembly(),
            HarvestDomainAssembly(),

            AuthFeatureAssembly()

        ], container: container)

        return assembler.resolver

    }

}