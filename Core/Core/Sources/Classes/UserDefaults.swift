//
// Created by Александр Цикин on 2018-11-21.
//

import Foundation

import RxSwift
import RxCocoa

public extension UserDefaults {

    static var shared: UserDefaults {
        return UserDefaults(suiteName: "me.sunnydaydev.RichHarvest")!
    }

    func eTag(name: String) -> UserDefaultETag {
        return UserDefaultETag(userDefaults: self, tag: name)
    }

}

public class UserDefaultETag {

    private let ud: UserDefaults
    private let tag: String

    public let value: Observable<String?>

    init(userDefaults: UserDefaults, tag: String) {

        self.ud = userDefaults
        self.tag = tag

        value = userDefaults.rx
            .observe(String.self, tag)
            .distinctUntilChanged()
            .share(replay: 1, scope: .whileConnected)

    }

    public func markChanged(uuid: UUID = UUID()) {
        ud.set(uuid.uuidString, forKey: tag)
        ud.synchronize()
    }

}

