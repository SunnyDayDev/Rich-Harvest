//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_Auth_Api

public extension Bundle {

    static var authFeature: Bundle {
        let podBundle = Bundle(for: AuthFeatureAssembly.self)
        return Bundle(url: podBundle.url(forResource: "RichHarvest.Feature.Auth", withExtension: "bundle")!)!
    }

}

public extension NSStoryboard {

    static var authFeature: NSStoryboard {
        return NSStoryboard(name: "Auth", bundle: Bundle.authFeature)
    }

}

public class AuthFeatureAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(AuthViewModel.self) { (r: Resolver) in
            AuthViewModel(
                authRepository: r.resolve(AuthRepository.self)!,
                schedulers: r.resolve(Schedulers.self)!
            )
        }

        container.register(AuthViewController.self) { (r: Resolver) in
            let viewController = NSStoryboard.authFeature.instantiateInitialController() as! AuthViewController
            viewController.inject(viewModel: r.resolve(AuthViewModel.self)!)
            return viewController
        }

    }

}