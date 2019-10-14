//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

import FirebaseDatabase

import RichHarvest_Domain_Rules_Api

class RulesRepositoryMappers {

    let fromFirebase: FromFirebaseRulesRepositoryMapper = FromFirebaseRulesRepositoryMapper()

}

class FromFirebaseRulesRepositoryMapper {
    
    var urlCheckRule: (DataSnapshot) -> UrlCheckRule {
        
        let ruleMapper = urlCheckRuleRule
        let resultMapper = urlCheckRuleResult
        
        return { (snapshot) in
            
            let dict: [String: Any] = snapshot.value as! [String: Any]
            
            return UrlCheckRule(
                id: dict["id"] as! Int?,
                name: dict["name"] as! String,
                priority: dict["priority"] as! Int,
                rule: ruleMapper(snapshot.childSnapshot(forPath: "rule")),
                result: resultMapper(snapshot.childSnapshot(forPath: "result")))
            
        }
        
    }
    
    private var urlCheckRuleResult: (DataSnapshot) -> UrlCheckRule.Result {
        { (snapshot) in
            
            let resultDict: [String: Any] = snapshot.value as! [String: Any]
            
            return UrlCheckRule.Result(
                clientId: resultDict["clientId"] as? Int ?? UrlCheckRule.UNSPECIFIED,
                projectId: resultDict["projectId"] as? Int ?? UrlCheckRule.UNSPECIFIED,
                taskId: resultDict["taskId"] as? Int ?? UrlCheckRule.UNSPECIFIED)
            
        }
    }
    
    private var urlCheckRuleRule: (DataSnapshot) -> UrlCheckRule.Rule {
        { (snapshot) in
            
            let ruleDict: [String: Any] = snapshot.value as! [String: Any]
            
            switch ruleDict["type"] as! String {
            case "regex":
                return .regex(expr: ruleDict["value"] as! String)
            default: fatalError("Unknown rule type")
            }
            
        }
    }
    
}