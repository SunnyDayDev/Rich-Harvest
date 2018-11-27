//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation
import RxSwift

public protocol RulesRepository {

    func rules() -> Observable<[UrlCheckRule]>

    func store(rule: UrlCheckRule) -> Completable

}