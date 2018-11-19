//
// Created by Александр Цикин on 05.09.2018.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == CompletableTrait {

    public static func fromAction(_ action: @escaping () throws -> ()) -> Completable {
        return Completable.deferred {
            try action()
            return Completable.empty()
        }
    }

    public static func timer(_ interval: TimeInterval, scheduler: SchedulerType) -> Completable {
        return Observable<Int>.timer(interval, scheduler: scheduler)
            .ignoreElements()
    }

}

public extension PrimitiveSequence where Trait == MaybeTrait {

    public static func fromAction(_ action: @escaping () throws -> ()) -> Maybe<Element> {
        return Maybe.deferred {
            try action()
            return Maybe.empty()
        }
    }

    public static func fromCallable(_ action: @escaping () throws -> Element) -> Maybe<Element> {
        return Maybe.deferred {
            return Maybe.just(try action())
        }
    }

}

public extension PrimitiveSequence where Trait == SingleTrait {

    public static func fromCallable(_ action: @escaping () throws -> Element) -> Single<Element> {
        return Single.deferred {
            return Single.just(try action())
        }
    }

}

public extension Observable {

    public static func fromAction(_ action: @escaping () throws -> ()) -> Observable<Element> {
        return Observable.deferred {
            try action()
            return Observable.empty()
        }
    }

    public static func fromCallable(_ action: @escaping () throws -> Element) -> Observable<Element> {
        return Observable.deferred {
            return Observable.just(try action())
        }
    }

}

public class RxUtil {

    public static func wait(_ time: TimeInterval, scheduler: SchedulerType) -> Single<()> {
        return Single.just(()).delay(time, scheduler: scheduler)
    }

}