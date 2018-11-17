//
//  SafariExtensionViewController.swift
//  Rich Harvest Extension
//
//  Created by Александр Цикин on 16/11/2018.
//  Copyright © 2018 SunnyDayDev. All rights reserved.
//

import SafariServices
import AppKit

class SafariExtensionViewController: SFSafariExtensionViewController {

    static let shared: SafariExtensionViewController = {

        let shared = SafariExtensionViewController()

        shared.preferredContentSize = NSSize(width:320, height:240)
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController() as! NSViewController

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

        return shared

    }()

}
