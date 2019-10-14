//
//  AppDelegate.swift
//  Rich Harvest
//
//  Created by Александр Цикин on 16/11/2018.
//  Copyright © 2018 SunnyDayDev. All rights reserved.
//

import Cocoa

import Swinject
import SwiftyBeaver
import FirebaseCore

import RichHarvest_Core_Core

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private(set) var resolver: Resolver!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        initLogging()
        initFirebaseDataBase()

        resolver = RichHarvestAssembly().assembly()

    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    private func initLogging() {
        let consoleLogger = ConsoleDestination()
        consoleLogger.useNSLog = true
        Log.initLogger(destinations: consoleLogger)
    }
    
    private func initFirebaseDataBase() {
        FirebaseApp.configure()
    }

}
