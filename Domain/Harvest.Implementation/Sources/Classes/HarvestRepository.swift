//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_Networking_Api
import RichHarvest_Domain_Harvest_Api

class HarvestRepositoryImplementation: HarvestRepository {

    private let network: HarvestApi
    private let mappers: HarvestRepositoryMappers

    private let schedulers: Schedulers

    init(network: HarvestApi, mappers: HarvestRepositoryMappers, schedulers: Schedulers) {
        self.network = network
        self.mappers = mappers
        self.schedulers = schedulers
    }

    func projects(
        isActive: Bool, clientId: String?, updatedSince: Date?, page: Int, perPage: Int
    ) -> Single<ProjectsPlain> {

        let mapper = mappers.fromApi.toPlain.projects

        return network.projects(
                isActive: isActive,
                clientId: clientId,
                updatedSince: updatedSince,
                page: page,
                perPage: perPage
            )
            .subscribeOn(schedulers.io)
            .observeOn(schedulers.background)
            .map(mapper)

    }

    func project(byId id: Int) -> Single<ProjectDetailPlain> {

        let mapper = mappers.fromApi.toPlain.projectDetail

        return network.project(byId: id)
            .subscribeOn(schedulers.io)
            .observeOn(schedulers.background)
            .map(mapper)

    }

    func taskAssignments(byProjectId id: Int,
                         isActive: Bool,
                         updatedSince since: Date?,
                         page: Int,
                         perPage: Int) -> Single<TaskAssignmentsPlain> {

        let mapper = mappers.fromApi.toPlain.taskAssignments

        return network.taskAssignments(byProjectId: id,
                isActive: isActive,
                updatedSince: since,
                page: page,
                perPage: perPage
            )
            .subscribeOn(schedulers.io)
            .observeOn(schedulers.background)
            .map(mapper)
    }

}
