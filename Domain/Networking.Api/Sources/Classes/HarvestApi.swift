//
// Created by Александр Цикин on 2018-11-18.
//

import Foundation
import RxSwift

import RichHarvest_Core_Core

public enum NetworkError: RichHarvestError {
    case http(code: Int)
}

public protocol HarvestApi {

    func projects(isActive: Bool, clientId: String?, updatedSince: Date?, page: Int, perPage: Int) -> Single<Projects>

    func project(byId: Int) -> Single<ProjectDetail>

}

public extension HarvestApi {

    func projects(isActive: Bool = true, clientId: String? =  nil, updatedSince: Date? = nil, page: Int, perPage: Int = 100) -> Single<Projects> {
        return projects(isActive: isActive, clientId: clientId, updatedSince: updatedSince, page: page, perPage: perPage)
    }

}