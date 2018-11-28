//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import RxSwift

import RichHarvest_Core_Core
import RichHarvest_Domain_Rules_Api

class RulesRepositoryImplementation: RulesRepository {

    private let mappers: RulesRepositoryMappers

    private let schedulers: Schedulers

    private static var memoryRules: [UrlCheckRule] = [
        UrlCheckRule(id: 0, name: "Test rule 1", priority: 0, projectId: 19229808, taskId: 10936105, regex: "http.*?gpost.*?")
    ]

    private let changedSubject = PublishSubject<()>()

    init(mappers: RulesRepositoryMappers, schedulers: Schedulers) {
        self.mappers = mappers
        self.schedulers = schedulers
    }

    func rules() -> Observable<[UrlCheckRule]> {
        return changedSubject.startWith(()).flatMap {
            Observable.just(RulesRepositoryImplementation.memoryRules)
        }
    }

    func store(rule: UrlCheckRule) -> Completable {
        return Completable.fromAction { [changedSubject] in
            RulesRepositoryImplementation.memoryRules.removeAll(where: { $0.id ==  rule.id })
            if rule.id == nil {
                let lastId = RulesRepositoryImplementation.memoryRules.map { $0.id ?? -1 } .max() ?? 0
                RulesRepositoryImplementation.memoryRules.append(UrlCheckRule(
                    id: lastId,
                    name: rule.name,
                    priority: rule.priority,
                    projectId: rule.projectId,
                    taskId: rule.taskId,
                    regex: rule.regex
                ))
            } else {
                RulesRepositoryImplementation.memoryRules.append(rule)
            }
            changedSubject.on(.next(()))
        }
    }

}
