//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_Auth_Api

import RichHarvest_Feature_Timer
import RichHarvest_Feature_Auth

public extension Bundle {

    static var safariExtensionApp: Bundle {
        let podBundle = Bundle(for: SafariExtensionAssembly.self)
        return Bundle(url: podBundle.url(forResource: "RichHarvest.App.SafariExtension", withExtension: "bundle")!)!
    }

}

public extension NSStoryboard {

    static var safariExtensionApp: NSStoryboard {
        return NSStoryboard.init(name: "SafariExtension", bundle: Bundle.safariExtensionApp)
    }

}


public class SafariExtensionAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(SafariExtensionRootViewModel.self) { (r: Resolver) in
            SafariExtensionRootViewModel(
                authRepository: r.resolve(AuthRepository.self)!,
                schedulers: r.resolve(Schedulers.self)!
            )
        }

        container.register(SafariExtensionRootViewController.self) { (r: Resolver) in

            let viewController = NSStoryboard.safariExtensionApp.instantiateInitialController()
                as! SafariExtensionRootViewController

            viewController.inject(viewModel: r.resolve(SafariExtensionRootViewModel.self)!)

            let tabs = [
                NSTabViewItem(viewController: r.resolve(TimerViewController.self)!),
                NSTabViewItem(viewController: r.resolve(AuthViewController.self)!)
            ]

            viewController.tabViewItems = tabs

            viewController.selectedTabViewItemIndex = 0

            tabs.forEach { viewController.addChild($0.viewController!) }

            return viewController
        }

    }

}