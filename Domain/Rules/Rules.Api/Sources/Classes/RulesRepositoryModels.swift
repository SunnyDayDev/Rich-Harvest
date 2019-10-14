//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

public struct UrlCheckRule {

    public static let UNSPECIFIED = -1

    public enum Rule {
        case regex(expr: String)
    }

    public let id: Int?
    public let name: String
    public let priority: Int
    public let rule: Rule
    public let result: Result

    public init(id: Int?,
                name: String,
                priority: Int,
                rule: Rule,
                result: Result) {
        self.id = id
        self.name = name
        self.priority = priority
        self.rule = rule
        self.result = result
    }

    public struct Result {

        public let clientId: Int
        public let projectId: Int
        public let taskId: Int

        public init(clientId: Int = UrlCheckRule.UNSPECIFIED,
                    projectId: Int = UrlCheckRule.UNSPECIFIED,
                    taskId: Int = UrlCheckRule.UNSPECIFIED) {
            self.clientId = clientId
            self.projectId = projectId
            self.taskId = taskId
        }

    }

}