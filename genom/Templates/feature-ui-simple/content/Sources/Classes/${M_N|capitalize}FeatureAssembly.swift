//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core

public extension Bundle {

    static var ${M_N|decapitalize}Feature: Bundle {
        let podBundle = Bundle(for: ${M_N|capitalize}FeatureAssembly.self)
        return Bundle(url: podBundle.url(forResource: "RichHarvest.Feature.${M_N|capitalize}", withExtension: "bundle")!)!
    }

}

public extension NSStoryboard {

    static var ${M_N|decapitalize}Feature: NSStoryboard {
        return NSStoryboard(name: "${M_N|capitalize}", bundle: Bundle.${M_N|decapitalize}Feature)
    }

}

public class ${M_N|capitalize}FeatureAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(${M_N|capitalize}ViewModel.self) { (r: Resolver) in
            ${M_N|capitalize}ViewModel(
                schedulers: r.resolve(Schedulers.self)!
            )
        }

        container.register(${M_N|capitalize}ViewController.self) { (r: Resolver) in
            let viewController = NSStoryboard.${M_N|decapitalize}Feature.instantiateInitialController() as! ${M_N|capitalize}ViewController
            viewController.inject(viewModel: r.resolve(${M_N|capitalize}ViewModel.self)!)
            return viewController
        }

    }

}