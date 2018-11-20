//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

import RxSwift

import RichHarvest_Domain_Networking_Api

class HarvestApiSessionManagerImplementation: HarvestApiSessionManager {

    private let sessionState = BehaviorSubject<State>(value: .wait)

    var session: Observable<HarvestApiSession?> {
        return sessionState
            .flatMap { (state: HarvestApiSessionManagerImplementation.State) -> Observable<HarvestApiSession?> in
                if case let .ready(session) = state { return Observable.just(session) }
                else { return Observable.empty() }
            }
    }

    func set(session: HarvestApiSession?) {
        sessionState.on(.next(.ready(session: session)))
    }

    private enum State {
        case ready(session: HarvestApiSession?)
        case wait
    }

}