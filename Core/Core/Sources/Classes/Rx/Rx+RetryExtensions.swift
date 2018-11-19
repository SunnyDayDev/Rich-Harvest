//
// Created by Александр Цикин on 2018-10-10.
//

import Foundation

import RxSwift

public extension Observable where Element == Error {

    func switchToWait(_ time: TimeInterval, scheduler: SchedulerType) -> Observable<()> {
        return switchMap { _ in RxUtil.wait(time, scheduler: scheduler) }
    }

    func switchToWaitFloating(time: @escaping () -> TimeInterval, scheduler: SchedulerType) -> Observable<()> {
        return switchMap { _ in RxUtil.wait(time(), scheduler: scheduler) }
    }

}