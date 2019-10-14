//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject
import FirebaseDatabase

import RichHarvest_Core_Core
import RichHarvest_Domain_Rules_Api

public class RulesDomainAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        
        container.register(Database.self, factory: { _ in Database.database() })
        
        container.register(RulesRepositoryMappers.self, factory: { _ in RulesRepositoryMappers() })

        container.register(RulesRepository.self) { (r: Resolver) in
            RulesRepositoryImplementation(
                mappers: r.resolve(RulesRepositoryMappers.self)!,
                schedulers: r.resolve(Schedulers.self)!,
                database: r.resolve(Database.self)!
            )
        }

    }

}