//
// Created by Aleksandr Tcikin (mail@sunnydaydev.me)
// on ${DATE|format=yyyy-MM-dd}.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_${M_N|capitalize}_Api

public class ${M_N|capitalize}DomainAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(${M_N|capitalize}Repository.self) { (r: Resolver) in
            ${M_N|capitalize}RepositoryImplementation(
                mappers: ${M_N|capitalize}RepositoryMappers(),
                schedulers: r.resolve(Schedulers.self)!
            )
        }

    }

}