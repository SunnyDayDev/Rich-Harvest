//
// Created by Александр Цикин on 06.09.2018.
//

import Foundation

public protocol RichHarvestError: Error { }

public enum CoreError: RichHarvestError, Error, CustomDebugStringConvertible {

    case notImplemented(message: String?)

    case unwrapError(file: String, function: String, line: Int)

    case selfIsNil

    public var debugDescription: String {

        switch (self) {

        case .unwrapError(let file, let function, let line):

            let fileName: String

            if let index = file.range(of: "/", options: .backwards)?.lowerBound {
                fileName = file.substring(from: file.index(index, offsetBy: 1))
            } else {
                fileName = file
            }

            return "Unexpectedly found nil while unwrapping an Optional value: \(fileName).\(function)(\(line))"

        case .notImplemented(let message):
            return "Not implemented\(message.map { ": \($0)" } ?? "")"

        case .selfIsNil:
            return "Weaked self is nil."

        }

    }

}