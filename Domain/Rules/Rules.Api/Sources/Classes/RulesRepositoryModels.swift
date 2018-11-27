//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

public struct UrlCheckRule {
    public let id: Int
    public let name: String
    public let priority: Int
    public let projectId: Int
    public let taskId: Int
    public let regex: String
}