//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core

public class AuthViewController: NSViewController {

    @IBOutlet weak var personalTokenTextField: NSTextField!
    @IBOutlet weak var accountIdTextField: NSTextField!
    @IBOutlet weak var applyButton: NSButton!
    
    var viewModel: AuthViewModel!

    private let dispose = DisposeBag()

    deinit {
        Log.debug("Deinited")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else { return }

        applyButton.rx.tap.bind(to: viewModel.applyTap).disposed(by: dispose)

        personalTokenTextField.rx.text
            .map { $0 ?? "" }
            .filter { viewModel.personalToken.value != $0 }
            .bind(to: viewModel.personalToken)
            .disposed(by: dispose)

        viewModel.personalToken
            .filter { [weak self] in self?.personalTokenTextField.stringValue != $0 }
            .bind(to: personalTokenTextField.rx.text)
            .disposed(by: dispose)

        accountIdTextField.rx.text
            .map { $0 ?? "" }
            .filter { viewModel.accountId.value != $0 }
            .bind(to: viewModel.accountId)
            .disposed(by: dispose)

        viewModel.accountId
            .filter { [weak self] in self?.accountIdTextField.stringValue != $0 }
            .bind(to: accountIdTextField.rx.text)
            .disposed(by: dispose)

    }
    
}

extension AuthViewController {

    func inject(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

}
