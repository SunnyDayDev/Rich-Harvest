//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

public class TimerViewController: NSViewController {

    var viewModel: TimerViewModel!

}

extension TimerViewController {

    func inject(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }

}