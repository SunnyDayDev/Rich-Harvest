//
// Created by Александр Цикин on 06.09.2018.
//

import Foundation

public func unwrap<T>(_ optional: T?,
                      _ file: String = #file,
                      _ function: String = #function,
                      _ line: Int = #line) throws -> T {

    if let real = optional {
        return real
    } else {
        throw CoreError.unwrapError(file: file, function: function, line: line)
    }

}