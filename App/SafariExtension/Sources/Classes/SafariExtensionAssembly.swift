//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_Auth_Api

import RichHarvest_Feature_Timer
import RichHarvest_Feature_Auth
import RichHarvest_Feature_Rules

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

        container.register(SafariExtensionRootViewModel.self) {
            (r: Resolver, events: ExtensionEventsSource, timerEvents: TimerEventsSource) in

            SafariExtensionRootViewModel(
                authRepository: r.resolve(AuthRepository.self)!,
                schedulers: r.resolve(Schedulers.self)!,
                extensionEventSource: events,
                timerEventSource: timerEvents
            )

        }

        container.register(SafariExtensionRootViewController.self) { (r: Resolver, events: ExtensionEventsSource) in

            let viewController = NSStoryboard.safariExtensionApp.instantiateInitialController()
                as! SafariExtensionRootViewController

            let timerEventSource = TimerEventsSource()

            viewController.inject(
                viewModel: r.resolve(
                    SafariExtensionRootViewModel.self,
                    arguments: events, timerEventSource
                )!
            )

            let tabs = [
                NSTabViewItem(viewController: r.resolve(TimerViewController.self, argument: timerEventSource)!),
                NSTabViewItem(viewController: r.resolve(RulesViewController.self)!),
                NSTabViewItem(viewController: r.resolve(AuthViewController.self)!)
            ]

            viewController.tabViewItems = tabs

            viewController.selectedTabViewItemIndex = 0

            tabs.forEach { viewController.addChild($0.viewController!) }

            return viewController

        }

    }

}