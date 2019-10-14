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

    func clients(isActive: Bool) -> Single<Clients>

    func client(byId: Int) -> Single<ClientDetail>

    func projects(isActive: Bool, clientId: Int?, updatedSince: Date?, page: Int, perPage: Int) -> Single<Projects>

    func project(byId: Int) -> Single<ProjectDetail>

    func taskAssignments(byProjectId: Int,
                         isActive: Bool,
                         updatedSince: Date?,
                         page: Int,
                         perPage: Int) -> Single<TaskAssignments>

    func task(byId: Int) -> Single<TaskDetail>

    func startTimer(withData: StartTimerData) -> Single<StartTimerData>

}

public extension HarvestApi {

    func clients(isActive: Bool = true) -> Single<Clients> {
        return clients(isActive: true)
    }

    func projects(
        isActive: Bool = true,
        clientId: Int? =  nil,
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