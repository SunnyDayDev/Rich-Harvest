//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

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

        container.register(SafariExtensionRootViewController.self) { (r: Resolver) in

            let viewController = NSStoryboard.safariExtensionApp.instantiateInitialController()
                as! SafariExtensionRootViewController

            let tabs = [
                NSTabViewItem(viewController: r.resolve(TimerViewController.self)!),
                NSTabViewItem(viewController: r.resolve(AuthViewController.self)!)
            ]

            viewController.tabViewItems = tabs

            return viewController
        }

    }

}