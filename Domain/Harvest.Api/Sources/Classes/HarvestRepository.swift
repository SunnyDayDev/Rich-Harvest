//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation
import RxSwift

public protocol HarvestRepository {

    func projects(isActive: Bool, clientId: String?, updatedSince: Date?, page: Int, perPage: Int) -> Single<Projects>

    func project(byId: Int) -> Single<ProjectDetail>

}

public extension HarvestRepository {

    func projects(isActive: Bool = true,
                  clientId: String? =  nil,
                  updatedSince: Date? = nil,
                  page: Int,
                  perPage: Int = 100) -> Single<Projects> {
        return projects(isActive: isActive, clientId: clientId, updatedSince: updatedSince, page: page, perPage: perPage)
    }

}