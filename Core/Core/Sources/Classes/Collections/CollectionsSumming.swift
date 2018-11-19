//
// Created by Александр Цикин on 06.09.2018.
//

import Foundation

public func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
    var result: [K: V] = [:]
    result.merge(left) { $1 }
    result.merge(right) { $1 }
    return result
}

public func + <T> (left: [T], right: [T]) -> [T] {
    var result: [T] = []
    result.append(contentsOf: left)
    result.append(contentsOf: right)
    return result
}

//public func - <T> (left: [T], right: [T]) -> [T] {
//    return left.filter { l in !right.contains(where: { (r: T) in l === r }) }
//}