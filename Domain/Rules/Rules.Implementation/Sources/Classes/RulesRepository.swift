//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import RxSwift
import FirebaseDatabase

import RichHarvest_Core_Core
import RichHarvest_Domain_Rules_Api

class RulesRepositoryImplementation: RulesRepository {

    private let mappers: RulesRepositoryMappers

    private let schedulers: Schedulers
    
    private let dataBase: Database

    init(mappers: RulesRepositoryMappers, schedulers: Schedulers, database: Database) {
        self.mappers = mappers
        self.schedulers = schedulers
        self.dataBase = database
    }

    func rules() -> Observable<[UrlCheckRule]> {
        let mapper = mappers.fromFirebase.urlCheckRule
        
        return Observable<[UrlCheckRule]>.create { [dataBase] observer in
            let reference = dataBase.reference()
                .child("rules")
                .queryOrdered(byChild: "priority")
            
            Log.debug("Start observe rules.")
            
            let refHandle = reference.observe(.value) { (snapshot: DataSnapshot) in
                Log.debug("Handle rules (count \(snapshot.childrenCount).")
            
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    let rules: [UrlCheckRule] = snapshots.reversed()
                        .map(mapper)
                    
                    observer.on(.next(rules))
                } else {
                    Log.debug("Incompatible data type")
                    observer.on(.next([]))
                }
            }
            
            return Disposables.create {
                reference.removeObserver(withHandle: refHandle)
            }
        }
    }

    func store(rule: UrlCheckRule) -> Completable {
        Completable.fromAction {
            fatalError("Not implemented")
        }
    }

    func deleteRule(byId id: Int) -> Completable {
        Completable.fromAction {
            fatalError("Not implemented")
        }
    }

}
