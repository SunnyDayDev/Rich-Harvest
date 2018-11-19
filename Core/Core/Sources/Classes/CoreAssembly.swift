//
// Created by Александр Цикин on 06.09.2018.
//

import Foundation
import Swinject

public class CoreAssembly: Assembly {

    public init() {

    }

    public func assemble(container: Container) {

        container.register(Schedulers.self) { _ in Schedulers() }

        container.register(FileManager.self) { _ in FileManager.default }

    }

}