//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

public struct UrlCheckRule {

    public let id: Int?
    public let name: String
    public let priority: Int
    public let projectId: Int
    public let taskId: Int
    public let regex: String

    public init(id: Int? = nil, name: String, priority: Int, projectId: Int, taskId: Int, regex: String) {
        self.id = id
        self.name = name
        self.priority = priority
        self.projectId = projectId
        self.taskId = taskId
        self.regex = regex
    }

}