//
// Created by Александр Цикин on 05.09.2018.
//

import Foundation
import RxSwift

struct SwitchMapInterruption: Error { }

public extension Observable {

    public func firstElement() -> Maybe<Element> {
        return take(1).asMaybe()
    }

    public func firstOrError() -> Single<Element> {
        return take(1).asSingle()
    }

    public func flatMapCompletable(_ map: @escaping (Element) throws -> Completable) -> Completable {
        return flatMap { try map($0).asObservable() } .ignoreElements()
    }

    public func flatMapMaybe<T>(_ map: @escaping (Element) throws -> Maybe<T>) -> Observable<T> {
        return flatMap { try map($0).asObservable() }
    }

    public func flatMapSingle<T>(_ map: @escaping (Element) throws -> Single<T>) -> Observable<T> {
        return flatMap { try map($0).asObservable() }
    }

    public func switchMap<O: ObservableConvertibleType>(_ map: @escaping (Element) throws -> O) -> Observable<O.E> {
        return self.map { try map($0) } .switchLatest()
    }

    public func switchMapCompletable(_ map: @escaping (Element) throws -> Completable) -> Completable {
        return switchMap { try map($0).asObservable() } .ignoreElements()
    }

    public func switchMapMaybe<T>(_ map: @escaping (Element) throws -> Maybe<T>) -> Observable<T> {
        return switchMap { try map($0).asObservable() }
    }

    public func switchMapSingle<T>(_ map: @escaping (Element) throws -> Single<T>) -> Observable<T> {
        return switchMap { try map($0).asObservable() }
    }

    public func mapNonNil<T>(_ map: @escaping (Element) throws -> T?) -> Observable<T> {
        return self.map { try map($0) }
            .filter { $0 != nil }
            .map { $0! }
    }

}

public extension Observable where Element: Equatable {

    public func distinctUntilChanged() -> Observable<Element> {
        return self.distinctUntilChanged(==)
    }

}

public extension PrimitiveSequence where Trait == SingleTrait {

    public func flatMapObservable<T>(_ map: @escaping (Element) throws -> Observable<T>) -> Observable<T> {
        return asObservable().flatMap(map)
    }

}

public extension PrimitiveSequence where Trait == MaybeTrait {

    public func flatMapCompletable(_ map: @escaping (Element) throws -> Completable) -> Completable {
        return asObservable().flatMapCompletable(map)
    }

}

public extension PrimitiveSequence where Trait == CompletableTrait {

    public func share(scope: SubjectLifetimeScope) -> Completable {
        return asObservable().share(scope: scope).ignoreElements()
    }

}