//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift

public protocol AuthRepository {

    func auth(byPersonalToken token: String, forAccount account: Int) -> Completable

    func restoreSession() -> Single<Bool>

}