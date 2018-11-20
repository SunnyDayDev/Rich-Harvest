//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation
import RxSwift

import RichHarvest_Core_Core

protocol AuthStore {

    func storePersonalToken(_ token: String, forAccount account: Int) -> Completable

    func getPersonalToken() -> Single<(token: String, account: Int)?>

}

class AuthStoreImplementation: AuthStore {

    private let ud = UserDefaults.standard

    func storePersonalToken(_ token: String, forAccount account: Int) -> Completable {
        return Completable.fromAction { [ud] in
            ud.set(token, forKey: "RichHarvest.AuthStore.personalToken")
            ud.set(account, forKey: "RichHarvest.AuthStore.account")
        }
    }

    func getPersonalToken() -> Single<(token: String, account: Int)?> {
        return Single.fromCallable { [ud] in
            guard
                let token = ud.string(forKey: "RichHarvest.AuthStore.personalToken"),
                let account = ud.object(forKey: "RichHarvest.AuthStore.account") as? Int
            else {
                return nil
            }
            return (token: token, account: account)
        }
    }

}