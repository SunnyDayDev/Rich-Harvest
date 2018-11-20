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
import RichHarvest_Feature_Timer

import RichHarvest_App_SafariExtension

class RichHarvestExtensionAssembly {

    func assembly() -> SafariExtensionRootViewController {

        NSLog("Start assembly.")

        let container = Container()

        let assembler = Assembler([

            CoreAssembly(),

            NetworkingDomainAssembly(),
            AuthDomainAssembly(),
            HarvestDomainAssembly(),

            AuthFeatureAssembly(),
            TimerFeatureAssembly(),

            SafariExtensionAssembly()

        ], container: container)

        let root = assembler.resolver.resolve(SafariExtensionRootViewController.self)!

        Log.debug("Root view controller resolved.")
        NSLog("Root view controller resolved.")

        return root

    }

}