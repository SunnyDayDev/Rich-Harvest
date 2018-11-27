//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Core_UI

public class RulesViewController: NSViewController {
    
    var viewModel: RulesViewModel!

    private let dispose = DisposeBag()

    deinit {
        Log.debug("Deinited")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else { return }

    }
    
}

extension RulesViewController {

    func inject(viewModel: RulesViewModel) {
        self.viewModel = viewModel
    }

}
