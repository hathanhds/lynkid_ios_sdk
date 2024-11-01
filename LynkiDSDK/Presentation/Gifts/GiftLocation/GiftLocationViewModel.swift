//
//  GiftLocationViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

class GiftLocationViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
        let onSearch: AnyObserver<String>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let locations: BehaviorRelay<[GiftUsageLocationItem]>
        let isLoadMore: BehaviorRelay<Bool>
        let isRefreshing: BehaviorRelay<Bool>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()
    let onSearchSubj = PublishSubject<String>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let locationsSubj = BehaviorRelay<[GiftUsageLocationItem]>(value: [])
    let isLoadMoreSubj = BehaviorRelay(value: false)
    let isRefreshingSubj = BehaviorRelay(value: false)


    var page = 0
    var totalCount = 0
    var itemsPerPage = 10
    let giftCode: String

    init(giftsRepository: GiftsRepository, giftCode: String) {
        self.giftsRepository = giftsRepository
        self.giftCode = giftCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(), refreshData: refreshDataSubj.asObserver(), onSearch: onSearchSubj.asObserver())
        self.output = Output(
            isLoading: isLoadingSubj,
            locations: locationsSubj,
            isLoadMore: isLoadMoreSubj,
            isRefreshing: isRefreshingSubj
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.getListLocation()
        }.disposed(by: disposeBag)

        self.refreshDataSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isRefreshingSubj.accept(true)
            dispatchGroup.notify(queue: .main) {
                self.isRefreshingSubj.accept(false)
            }
            page = 0
            self.getListLocation()
        }.disposed(by: disposeBag)

        self.onSearchSubj.subscribe { [weak self] searchText in
            guard let self = self else { return }
            page = 0
            self.getListLocation(searchText: searchText)
        }.disposed(by: disposeBag)
    }

    func getListLocation(loadingState: LoadingState = .loading, searchText: String? = nil) {
        switch loadingState {
        case .loading:
            self.isLoadingSubj.accept(true)
        case .loadMore:
            self.isLoadMoreSubj.accept(true)
        default: break
        }
        dispatchGroup.enter()
        giftsRepository.getGiftUsageLocation(request: GiftUsageLocationRequest(name: searchText,
            giftCode: giftCode,
            offset: 0))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            var locations = output.locations.value
            let newLocations = res.result?.items ?? []
            if (loadingState == .loadMore) {
                locations.append(contentsOf: newLocations)
            } else {
                locations = newLocations
            }
            locationsSubj.accept(locations)
            isLoadingSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

}
