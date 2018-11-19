//
// Created by Александр Цикин on 11.09.2018.
//

import Foundation

import RxSwift

public protocol AppState {

    var active: Observable<Bool> { get }

    var foreground: Observable<Bool> { get }

}