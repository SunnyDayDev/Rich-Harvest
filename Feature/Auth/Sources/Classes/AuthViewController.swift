//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

public class AuthViewController: NSViewController {

    var viewModel: AuthViewModel!

}

extension AuthViewController {

    func inject(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

}