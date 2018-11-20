//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Domain_Networking_Api
import RichHarvest_Domain_Auth_Api

public class AuthDomainAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(AuthStore.self) { _ in AuthStoreImplementation() }

        container.register(AuthRepository.self) { (r: Resolver) in
            AuthRepositoryImplementation(
                sessionManager: r.resolve(HarvestApiSessionManager.self)!,
                authStore: r.resolve(AuthStore.self)!
            )
        }

    }

}