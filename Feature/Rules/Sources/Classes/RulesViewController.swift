//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Core_UI

public class RulesViewController: NSViewController {
    
    @IBOutlet weak var rulesTableView: NSTableView!
    
    private var viewModel: RulesViewModel!

    private let dispose = DisposeBag()

    private var tableViewData: [RuleItemViewModel] = []

    deinit {
        Log.debug("Deinited")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.rulesTableView.dataSource = self
        self.rulesTableView.delegate = self

        self.rulesTableView.usesAutomaticRowHeights = true

        guard let viewModel = self.viewModel else { return }

        viewModel.items
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableViewData = $0
                self.rulesTableView.reloadData()
            })
            .disposed(by: dispose)

    }
    
}

extension RulesViewController {

    func inject(viewModel: RulesViewModel) {
        self.viewModel = viewModel
    }

}

extension RulesViewController: NSTableViewDataSource, NSTableViewDelegate {

    public func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let viewModel = tableViewData.getOrNil(row) else { return nil }
        let cell = tableView.ruleCell()
        cell.bind(viewModel: viewModel)
        return cell
    }

}

class RuleCell: NSTableCellView {

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var regexTextField: NSTextField!
    @IBOutlet weak var clientTextField: NSTextField!
    @IBOutlet weak var projectTextField: NSTextField!
    @IBOutlet weak var taskTextField: NSTextField!
    
    private var dispose: DisposeBag!

    func bind(viewModel: RuleItemViewModel) {

        dispose = DisposeBag()

        viewModel.name.drive(nameTextField.rx.text).disposed(by: dispose)
        viewModel.value.drive(regexTextField.rx.text).disposed(by: dispose)
        viewModel.client.drive(clientTextField.rx.text).disposed(by: dispose)
        viewModel.project.drive(projectTextField.rx.text).disposed(by: dispose)
        viewModel.task.drive(taskTextField.rx.text).disposed(by: dispose)

    }
    
}

extension NSTableView {

    func ruleCell() -> RuleCell {
        return makeView(withIdentifier: NSUserInterfaceItemIdentifier("RuleCell"), owner: nil) as! RuleCell
    }

}
