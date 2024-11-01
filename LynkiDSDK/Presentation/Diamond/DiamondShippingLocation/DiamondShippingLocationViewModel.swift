//
//  ShippingLocationViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class DiamondShippingLocationViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let displayLocations: BehaviorRelay<[LocationModel]>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let displayLocationsSubj = BehaviorRelay<[LocationModel]>(value: [])

    let data: ShippingLocationArguments
    init(data: ShippingLocationArguments) {
        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(displayLocations: displayLocationsSubj)

        self.data = data
        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            displayLocationsSubj.accept(data.locations)
        }.disposed(by: disposeBag)
    }

    func onSearch(searchText: String?) {
        if let searchText = searchText, !searchText.trim().isEmpty {
            let filterText = searchText.removeDiacritics().removingSpecialCharacters()
            let filterData = data.locations.filter { $0.name?.removeDiacritics().contains(filterText) ?? false }
            displayLocationsSubj.accept(filterData)
        } else {
            displayLocationsSubj.accept(data.locations)
        }
    }

}
