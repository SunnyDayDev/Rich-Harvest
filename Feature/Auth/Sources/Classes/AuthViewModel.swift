//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RichHarvest_Domain_Auth_Api

class AuthViewModel {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

}