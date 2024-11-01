//
//  ListGiftByGroupViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 01/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ListGiftByGroupViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
    }

    struct Output {
        let isLoadingGifts: BehaviorRelay<Bool>
        let gifts: BehaviorRelay<[GiftInfoItem]>
        let isLoadMore: BehaviorRelay<Bool>
        let isRefreshing: BehaviorRelay<Bool>
    }

    var input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()

    var output: Output
    let isLoadingGiftsSubj = BehaviorRelay(value: true)
    let giftsSubj = BehaviorRelay<[GiftInfoItem]>(value: [])
    let isLoadMoreSubj = BehaviorRelay(value: false)
    let isRefreshingSubj = BehaviorRelay(value: false)

    let groupName: String?
    let groupCode: String

    var page = 0
    var totalCount = 0
    var itemsPerPage = 10


    init(giftsRepository: GiftsRepository, groupName: String?, groupCode: String) {
        self.giftsRepository = giftsRepository
        self.groupName = groupName
        self.groupCode = groupCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(), refreshData: refreshDataSubj.asObserver())
        self.output = Output(
            isLoadingGifts: isLoadingGiftsSubj,
            gifts: giftsSubj,
            isLoadMore: isLoadMoreSubj,
            isRefreshing: isRefreshingSubj
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

        self.refreshDataSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isRefreshingSubj.accept(true)
            dispatchGroup.notify(queue: .main) {
                self.isRefreshingSubj.accept(false)
            }
            page = 0
            self.fetchData()
        }.disposed(by: disposeBag)

    }

    func fetchData() {
        getListGift()
    }

    func onLoadMore() {
        page += 1
        getListGift(loadingState: .loadMore)
    }

    func getListGift(loadingState: LoadingState = .loading) {
        switch loadingState {
        case .loading:
            self.isLoadingGiftsSubj.accept(true)
        case .loadMore:
            self.isLoadMoreSubj.accept(true)
        default: break
        }
        dispatchGroup.enter()
        giftsRepository.getListGiftByGroup(groupCode: groupCode, limit: 10, offset: 0)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            var gifts = output.gifts.value
            let newGifts = res.data?.items ?? []
            if (loadingState == .loadMore) {
                gifts.append(contentsOf: newGifts)
            } else {
                gifts = newGifts
            }
            giftsSubj.accept(gifts)
            isLoadingGiftsSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftsSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

}
