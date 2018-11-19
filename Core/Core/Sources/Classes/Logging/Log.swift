//
// Created by Александр Цикин on 05.09.2018.
//

import Foundation

import SwiftyBeaver

public struct Log {

    private static let log = SwiftyBeaver.self

    public static func initLogger(destinations: BaseDestination...) {
        destinations.forEach { log.addDestination($0) }
    }

    public static func verbose(_ message: @autoclosure () -> Any,
                               _ file: String = #file,
                               _ function: String = #function,
                               line: Int = #line,
                               context: Any? = nil) {
        log.verbose(message, file, function, line: line, context: context)
    }

    public static func debug(_ message: @autoclosure () -> Any,
                             _ file: String = #file,
                             _ function: String = #function,
                             line: Int = #line,
                             context: Any? = nil) {
        log.debug(message, file, function, line: line, context: context)
    }

    public static func info(_ message: @autoclosure () -> Any,
                            _ file: String = #file,
                            _ function: String = #function,
                            line: Int = #line,
                            context: Any? = nil) {
        log.info(message, file, function, line: line, context: context)
    }

    public static func warning(_ message: @autoclosure () -> Any,
                               _ file: String = #file,
                               _ function: String = #function,
                               line: Int = #line,
                               context: Any? = nil) {
        log.warning(message, file, function, line: line, context: context)
    }

    public static func error(_ message: @autoclosure () -> Any,
                             _ file: String = #file,
                             _ function: String = #function,
                             line: Int = #line,
                             context: Any? = nil) {
        log.error(message, file, function, line: line, context: context)
    }

    public static func error(_ error: Error,
                             _ file: String = #file,
                             _ function: String = #function,
                             line: Int = #line) {
        log.error("Error happen: \(error)", file, function, line: line, context: error)
    }

}