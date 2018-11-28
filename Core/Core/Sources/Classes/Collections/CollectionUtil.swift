//
// Created by Александр Цикин on 2018-11-28.
//

import Foundation

public extension Array {

    func getOrNil(_ index: Int) -> Element? {
        if case 0..<count = index {
            return self[index]
        } else {
            return nil
        }
    }

}