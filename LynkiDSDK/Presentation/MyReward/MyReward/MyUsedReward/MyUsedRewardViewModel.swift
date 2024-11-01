//
//  MyUsedRewardViewModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 05/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class MyUsedRewardViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let myrewardRepository: MyrewardRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
    }

    struct Output {
        let listReward: BehaviorRelay<[GiftInfoItem]>
        let isLoadingListReward: BehaviorRelay<Bool>
        let isLoadMore: BehaviorRelay<Bool>
        let isRefreshing: BehaviorRelay<Bool>
        let filterModel: BehaviorRelay<MyrewardFilterModel?>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingListRewardSubj = BehaviorRelay(value: true)
    let listRewardSubj = BehaviorRelay<[GiftInfoItem]>(value: [])
    let isLoadMoreSubj = BehaviorRelay(value: false)
    let isRefreshingSubj = BehaviorRelay(value: false)
    let filterModelSubj = BehaviorRelay<MyrewardFilterModel?>(value: nil)

    var page = 0
    var totalCount = 0
    var itemsPerPage = 10

    init(myrewardRepository: MyrewardRepository) {
        self.myrewardRepository = myrewardRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver())
        self.output = Output(
            listReward: listRewardSubj,
            isLoadingListReward: isLoadingListRewardSubj,
            isLoadMore: isLoadMoreSubj,
            isRefreshing: isRefreshingSubj,
            filterModel: filterModelSubj
        )

        // MARK: -NotificationCenter
        NotificationCenter.observe(name: .updateMyRewardList) { _ in
            self.refreshListReward()
        }

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

        self.refreshDataSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            refreshListReward()
            dispatchGroup.notify(queue: .main) {
                self.isRefreshingSubj.accept(false)
            }
        }.disposed(by: disposeBag)

    }

    func fetchData(loadingState: LoadingState = .loading) {
        getListReward(loadingState: loadingState)
    }

    func onLoadMore() {
        page += 1
        getListReward(loadingState: .loadMore)
    }

    func getListReward(loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            self.isLoadingListRewardSubj.accept(true)
        } else if (loadingState == .loadMore) {
            self.isLoadMoreSubj.accept(true)
        } else if (loadingState == .refresh) {
            self.isRefreshingSubj.accept(true)
        }
        dispatchGroup.enter()

        myrewardRepository.getListReward(request: MyRewardRequestModel(limit: itemsPerPage, offset: page * itemsPerPage, eGiftStatusFilter: "U;E", filterModel: output.filterModel.value))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            var currentItems: [GiftInfoItem] = []
            if (loadingState != .refresh) {
                currentItems = self.output.listReward.value.count > 0 ? self.output.listReward.value : []
            }
            let newItems = res.result?.items ?? []
            let items = currentItems + newItems
            totalCount = res.result?.totalCount ?? 0
            listRewardSubj.accept(items)
            isLoadingListRewardSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingListRewardSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

    func onApplyFilterModelCallBack(filterModel: MyrewardFilterModel?) {
        filterModelSubj.accept(filterModel)
        refreshListReward()
    }

    func refreshListReward() {
        page = 0
        totalCount = 0
        getListReward(loadingState: .refresh)
    }
}
