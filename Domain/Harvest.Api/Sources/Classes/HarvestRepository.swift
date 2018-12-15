//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation
import RxSwift

public protocol HarvestRepository {

    func clients(isActive: Bool) -> Single<Clients>

    func projects(isActive: Bool, clientId: Int?, updatedSince: Date?, page: Int, perPage: Int) -> Single<Projects>

    func project(byId: Int) -> Single<ProjectDetail>

    func taskAssignments(byProjectId: Int,
                         isActive: Bool,
                         updatedSince: Date?,
                         page: Int,
                         perPage: Int) -> Single<TaskAssignments>

    func task(byId id: Int) -> Single<TaskDetail>

    func startTimer(withData: StartTimerData) -> Completable

}

public extension HarvestRepository {

    func projects(isActive: Bool = true,
                  clientId: Int? =  nil,
                  updatedSince since: Date? = nil,
                  page: Int = 1,
                  perPage: Int = 100) -> Single<Projects> {
        return projects(isActive: isActive, clientId: clientId, updatedSince: since, page: page, perPage: perPage)
    }

    func taskAssignments(byProjectId id: Int,
                         isActive: Bool = true,
                         updatedSince since: Date? = nil,
                         page: Int = 1,
                         perPage: Int = 100) -> Single<TaskAssignments> {
        return taskAssignments(byProjectId: id, isActive: isActive, updatedSince: since, page: page, perPage: perPage)
    }

    func clients(isActive: Bool = true) -> Single<Clients> {
        return clients(isActive: true)
    }

}