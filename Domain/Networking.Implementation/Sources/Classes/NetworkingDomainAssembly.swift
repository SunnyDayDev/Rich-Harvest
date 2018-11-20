//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import Alamofire
import RichHarvest_Domain_Networking_Api

public class NetworkingDomainAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(HarvestApiSessionManager.self) { _ in HarvestApiSessionManagerImplementation() }
            .inObjectScope(.container)

        container.register(SessionManager.self) { _ in

            let configuration = URLSessionConfiguration.default
            configuration.urlCache = nil
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            configuration.httpShouldSetCookies = false

            return SessionManager(configuration: configuration)

        }

        container.register(HarvestApi.self) { (r: Resolver) in
            HarvestApiImplementation(
                sessionManager: r.resolve(HarvestApiSessionManager.self)!,
                urlSessionManager: r.resolve(SessionManager.self)!
            )
        }

    }

}