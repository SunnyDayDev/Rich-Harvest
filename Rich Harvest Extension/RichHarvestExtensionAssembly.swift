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
import RichHarvest_Domain_Rules_Implementation

import RichHarvest_Feature_Auth
import RichHarvest_Feature_Timer
import RichHarvest_Feature_Rules

import RichHarvest_App_SafariExtension

let DependencyResolver: Resolver = {

    Log.debug("Start assembly.")

    let container = Container()

    container.register(ExtensionEventsSource.self) { _ in ExtensionEventsSource() }
        .inObjectScope(.container)

    let assembler = Assembler([

        CoreAssembly(),

        NetworkingDomainAssembly(),
        AuthDomainAssembly(),
        HarvestDomainAssembly(),
        RulesDomainAssembly(),

        AuthFeatureAssembly(),
        TimerFeatureAssembly(),
        RulesFeatureAssembly(),

        SafariExtensionAssembly()

    ], container: container)


    Log.debug("Dependency resolver prepared.")

    return assembler.resolver

}()