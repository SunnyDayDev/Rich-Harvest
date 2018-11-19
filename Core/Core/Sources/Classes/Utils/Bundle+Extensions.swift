//
// Created by Александр Цикин on 14.09.2018.
//

import Foundation

public extension Bundle {

    public var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

}