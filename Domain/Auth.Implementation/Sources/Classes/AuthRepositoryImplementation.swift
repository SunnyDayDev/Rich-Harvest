//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Domain_Networking_Api
import RichHarvest_Domain_Auth_Api

class AuthRepositoryImplementation: AuthRepository {

    private static let eTag = "authRepositoryETag"

    private let sessionManager: HarvestApiSessionManager
    private let authStore: AuthStore
    private let schedulers: Schedulers

    private let repositoryETag: UserDefaultETag

    private let authChangedEvent: Observable<()>

    init(sessionManager: HarvestApiSessionManager, authStore: AuthStore, schedulers: Schedulers) {

        self.sessionManager = sessionManager
        self.authStore = authStore
        self.schedulers = schedulers

        self.repositoryETag = UserDefaults.shared.eTag(name: AuthRepositoryImplementation.eTag)
        self.authChangedEvent = repositoryETag.value.map { _ in () }

    }

    func auth(byPersonalToken token: String, forAccount account: Int) -> Completable {
        return Completable.deferred { [authStore, sessionManager] in
                let session = HarvestApiSession(accountId: account, personalToken: token)
                sessionManager.set(session: session)
                return authStore.storePersonalToken(token, forAccount: account)
            }
            .do(onCompleted: { [repositoryETag] in  repositoryETag.markChanged() })
            .subscribeOn(schedulers.io)
            .observeOn(schedulers.background)
    }

    func storedAuthorization() -> Observable<Authorization?> {
        return authChangedEvent.startWith(())
            .flatMapSingle { [authStore, schedulers] in
                authStore.getPersonalToken()
                    .subscribeOn(schedulers.io)
                    .observeOn(schedulers.background)
            }
            .map { (authData: (token: String, account: Int)?) -> Authorization? in
                if let authData = authData {
                    return .personalToken(token: authData.token, account: authData.account)
                } else {
                    return nil
                }
            }
    }

    func restoreSession() -> Single<Bool> {
        return storedAuthorization()
            .firstOrError()
            .map { [sessionManager] (auth: Authorization?) -> Bool in

                guard let auth = auth else {
                    sessionManager.set(session: nil)
                    return false
                }

                switch auth {

                case let .personalToken(token, account):
                    let session = HarvestApiSession(accountId: account, personalToken: token)
                    sessionManager.set(session: session)

                }

                return true

            }
    }

}