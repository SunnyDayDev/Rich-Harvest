//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation
import RxSwift

public protocol HarvestApiSessionManager {

    var session: Observable<HarvestApiSession?> { get }

    func set(session: HarvestApiSession?)

}

public struct HarvestApiSession {

    public let accountId: Int
    public let personalToken: String

    public init(accountId: Int, personalToken: String) {
        self.accountId = accountId
        self.personalToken = personalToken
    }

}