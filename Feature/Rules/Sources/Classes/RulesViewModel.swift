//
// Created by Александр Цикин on 2018-11-20.
//

import Foundation

import RxSwift
import RxCocoa

import RichHarvest_Core_Core
import RichHarvest_Core_UI
import RichHarvest_Domain_Rules_Api

class RulesViewModel {

    let items: Driver<[RuleItemViewModel]>

    private let interactor: RulesInteractor
    private let schedulers: Schedulers
    private let itemFactory: RuleItemViewModel.Factory

    private let itemsRelay = BehaviorRelay<[RuleItemViewModel]>(value: [])

    private let dispose = DisposeBag()

    init(interactor: RulesInteractor, schedulers: Schedulers, itemFactory: RuleItemViewModel.Factory) {

        self.interactor = interactor
        self.schedulers = schedulers
        self.itemFactory = itemFactory

        self.items = self.itemsRelay.asDriver()//.skip(1)

        self.initSources()

    }

    deinit {
        Log.debug("Deinited")
    }

    private func initSources() {

        interactor.rules()
            .observeOn(schedulers.ui)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.handle(rules: $0)
            })
            .disposed(by: dispose)

    }

    private func handle(rules: [UrlCheckRule]) {

        Log.debug("Handle rules: \(rules)")

        let viewModels = rules.map(itemFactory.create(by:))
        itemsRelay.accept(viewModels)

    }

}

class RuleItemViewModel {

    let name: Driver<String>
    let value: Driver<String>
    let client: Driver<String>
    let project: Driver<String>
    let task: Driver<String>

    init(rule: UrlCheckRule, interactor: RulesInteractor, schedulers: Schedulers) {

        name = Driver.just(rule.name)

        switch rule.rule {
        case let .regex(expr): value = Driver.just(expr)
        }

        let retryAfterTimeout: (Observable<Error>) -> Observable<()> = { errs in
            errs.switchToWait(1, scheduler: schedulers.background)
        }

        let unset = Driver.just("Unset")

        if rule.result.clientId != UrlCheckRule.UNSPECIFIED {
            client = interactor.client(byId: rule.result.clientId)
                .retryWhen(retryAfterTimeout)
                .map { $0.name }
                .asDriver(onErrorJustReturn: "<unknown>")
        } else {
            client = unset
        }

        if rule.result.projectId != UrlCheckRule.UNSPECIFIED {
            project = interactor.project(byId: rule.result.projectId)
                .retryWhen(retryAfterTimeout)
                .map { $0.name }
                .asDriver(onErrorJustReturn: "<unknown>")
        } else {
            project = unset
        }

        if rule.result.taskId != UrlCheckRule.UNSPECIFIED {
            task = interactor.task(byId: rule.result.taskId)
                .retryWhen(retryAfterTimeout)
                .map { $0.name }
                .asDriver(onErrorJustReturn: "<unknown>")
        } else {
            task = unset
        }

    }

    class Factory {

        private let interactor: RulesInteractor
        private let schedulers: Schedulers

        init(interactor: RulesInteractor, schedulers: Schedulers) {
            self.interactor = interactor
            self.schedulers = schedulers
        }

        func create(by rule: UrlCheckRule) -> RuleItemViewModel {
            return RuleItemViewModel(rule: rule, interactor: interactor, schedulers: schedulers)
        }

    }

}