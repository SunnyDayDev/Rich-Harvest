//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation
import RichHarvest_Domain_Networking_Api

extension Projects: Codable {

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

extension Links: Codable {

    enum CodingKeys: String, CodingKey {
        case first = "first"
        case next = "next"
        case previous = "previous"
        case last = "last"
    }

}

extension ProjectDetail: Codable {

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

extension Client: Codable {

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case currency = "currency"
    }

}
