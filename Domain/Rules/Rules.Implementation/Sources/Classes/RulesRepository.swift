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
        UrlCheckRule(
            id: 0,
            name: "Gpost",
            priority: 0,
            rule: .regex(expr: "https?:\\/\\/gpostcorp\\.atlassian\\.net.*?"),
            result: UrlCheckRule.Result(
                clientId: 5211231,
                projectId: 18460971,
                taskId: 7180373
            )
        ),
        UrlCheckRule(
            id: 0,
            name: "Gpost.iOS-Programming",
            priority: 1,
            rule: .regex(expr: "https?:\\/\\/gpostcorp\\.atlassian\\.net.*?GI-.*?"),
            result: UrlCheckRule.Result(
                clientId: 5211231,
                projectId: 18460971,
                taskId: 7180373
            )
        ),
        UrlCheckRule(
            id: 0,
            name: "Gpost.Android-Programming",
            priority: 1,
            rule: .regex(expr: "https?:\\/\\/gpostcorp\\.atlassian\\.net.*?GA-.*?"),
            result: UrlCheckRule.Result(
                clientId: 5211231,
                projectId: 18093581,
                taskId: 7180373
            )
        ),
        UrlCheckRule(
            id: 0,
            name: "Driver.1331",
            priority: 0,
            rule: .regex(expr: "https?:\\/\\/trello.com/b/RGwDru6e/.*?$"),
            result: UrlCheckRule.Result(
                clientId: 5233777,
                projectId: 19229808,
                taskId: 7180373
            )
        ),
        UrlCheckRule(
            id: 0,
            name: "IMA",
            priority: 0,
            rule: .regex(expr: "https?:\\/\\/redmine.idd.group.*?$"),
            result: UrlCheckRule.Result(clientId: 5211222)
        )
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
                    rule: rule.rule,
                    result: rule.result
                ))
            } else {
                RulesRepositoryImplementation.memoryRules.append(rule)
            }
            changedSubject.on(.next(()))
        }
    }

}
