//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_Networking_Api
import RichHarvest_Domain_Auth_Api

class AuthRepositoryImplementation: AuthRepository {

    private let sessionManager: HarvestApiSessionManager
    private let authStore: AuthStore

    init(sessionManager: HarvestApiSessionManager, authStore: AuthStore) {
        self.sessionManager = sessionManager
        self.authStore = authStore
    }

    func auth(byPersonalToken token: String, forAccount account: Int) -> Completable {
        return Completable.deferred { [authStore, sessionManager] in
            let session = HarvestApiSession(accountId: account, personalToken: token)
            sessionManager.set(session: session)
            return authStore.storePersonalToken(token, forAccount: account)
        }
    }

    func restoreSession() -> Single<Bool> {
        return authStore.getPersonalToken().map { [sessionManager] (authData: (token: String, account: Int)?) -> Bool in
            if let authData = authData {
                let session = HarvestApiSession(accountId: authData.account, personalToken: authData.token)
                sessionManager.set(session: session)
                return true
            } else {
                sessionManager.set(session: nil)
                return false
            }
        }
    }

}