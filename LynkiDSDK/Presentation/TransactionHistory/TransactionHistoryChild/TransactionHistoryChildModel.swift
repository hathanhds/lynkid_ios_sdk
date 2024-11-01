//
//  TransactionHistoryChildModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 31/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

enum SelectedTab {
    case all
    case earn
    case exchange
    case used
}

class TransactionHistoryChildModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let transactionRepository: TransactionRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
    }

    struct Output {
        let listTransaction: BehaviorRelay<[TransactionItem]>
        let listGroupTransaction: BehaviorRelay<[TransactionGroupModel]>
        let isLoading: BehaviorRelay<Bool>
        let isLoadMore: BehaviorRelay<Bool>
        let isRefreshing: BehaviorRelay<Bool>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: true)

    let listTransactionSubj = BehaviorRelay<[TransactionItem]>(value: [])
    let listGroupTransactionSubj = BehaviorRelay<[TransactionGroupModel]>(value: [])

    let isLoadMoreSubj = BehaviorRelay(value: false)
    let isRefreshingSubj = BehaviorRelay(value: false)

    var currentTab: SelectedTab = .all
    var page = 0
    var totalCount = 0
    var itemsPerPage = 10



    init(selectedTab: SelectedTab, transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
        self.currentTab = selectedTab


        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver())
        self.output = Output(
            listTransaction: listTransactionSubj,
            listGroupTransaction: listGroupTransactionSubj,
            isLoading: isLoadingSubj,
            isLoadMore: isLoadMoreSubj,
            isRefreshing: isRefreshingSubj
        )


        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

        self.refreshDataSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            dispatchGroup.notify(queue: .main) {
                self.isRefreshingSubj.accept(false)
            }
            refreshListTransacition()
        }.disposed(by: disposeBag)

        NotificationCenter.observe(name: .updateTransactionHistory) { _ in
            self.refreshListTransacition()
        }
    }

    func refreshListTransacition() {
        page = 0
        totalCount = 0
        getListTransaction(loadingState: .refresh)
    }

    func fetchData(loadingState: LoadingState = .loading) {
        getListTransaction(loadingState: loadingState)
    }

    func onLoadMore() {
        page += 1
        getListTransaction(loadingState: .loadMore)
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

        var actionTypeFilter = ""

        switch currentTab {
        case .all:
            actionTypeFilter = ""
        case .earn:
            actionTypeFilter = "Action;BatchManualGrant;Order;SingleManualGrant;Topup"
        case .exchange:
            actionTypeFilter = "Exchange;ExchangeAndUse;RevertExchange"
        case .used:
            actionTypeFilter = "PayByToken;Redeem;CashedOut;CashOutFee"
        }

        transactionRepository.getListTransaction(request: TransactionHistoryRequestModel(limit: itemsPerPage, offset: page * itemsPerPage, actionTypeFilter: actionTypeFilter))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            var currentItems: [TransactionItem] = []
            if (loadingState != .refresh) {
                currentItems = self.output.listTransaction.value.count > 0 ? self.output.listTransaction.value : []
            }
            let newItems = res.items ?? []
            let items = currentItems + newItems

            let dict = Dictionary(grouping: items, by: { Date.init(fromString: $0.time ?? "", formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy) ?? "" })
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatterType.ddMMyyyy.value
            let sortDict = dict.sorted(by: { dateFormatter.date(from: $0.key)?.compare(dateFormatter.date(from: $1.key)!) == .orderedDescending })
            var nowString = ""
            if #available(iOS 15, *) {
                nowString = Date.now.toString(formatter: .ddMMyyyy)
            } else {
                nowString = Date().toString(formatter: .ddMMyyyy)
            }
            let listGroup = sortDict.map { TransactionGroupModel(dateString: nowString == $0.key ? "\($0.key) - Hôm nay": $0.key, transactions: $0.value) }
            listGroupTransactionSubj.accept(listGroup)
            totalCount = res.totalCount ?? 0
            listTransactionSubj.accept(items)
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

struct TransactionGroupModel {
    var dateString: String
    var transactions: [TransactionItem]

    init(dateString: String, transactions: [TransactionItem]) {
        self.dateString = dateString
        self.transactions = transactions
    }
}
