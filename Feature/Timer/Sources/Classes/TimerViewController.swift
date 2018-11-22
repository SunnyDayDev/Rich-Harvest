//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core

public class TimerViewController: NSViewController {

    @IBOutlet weak var projectsPopUpButton: NSPopUpButton!
    @IBOutlet weak var tasksPopUpButton: NSPopUpButton!
    @IBOutlet weak var urlLabel: NSTextField!
    @IBOutlet weak var notesTextField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    
    var viewModel: TimerViewModel!
    
    private let dispose = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else { return }

        viewModel.projects
            .drive(onNext: { [weak self] (projects: [String]) in
                guard let `self` = self else { return }
                self.projectsPopUpButton.removeAllItems()
                self.projectsPopUpButton.addItems(withTitles: projects)
            })
            .disposed(by: dispose)

        viewModel.projects
            .flatMap { _ in viewModel.selectedProject.asDriver() }
            .drive(onNext: { [weak self] (position: Int) in
                guard let `self` = self else { return }
                self.projectsPopUpButton.selectItem(at: position)
            })
            .disposed(by: dispose)

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

    }

    public override func viewWillAppear() {
        super.viewWillAppear()
        viewModel.viewWillAppear()
    }
    
    @IBAction func projectSelected(_ sender: Any) {
        guard let item = projectsPopUpButton.selectedItem,
              let index = projectsPopUpButton.menu?.items.firstIndex(of: item)
            else { return }
        viewModel.selectedProject.accept(index)
    }
    
    @IBAction func taskSelected(_ sender: Any) {
    }
    
}

extension TimerViewController {

    func inject(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }

}
