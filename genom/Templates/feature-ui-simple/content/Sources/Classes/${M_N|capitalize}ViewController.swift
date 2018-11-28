//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Core_UI

public class ${M_N|capitalize}ViewController: NSViewController {
    
    private var viewModel: ${M_N|capitalize}ViewModel!

    private let dispose = DisposeBag()

    deinit {
        Log.debug("Deinited")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else { return }

    }
    
}

extension ${M_N|capitalize}ViewController {

    func inject(viewModel: ${M_N|capitalize}ViewModel) {
        self.viewModel = viewModel
    }

}
