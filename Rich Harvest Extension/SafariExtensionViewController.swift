//
//  SafariExtensionViewController.swift
//  Rich Harvest Extension
//
//  Created by Александр Цикин on 16/11/2018.
//  Copyright © 2018 SunnyDayDev. All rights reserved.
//

import SafariServices
import AppKit

import RichHarvest_Core_Core
import RichHarvest_App_SafariExtension

class SafariExtensionViewController: SFSafariExtensionViewController {

    static let shared: SafariExtensionViewController = {

        Log.debug("Create shared ViewController")

        let shared = SafariExtensionViewController()

        shared.preferredContentSize = NSSize(width:320, height:240)
        let viewController = DependencyResolver.resolve(
            SafariExtensionRootViewController.self,
            argument: DependencyResolver.resolve(ExtensionEventsSource.self)!
        )!

        shared.view.addSubview(viewController.view)
        shared.addChild(viewController)

        shared.view.addConstraints([NSLayoutConstraint.Attribute.top, .right, .bottom, .left].map {
            NSLayoutConstraint(
                item: viewController.view,
                attribute: $0,
                relatedBy: .equal,
                toItem: shared.view,
                attribute: $0,
                multiplier: 1,
                constant: 0
            )
        })

        Log.debug("Shared view controller is created.")

        return shared

    }()

}
