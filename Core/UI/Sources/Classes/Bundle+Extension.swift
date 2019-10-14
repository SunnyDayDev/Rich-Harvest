//
// Created by Александр Цикин on 2018-11-27.
//

import Foundation

public extension Bundle {

    static var uiCore: Bundle {
        let podBundle = Bundle(for: UIUtil.self)
        return Bundle(url: podBundle.url(forResource: "RichHarvest.Core.UI", withExtension: "bundle")!)!
    }

}