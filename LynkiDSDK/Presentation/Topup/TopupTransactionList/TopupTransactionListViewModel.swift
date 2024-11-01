//
//  TopupTransactionListViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/08/2024.
//

import UIKit
import RxSwift
import RxCocoa

class TopupTransactionListViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let topupRepository: TopupRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
    }

    struct Output {
        let transactions: BehaviorRelay<[TopupTransactionItem]>
        let isLoading: BehaviorRelay<Bool>
        let isLoadMore: BehaviorRelay<Bool>
        let isRefreshing: BehaviorRelay<Bool>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: true)
    let transactionsSubj = BehaviorRelay<[TopupTransactionItem]>(value: [])
    let isLoadMoreSubj = BehaviorRelay(value: false)
    let isRefreshingSubj = BehaviorRelay(value: false)

    var page = 0
    var totalCount = 0
    var itemsPerPage = 10
    var topupType: TopupType

    init(topupRepository: TopupRepository, topupType: TopupType) {
        self.topupRepository = topupRepository
        self.topupType = topupType

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver())
        self.output = Output(
            transactions: transactionsSubj,
            isLoading: isLoadingSubj,
            isLoadMore: isLoadMoreSubj,
            isRefreshing: isRefreshingSubj
        )

        // MARK: -NotificationCenter
        NotificationCenter.observe(name: .updateTopupTransactionList) { _ in
            self.refresh()
        }

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

        self.refreshDataSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            refresh()
            dispatchGroup.notify(queue: .main) {
                self.isRefreshingSubj.accept(false)
            }

        }.disposed(by: disposeBag)

    }

    func fetchData(loadingState: LoadingState = .loading) {
        getListTransaction(loadingState: loadingState)
    }

    func onLoadMore() {
        page += 1
        getListTransaction(loadingState: .loadMore)
    }

    func refresh() {
        page = 0
        totalCount = 0
        getListTransaction(loadingState: .refresh)
    }

    func getListTransaction(loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            self.isLoadingSubj.accept(true)
        } else if (loadingState == .loadMore) {
            self.isLoadMoreSubj.accept(true)
        } else if (loadingState == .refresh) {
            self.isRefreshingSubj.accept(true)
        }
        dispatchGroup.enter()

        topupRepository.getTopupTransactionList(request: TopupTransactionListRequest(limit: itemsPerPage, offset: page * itemsPerPage, filterCode: self.topupType == .topupPhone ? Constant.topupPhoneCateCode : Constant.topupDataCateCode))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            var currentItems: [TopupTransactionItem] = []
            if (loadingState != .refresh) {
                currentItems = self.output.transactions.value.count > 0 ? self.output.transactions.value : []
            }
            let newItems = res.result?.items ?? []
            let items = currentItems + newItems
            totalCount = res.result?.totalCount ?? 0
            transactionsSubj.accept(items)
            isLoadingSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)

    }

}
