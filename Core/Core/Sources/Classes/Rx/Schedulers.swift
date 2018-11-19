//
// Created by Александр Цикин on 06.09.2018.
//

import Foundation
import RxSwift

public struct Schedulers {

    public var ui: SchedulerType {
        return MainScheduler.asyncInstance
    }

    public var io: SchedulerType {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }

    public var background: SchedulerType {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }

}