//
//  ViewController.swift
//  Rich Harvest
//
//  Created by Александр Цикин on 16/11/2018.
//  Copyright © 2018 SunnyDayDev. All rights reserved.
//

import Cocoa

import SafariServices.SFSafariApplication
import RichHarvest_Feature_Auth

class ViewController: NSViewController {

    @IBOutlet var appNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.stringValue = "Rich Harvest";
    }
    
    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "SunnyDayDev.Rich-Harvest-Extension") { error in
            if let error = error {
                // Insert code to inform the user that something went wrong.
                NSLog("Error: \(error)")
            }
        }
    }
    
    @IBAction func openAuth(_ sender: Any) {

        let viewController = (NSApplication.shared.delegate as! AppDelegate).resolver.resolve(AuthViewController.self)!

        let container = self.view.superview!

        self.view.removeFromSuperview()

        viewController.view.frame = container.bounds
        container.addSubview(viewController.view)

    }
    
}
