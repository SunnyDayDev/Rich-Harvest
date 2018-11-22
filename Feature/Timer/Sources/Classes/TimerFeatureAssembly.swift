//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import Swinject

import RichHarvest_Core_Core
import RichHarvest_Domain_Harvest_Api

public extension Bundle {

    static var timerFeature: Bundle {
        let podBundle = Bundle(for: TimerFeatureAssembly.self)
        return Bundle(url: podBundle.url(forResource: "RichHarvest.Feature.Timer", withExtension: "bundle")!)!
    }

}

public extension NSStoryboard {

    static var timerFeature: NSStoryboard {
        return NSStoryboard(name: "Timer", bundle: Bundle.timerFeature)
    }

}

public class TimerFeatureAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {

        container.register(TimerViewModel.self) { (r: Resolver, eventSource: TimerEventsSource) in
            TimerViewModel(
                harvestRepository: r.resolve(HarvestRepository.self)!,
                schedulers: r.resolve(Schedulers.self)!,
                eventsSource: eventSource
            )
        }

        container.register(TimerViewController.self) { (r: Resolver, eventSource: TimerEventsSource) in
            let viewController = NSStoryboard.timerFeature.instantiateInitialController() as! TimerViewController
            viewController.inject(viewModel: r.resolve(TimerViewModel.self, argument: eventSource)!)
            return viewController
        }

    }

}