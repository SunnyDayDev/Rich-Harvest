//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

class HarvestRepositoryMappers {

    var fromApi: FromApi { return FromApi() }

    var fromPlain: FromPlain { return FromPlain() }

    class FromApi {

        var toPlain: ToPlain { return ToPlain() }

        class ToPlain {

            var clients: (ClientsDto) -> ClientsPlain {

                let linksMapper = self.links
                let clientMapper = self.clientDetail

                return { dto in
                    ClientsPlain(
                        clients: dto.clients.map(clientMapper),
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

            var clientDetail: (ClientDetailDto) -> ClientDetailPlain {
                return  { dto in
                    ClientDetailPlain(
                        id: dto.id,
                        name: dto.name,
                        isActive: dto.isActive,
                        address: dto.address,
                        createdAt: dto.createdAt,
                        updatedAt: dto.updatedAt,
                        currency: dto.currency
                    )
                }
            }

            var projects: (ProjectsDto) -> ProjectsPlain {

                let linksMapper = self.links
                let projectMapper = self.projectDetail

                return { dto in
                    ProjectsPlain(
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

            var projectDetail: (ProjectDetailDto) -> ProjectDetailPlain {

                let mapClient = self.client

                return { dto in
                    ProjectDetailPlain(
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
                        createdAt: dto.createdAt.date,
                        updatedAt: dto.updatedAt.date,
                        startsOn: dto.startsOn?.date,
                        endsOn: dto.endsOn?.date,
                        overBudgetNotificationDate: dto.overBudgetNotificationDate?.date,
                        notes: dto.notes,
                        costBudget: dto.costBudget,
                        costBudgetIncludeExpenses: dto.costBudgetIncludeExpenses,
                        hourlyRate: dto.hourlyRate,
                        fee: dto.fee,
                        client: mapClient(dto.client)
                    )
                }
            }

            var client: (ClientDto) -> ClientPlain {
                return { dto in
                    ClientPlain(
                        id: dto.id,
                        name: dto.name,
                        currency: dto.currency
                    )
                }
            }

            var links: (LinksDto) -> LinksPlain {
                return { dto in
                    LinksPlain(
                        first: dto.first,
                        next: dto.next,
                        previous: dto.previous,
                        last: dto.last
                    )
                }
            }

            var taskAssignments: (TaskAssignmentsDto) -> TaskAssignmentsPlain {

                let linksMapper = self.links
                let taskMapper = self.taskAssignment

                return { dto in
                    TaskAssignmentsPlain(
                        taskAssignments: dto.taskAssignments.map(taskMapper),
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

            var taskAssignment: (TaskAssignmentDto) -> TaskAssignmentPlain {

                let projectMapper = self.project
                let taskMapper = self.task

                return { dto in
                    TaskAssignmentPlain(
                        id: dto.id,
                        billable: dto.billable,
                        isActive: dto.isActive,
                        createdAt: dto.createdAt.date,
                        updatedAt: dto.updatedAt.date,
                        hourlyRate: dto.hourlyRate,
                        budget: dto.budget,
                        project: projectMapper(dto.project),
                        task: taskMapper(dto.task)
                    )
                }
            }

            var project: (ProjectDto) -> ProjectPlain {
                return { dto in
                    ProjectPlain(
                        id: dto.id,
                        name: dto.name,
                        code: dto.code
                    )
                }
            }

            var task: (TaskDto) -> TaskPlain {
                return { dto in
                    TaskPlain(
                        id: dto.id,
                        name: dto.name
                    )
                }
            }

            var taskDetail: (TaskDetailDto) -> TaskDetailPlain {
                return { dto in
                    TaskDetailPlain(
                        id: dto.id,
                        name: dto.name,
                        billableByDefault: dto.billableByDefault,
                        defaultHourlyRate: dto.defaultHourlyRate,
                        isDefault: dto.isDefault,
                        isActive: dto.isActive,
                        createdAt: dto.createdAt,
                        updatedAt: dto.updatedAt
                    )
                }
            }

        }

    }

    class FromPlain {

        var toApi: ToApi { return ToApi() }

        class ToApi {

            var startTimerData: (StartTimerDataPlain) -> StartTimerDataDto {

                let referenceMapper = self.externalReference

                return { plain in
                    StartTimerDataDto(
                        projectID: plain.projectID,
                        taskID: plain.taskID,
                        spentDate: plain.spentDate,
                        notes: plain.notes,
                        externalReference: referenceMapper(plain.externalReference)
                    )
                }

            }

            var externalReference: (ExternalReferencePlain) -> ExternalReferenceDto {
                return { plain in
                    ExternalReferenceDto(
                        id: plain.id,
                        groupID: plain.groupID,
                        permalink: plain.permalink
                    )
                }
            }

        }

    }

}