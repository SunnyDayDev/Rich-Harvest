//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_Rules_Api

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
                repository: r.resolve(RulesRepository.self)!,
                schedulers: r.resolve(Schedulers.self)!,
                itemFactory: RuleItemViewModel.Factory()
            )
        }

        container.register(RulesViewController.self) { (r: Resolver) in
            let viewController = NSStoryboard.rulesFeature.instantiateInitialController() as! RulesViewController
            viewController.inject(viewModel: r.resolve(RulesViewModel.self)!)
            return viewController
        }

    }

}