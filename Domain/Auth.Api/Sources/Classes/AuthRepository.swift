//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift

public enum Authorization {
    case personalToken(token: String, account: Int)
}

public protocol AuthRepository {

    func auth(byPersonalToken token: String, forAccount account: Int) -> Completable

    func storedAuthorization() -> Observable<Authorization?>

    func restoreSession() -> Single<Bool>

}