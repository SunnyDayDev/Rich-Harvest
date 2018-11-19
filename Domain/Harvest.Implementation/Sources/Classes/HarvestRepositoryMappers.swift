//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import RichHarvest_Domain_Networking_Api
import RichHarvest_Domain_Harvest_Api

class HarvestRepositoryMappers {

    var fromApi: FromApi { return FromApi() }

    class FromApi {

        var toPlain: ToPlain { return ToPlain() }

        class ToPlain {

            var projects: (RichHarvest_Domain_Networking_Api.Projects) -> RichHarvest_Domain_Harvest_Api.Projects {

                let linksMapper = self.links
                let projectMapper = self.project

                return { dto in
                    RichHarvest_Domain_Harvest_Api.Projects(
                        projects: dto.projects.map(projectMapper),
                        perPage: dto.perPage,
                        totalPages: dto.totalPages,
                        totalEntries: dto.totalEntries,
                        nextPage: dto.nextPage,
                        previousPage: dto.previousPage,
                        page: dto.page,
                        links: linksMapper(dto.links)
                    )
                }
            }

            var project: (RichHarvest_Domain_Networking_Api.ProjectDetail) -> RichHarvest_Domain_Harvest_Api.ProjectDetail {

                let mapClient = self.client

                return { dto in
                    RichHarvest_Domain_Harvest_Api.ProjectDetail(
                        id: dto.id,
                        name: dto.name,
                        code: dto.code,
                        isActive: dto.isActive,
                        isBillable: dto.isBillable,
                        isFixedFee: dto.isFixedFee,
                        billBy: dto.billBy,
                        budget: dto.budget,
                        budgetBy: dto.budgetBy,
                        budgetIsMonthly: dto.budgetIsMonthly,
                        notifyWhenOverBudget: dto.notifyWhenOverBudget,
                        overBudgetNotificationPercentage: dto.overBudgetNotificationPercentage,
                        showBudgetToAll: dto.showBudgetToAll,
                        createdAt: dto.createdAt,
                        updatedAt: dto.updatedAt,
                        startsOn: dto.startsOn,
                        endsOn: dto.endsOn,
                        overBudgetNotificationDate: dto.overBudgetNotificationDate,
                        notes: dto.notes,
                        costBudget: dto.costBudget,
                        costBudgetIncludeExpenses: dto.costBudgetIncludeExpenses,
                        hourlyRate: dto.hourlyRate,
                        fee: dto.fee,
                        client: mapClient(dto.client)
                    )
                }
            }

            var client: (RichHarvest_Domain_Networking_Api.Client) -> RichHarvest_Domain_Harvest_Api.Client {
                return { dto in
                    RichHarvest_Domain_Harvest_Api.Client(
                        id: dto.id,
                        name: dto.name,
                        currency: dto.currency
                    )
                }
            }

            var links: (RichHarvest_Domain_Networking_Api.Links) -> RichHarvest_Domain_Harvest_Api.Links {
                return { dto in
                    RichHarvest_Domain_Harvest_Api.Links(
                        first: dto.first,
                        next: dto.next,
                        previous: dto.previous,
                        last: dto.last
                    )
                }
            }

        }

    }

}