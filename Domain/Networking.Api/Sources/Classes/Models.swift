//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation

public struct Projects: Codable {

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

    enum CodingKeys: String, CodingKey {
        case projects = "projects"
        case perPage = "per_page"
        case totalPages = "total_pages"
        case totalEntries = "total_entries"
        case nextPage = "next_page"
        case previousPage = "previous_page"
        case page = "page"
        case links = "links"
    }

}

public struct Links: Codable {

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

    enum CodingKeys: String, CodingKey {
        case first = "first"
        case next = "next"
        case previous = "previous"
        case last = "last"
    }

}

public struct ProjectDetail: Codable {

    public let id: Int
    public let name: String
    public let code: String
    public let isActive: Bool
    public let isBillable: Bool
    public let isFixedFee: Bool
    public let billBy: String
    public let budget: Double
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
    public let notes: String
    public let costBudget: Double?
    public let costBudgetIncludeExpenses: Bool
    public let hourlyRate: Double
    public let fee: Double?
    public let client: Client

    public init(id: Int, name: String, code: String, isActive: Bool, isBillable: Bool, isFixedFee: Bool, billBy: String, budget: Double, budgetBy: String, budgetIsMonthly: Bool, notifyWhenOverBudget: Bool, overBudgetNotificationPercentage: Float, showBudgetToAll: Bool, createdAt: Date, updatedAt: Date, startsOn: Date?, endsOn: Date?, overBudgetNotificationDate: Date?, notes: String, costBudget: Double?, costBudgetIncludeExpenses: Bool, hourlyRate: Double, fee: Double?, client: Client) {
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

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case code = "code"
        case isActive = "is_active"
        case isBillable = "is_billable"
        case isFixedFee = "is_fixed_fee"
        case billBy = "bill_by"
        case budget = "budget"
        case budgetBy = "budget_by"
        case budgetIsMonthly = "budget_is_monthly"
        case notifyWhenOverBudget = "notify_when_over_budget"
        case overBudgetNotificationPercentage = "over_budget_notification_percentage"
        case showBudgetToAll = "show_budget_to_all"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case startsOn = "starts_on"
        case endsOn = "ends_on"
        case overBudgetNotificationDate = "over_budget_notification_date"
        case notes = "notes"
        case costBudget = "cost_budget"
        case costBudgetIncludeExpenses = "cost_budget_include_expenses"
        case hourlyRate = "hourly_rate"
        case fee = "fee"
        case client = "client"
    }

}

public struct Client: Codable {

    public let id: Int
    public let name: String
    public let currency: String

    public init(id: Int, name: String, currency: String) {
        self.id = id
        self.name = name
        self.currency = currency
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case currency = "currency"
    }

}
