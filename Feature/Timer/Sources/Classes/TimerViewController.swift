//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core

public class TimerViewController: NSViewController {

    @IBOutlet weak var clientsPopUpButton: NSPopUpButton!
    @IBOutlet weak var projectsPopUpButton: NSPopUpButton!
    @IBOutlet weak var tasksPopUpButton: NSPopUpButton!
    @IBOutlet weak var urlLabel: NSTextField!
    @IBOutlet weak var notesTextField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    
    var viewModel: TimerViewModel!
    
    private let dispose = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()

        urlLabel.maximumNumberOfLines = 5

        guard let viewModel = self.viewModel else { return }

        // TODO: generalize NSPopUpButton binding

        bindPopUpButton(
            button: clientsPopUpButton,
            source: viewModel.clients,
            selectionSource: viewModel.selectedClient
        )

        bindPopUpButton(
            button: projectsPopUpButton,
            source: viewModel.projects,
            selectionSource: viewModel.selectedProject
        )

        bindPopUpButton(
            button: tasksPopUpButton,
            source: viewModel.tasks,
            selectionSource: viewModel.selectedTask
        )

        viewModel.url.drive(urlLabel.rx.text).disposed(by: dispose)

        viewModel.notes
            .filter { [unowned self] in self.notesTextField.stringValue != $0 }
            .bind(to: notesTextField.rx.text)
            .disposed(by: dispose)

        notesTextField.rx.text
            .map { $0 ?? "" }
            .filter { [unowned self] in self.viewModel.notes.value != $0 }
            .bind(to: viewModel.notes)
            .disposed(by: dispose)

        startButton.rx.tap.bind(to: viewModel.startTap).disposed(by: dispose)

    }

    public override func viewWillAppear() {
        super.viewWillAppear()
        viewModel.viewWillAppear()
    }
    
    @IBAction func clientSelected(_ sender: Any) {
        selectionChanged(button: clientsPopUpButton, selectionSource: viewModel.selectedClient)
    }
    
    @IBAction func projectSelected(_ sender: Any) {
        selectionChanged(button: projectsPopUpButton, selectionSource: viewModel.selectedProject)
    }
    
    @IBAction func taskSelected(_ sender: Any) {
        selectionChanged(button: tasksPopUpButton, selectionSource: viewModel.selectedTask)
    }

    private func bindPopUpButton(button: NSPopUpButton, source: Driver<[String]>, selectionSource: BehaviorRelay<Int>) {

        source
            .drive(onNext: { (values: [String]) in
                button.removeAllItems()
                button.addItems(withTitles: values)
            })
            .disposed(by: dispose)

        source
            .flatMap { _ in selectionSource.asDriver() }
            .drive(onNext: { (position: Int) in
                button.selectItem(at: position)
            })
            .disposed(by: dispose)

    }

    private func selectionChanged(button: NSPopUpButton, selectionSource: BehaviorRelay<Int>) {
        guard let item = button.selectedItem,
              let index = button.menu?.items.firstIndex(of: item)
            else { return }
        selectionSource.accept(index)
    }
    
}

extension TimerViewController {

    func inject(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }

}
