//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_Auth_Api
import RichHarvest_Feature_Timer

public class SafariExtensionRootViewController: NSTabViewController {

    private var viewModel: SafariExtensionRootViewModel!

    deinit {
        Log.debug("Deinited")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

}

extension SafariExtensionRootViewController {

    func inject(viewModel: SafariExtensionRootViewModel) {
        self.viewModel = viewModel
    }

}

class SafariExtensionRootViewModel {

    private let authRepository: AuthRepository
    private let schedulers: Schedulers
    private let extensionEventSource: ExtensionEventsSource
    private let timerEventSource: TimerEventsSource

    private let dispose = DisposeBag()

    init(authRepository: AuthRepository,
         schedulers: Schedulers,
         extensionEventSource: ExtensionEventsSource,
         timerEventSource: TimerEventsSource) {

        self.authRepository = authRepository
        self.schedulers = schedulers
        self.extensionEventSource = extensionEventSource
        self.timerEventSource = timerEventSource

        initSources()

    }

    func viewDidLoad() {
        authRepository.restoreSession()
            .observeOn(schedulers.ui)
            .subscribe(onSuccess: { Log.debug("Session restored: \($0)") })
            .disposed(by: dispose)
    }

    private func initSources() {
        extensionEventSource.events
            .subscribe(onNext: { [timerEventSource] in
                switch $0 {
                case let .pageOpened(url, title, isActive):
                    if isActive { timerEventSource.on(.pageOpened(url: url, title: title)) }
                }
            })
            .disposed(by: dispose)
    }

}


public enum ExtensionEvent {
    case pageOpened(url: URL?, title: String, isActive: Bool)
}

public class ExtensionEventsSource {

    fileprivate let events = PublishSubject<ExtensionEvent>()

    public init() { }

    public func on(_ event: ExtensionEvent) {
        events.on(.next(event))
    }

}