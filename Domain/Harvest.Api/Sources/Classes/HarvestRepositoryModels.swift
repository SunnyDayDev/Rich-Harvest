//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

public struct Projects {

    public let projects: [ProjectDetail]
    public let perPage: Int
    public let totalPages: Int
    public let totalEntries: Int
    public let nextPage: Int?
    public let previousPage: Int?
    public let page: Int
    public let links: Links

    public init(projects: [ProjectDetail], perPage: Int, totalPages: Int, totalEntries: Int, nextPage: Int?, previousPage: Int?, page: Int, links: Links) {
        self.projects = projects
        self.perPage = perPage
        self.totalPages = totalPages
        self.totalEntries = totalEntries
        self.nextPage = nextPage
        self.previousPage = previousPage
        self.page = page
        self.links = links
    }

}

public struct Links {

    public let first: String
    public let next: String?
    public let previous: String?
    public let last: String

    public init(first: String, next: String?, previous: String?, last: String) {
        self.first = first
        self.next = next
        self.previous = previous
        self.last = last
    }

}

public struct ProjectDetail {

    public let id: Int
    public let name: String
    public let code: String
    public let isActive: Bool
    public let isBillable: Bool
    public let isFixedFee: Bool
    public let billBy: String
    public let budget: Double?
    public let budgetBy: String
    public let budgetIsMonthly: Bool
    public let notifyWhenOverBudget: Bool
    public let overBudgetNotificationPercentage: Float
    public let showBudgetToAll: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public let startsOn: Date?
    public let endsOn: Date?
    public let overBudgetNotificationDate: Date?
    public let notes: String?
    public let costBudget: Double?
    public let costBudgetIncludeExpenses: Bool
    public let hourlyRate: Double?
    public let fee: Double?
    public let client: Client

    public init(id: Int, name: String, code: String, isActive: Bool, isBillable: Bool, isFixedFee: Bool, billBy: String, budget: Double?, budgetBy: String, budgetIsMonthly: Bool, notifyWhenOverBudget: Bool, overBudgetNotificationPercentage: Float, showBudgetToAll: Bool, createdAt: Date, updatedAt: Date, startsOn: Date?, endsOn: Date?, overBudgetNotificationDate: Date?, notes: String?, costBudget: Double?, costBudgetIncludeExpenses: Bool, hourlyRate: Double?, fee: Double?, client: Client) {
        self.id = id
        self.name = name
        self.code = code
        self.isActive = isActive
        self.isBillable = isBillable
        self.isFixedFee = isFixedFee
        self.billBy = billBy
        self.budget = budget
        self.budgetBy = budgetBy
        self.budgetIsMonthly = budgetIsMonthly
        self.notifyWhenOverBudget = notifyWhenOverBudget
        self.overBudgetNotificationPercentage = overBudgetNotificationPercentage
        self.showBudgetToAll = showBudgetToAll
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.startsOn = startsOn
        self.endsOn = endsOn
        self.overBudgetNotificationDate = overBudgetNotificationDate
        self.notes = notes
        self.costBudget = costBudget
        self.costBudgetIncludeExpenses = costBudgetIncludeExpenses
        self.hourlyRate = hourlyRate
        self.fee = fee
        self.client = client
    }

}

public struct Client {

    public let id: Int
    public let name: String
    public let currency: String

    public init(id: Int, name: String, currency: String) {
        self.id = id
        self.name = name
        self.currency = currency
    }

}

public struct TaskAssignments {

    public let taskAssignments: [TaskAssignment]
    public let perPage: Int
    public let totalPages: Int
    public let totalEntries: Int
    public let nextPage: Int?
    public let previousPage: Int?
    public let page: Int
    public let links: Links

    public init(taskAssignments: [TaskAssignment], perPage: Int, totalPages: Int, totalEntries: Int, nextPage: Int?, previousPage: Int?, page: Int, links: Links) {
        self.taskAssignments = taskAssignments
        self.perPage = perPage
        self.totalPages = totalPages
        self.totalEntries = totalEntries
        self.nextPage = nextPage
        self.previousPage = previousPage
        self.page = page
        self.links = links
    }

}

public struct TaskAssignment {

    public let id: Int
    public let billable: Bool
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public let hourlyRate: Int
    public let budget: Double?
    public let project: Project
    public let task: Task

    public init(id: Int, billable: Bool, isActive: Bool, createdAt: Date, updatedAt: Date, hourlyRate: Int, budget: Double?, project: Project, task: Task) {
        self.id = id
        self.billable = billable
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.hourlyRate = hourlyRate
        self.budget = budget
        self.project = project
        self.task = task
    }

}

public struct Project {

    public let id: Int
    public let name: String
    public let code: String

    public init(id: Int, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }

}

public struct Task {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}

public struct StartTimerData {

    public let projectID: String
    public let taskID: String
    public let spentDate: Date
    public let notes: String
    public let externalReference: ExternalReference

    public init(projectID: String, taskID: String, spentDate: Date, notes: String, externalReference: ExternalReference) {
        self.projectID = projectID
        self.taskID = taskID
        self.spentDate = spentDate
        self.notes = notes
        self.externalReference = externalReference
    }

}

public extension StartTimerData {

    init(projectID: String, taskID: String, spentDate: Date, notes: String, url: String) {

        self.projectID = projectID
        self.taskID = taskID
        self.spentDate = spentDate
        self.notes = notes

        let groupId = Data(url.utf8).base64EncodedString()

        self.externalReference = ExternalReference(
            id: "\(groupId)-\(spentDate.timeIntervalSince1970)",
            groupID: groupId,
            permalink: url
        )

    }

}

public struct ExternalReference {

    public let id: String
    public let groupID: String
    public let permalink: String

    public init(id: String, groupID: String, permalink: String) {
        self.id = id
        self.groupID = groupID
        self.permalink = permalink
    }

}