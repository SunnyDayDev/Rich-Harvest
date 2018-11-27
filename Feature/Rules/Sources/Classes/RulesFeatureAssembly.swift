//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core

public extension Bundle {

    static var rulesFeature: Bundle {
        let podBundle = Bundle(for: RulesFeatureAssembly.self)
        return Bundle(url: podBundle.url(forResource: "RichHarvest.Feature.Rules", withExtension: "bundle")!)!
    }

}

public extension NSStoryboard {

    static var rulesFeature: NSStoryboard {
        return NSStoryboard(name: "Rules", bundle: Bundle.rulesFeature)
    }

}

public class RulesFeatureAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(RulesViewModel.self) { (r: Resolver) in
            RulesViewModel(
                schedulers: r.resolve(Schedulers.self)!
            )
        }

        container.register(RulesViewController.self) { (r: Resolver) in
            let viewController = NSStoryboard.rulesFeature.instantiateInitialController() as! RulesViewController
            viewController.inject(viewModel: r.resolve(RulesViewModel.self)!)
            return viewController
        }

    }

}