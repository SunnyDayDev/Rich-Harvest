//
// Created by Александр Цикин on 2018-11-21.
// Copyright (c) 2018 SunnyDayDev. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

class RichHarvestApplication: NSApplication {

    override func sendEvent(_ event: NSEvent) {
        if event.type == NSEvent.EventType.keyDown {

            if (event.modifierFlags.contains(NSEvent.ModifierFlags.command)) {
                switch event.charactersIgnoringModifiers!.lowercased() {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return }
                case "a":
                    if NSApp.sendAction(#selector(NSText.selectAll(_:)), to:nil, from:self) { return }
                default:
                    break
                }
            }
        }
        return super.sendEvent(event)
    }

}