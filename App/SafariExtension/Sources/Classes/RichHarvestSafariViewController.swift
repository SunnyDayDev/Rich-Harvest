//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_Auth_Api

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

    private let dispose = DisposeBag()

    init(authRepository: AuthRepository, schedulers: Schedulers) {
        self.authRepository = authRepository
        self.schedulers = schedulers
    }

    func viewDidLoad() {
        authRepository.restoreSession()
            .observeOn(schedulers.ui)
            .subscribe(onSuccess: { Log.debug("Session restored: \($0)") })
            .disposed(by: dispose)
    }

}