//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_Networking_Api
import RichHarvest_Domain_Harvest_Api

public class HarvestDomainAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(HarvestRepository.self) { (r: Resolver) in
            HarvestRepositoryImplementation(
                network: r.resolve(HarvestApi.self)!,
                mappers: HarvestRepositoryMappers(),
                schedulers: r.resolve(Schedulers.self)!
            )
        }

    }

}