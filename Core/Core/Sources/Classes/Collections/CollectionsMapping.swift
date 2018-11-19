//
// Created by Александр Цикин on 06.09.2018.
//

import Foundation

public extension Array {

    public func associate<K, V>(map: (Element) ->(key: K, value: V)) -> [K: V] {
        var result: [K: V] = [:]
        forEach {
            let entry = map($0)
            result[entry.key] = entry.value
        }
        return result
    }

    public func associateNonNil<K, V>(map: (Element) ->(key: K, value: V?)) -> [K: V] {
        var result: [K: V] = [:]
        forEach {
            let entry = map($0)
            if let value = entry.value {
                result[entry.key] = value
            }
        }
        return result
    }

    public func withoutNils<ResultType>() -> [ResultType] where Element == Optional<ResultType> {
        return filter { $0 != nil }
            .map { $0! }
    }

}

public extension Dictionary {

    public func withoutNils<ResultType>() -> [Key: ResultType] where Value == Optional<ResultType> {
        let result: [Key: ResultType] = filter { $0.value != nil }
            .associate { (key: $0.key, value: $0.value!) }
        return result
    }

    public func filter(byKey check: (Key) -> Bool) -> [Key: Value] {
        let result: [Key: Value] = filter { check($0.key) }
            .associate { (key: $0.key, value: $0.value) }
        return result
    }

}