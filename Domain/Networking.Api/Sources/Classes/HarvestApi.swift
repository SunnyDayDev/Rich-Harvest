//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation
import RxSwift

import RichHarvest_Core_Core

public enum NetworkError: RichHarvestError {
    case http(code: Int)
    case sessionNotExists
}

public protocol HarvestApi {

    func projects(isActive: Bool, clientId: String?, updatedSince: Date?, page: Int, perPage: Int) -> Single<Projects>

    func project(byId: Int) -> Single<ProjectDetail>

    func taskAssignments(byProjectId: Int,
                         isActive: Bool,
                         updatedSince: Date?,
                         page: Int,
                         perPage: Int) -> Single<TaskAssignments>

    func startTimer(withData: StartTimerData) -> Single<StartTimerData>

}

public extension HarvestApi {

    func projects(
        isActive: Bool = true,
        clientId: String? =  nil,
        updatedSince since: Date? = nil,
        page: Int = 1,
        perPage: Int = 100
    ) -> Single<Projects> {
        return projects(isActive: isActive, clientId: clientId, updatedSince: since, page: page, perPage: perPage)
    }

    func taskAssignments(byProjectId id: Int,
                         isActive: Bool = true,
                         updatedSince since: Date? = nil,
                         page: Int = 1,
                         perPage: Int = 100) -> Single<TaskAssignments> {
        return taskAssignments(byProjectId: id, isActive: isActive, updatedSince: since, page: page, perPage: perPage)
    }

}