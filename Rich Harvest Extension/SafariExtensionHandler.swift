//
//  SafariExtensionHandler.swift
//  Rich Harvest Extension
//
//  Created by Александр Цикин on 16/11/2018.
//  Copyright © 2018 SunnyDayDev. All rights reserved.
//

import SafariServices

import SwiftyBeaver
import RichHarvest_Core_Core

import RichHarvest_App_SafariExtension

private var initLog: () -> () = {

    let console = ConsoleDestination()
    console.useNSLog = true
    SwiftyBeaver.addDestination(console)

    Log.debug("Log initiated.")

    return { }

}()

class SafariExtensionHandler: SFSafariExtensionHandler {

    private let extensionEvents = DependencyResolver.resolve(ExtensionEventsSource.self)!
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {

        initLog()

        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            Log.debug("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
            //SafariExtensionViewController.shared.testLabel.stringValue = "The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))"
        }

    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {

        initLog()

        // This method will be called when your toolbar item is clicked.
        Log.debug("The extension's toolbar item was clicked")
        window.getToolbarItem { (toolbarItem) in
            toolbarItem?.setEnabled(true)
            toolbarItem?.setBadgeText("")
        }

    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {

        initLog()

        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        window.getActiveTab { [extensionEvents] in $0?.getPagesWithCompletionHandler { $0?[0].getPropertiesWithCompletionHandler { properties in

            guard let properties = properties else { return }

            extensionEvents.on(.pageOpened(
                url: properties.url,
                title: properties.title ?? "",
                isActive: properties.isActive
            ))

        } } }
        validationHandler(true, " ")

    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {

        initLog()

        Log.debug("Get popoverViewController")

        return SafariExtensionViewController.shared
    }

}
