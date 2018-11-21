//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Domain_Auth_Api

class AuthViewModel {

    let personalToken = BehaviorRelay(value: "")
    let accountId = BehaviorRelay(value: "")

    let applyTap = PublishRelay<()>()

    private let authRepository: AuthRepository
    private let schedulers: Schedulers

    private let dispose = DisposeBag()

    deinit {
        Log.debug("Deinited")
    }

    init(authRepository: AuthRepository, schedulers: Schedulers) {

        self.authRepository = authRepository
        self.schedulers = schedulers

        initSources()
        initActions()

        Log.debug("Initiated")

    }

    private func initSources() {

        authRepository.storedAuthorization()
            .observeOn(schedulers.ui)
            .subscribe(
                onNext: { [weak self] in self?.handle(storedAuthorization: $0) },
                onError: { Log.error($0) }
            )
            .disposed(by: dispose)

    }

    private func initActions() {

        applyTap.asSignal()
            .emit(onNext: { [accountId, personalToken, authRepository, dispose] in

                guard let accountId = Int(accountId.value) else {
                    Log.debug("Account id is nil.")
                    return
                }

                let token = personalToken.value

                guard !token.isEmpty else {
                    Log.debug("Token is empty.")
                    return
                }

                authRepository.auth(byPersonalToken: token, forAccount: accountId)
                    .subscribe()
                    .disposed(by: dispose)

            })
            .disposed(by: dispose)

    }

    private func handle(storedAuthorization auth: Authorization?) {

        guard let auth = auth else {
            personalToken.accept("")
            accountId.accept("")
            return
        }

        switch auth {

        case let .personalToken(token, account):
            personalToken.accept(token)
            accountId.accept("\(account)")

        }

    }

}