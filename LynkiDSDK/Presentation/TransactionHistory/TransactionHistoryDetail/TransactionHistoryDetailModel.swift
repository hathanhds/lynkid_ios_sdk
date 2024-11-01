//
//  TransactionHistoryDetailModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 10/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class TransactionHistoryDetailModel: ViewModelType {
    let disposeBag = DisposeBag()

    let tokenTransID: String?
    let orderCode: String?

    private let transactionRepository: TransactionRepository
    private let myRewardRepository: MyrewardRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let transactionInfo: BehaviorRelay<TransactionDetailModel?>
        let relatedTransactionInfo: BehaviorRelay<TransactionDetailModel?>
        let isLoading: BehaviorRelay<Bool>
        let loadGiftDetailResult: Observable<Result<GiftInfoItem, Error>>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: true)
    let loadGiftDetailResultSubj = PublishSubject<Result<GiftInfoItem, Error>>()

    let transactionInfoSubj = BehaviorRelay<TransactionDetailModel?>(value: nil)
    let relatedTransactionInfoSubj = BehaviorRelay<TransactionDetailModel?>(value: nil)

    init(tokenTransID: String? = nil, orderCode: String? = nil, transactionRepository: TransactionRepository, myRewardRepository: MyrewardRepository) {
        self.transactionRepository = transactionRepository
        self.myRewardRepository = myRewardRepository
        self.tokenTransID = tokenTransID
        self.orderCode = orderCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(
            transactionInfo: transactionInfoSubj,
            relatedTransactionInfo: relatedTransactionInfoSubj,
            isLoading: isLoadingSubj,
            loadGiftDetailResult: loadGiftDetailResultSubj
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

    }

    func fetchData() {
        if let tokenTransID = tokenTransID {
            getTransactionDetail(tokenTransID: tokenTransID)
        } else if let orderCode = orderCode {
            getTransactionList(orderCode: orderCode.replacingOccurrences(of: "_1", with: ""))
        }
    }


    func getTransactionDetail(tokenTransID: String) { self.isLoadingSubj.accept(true)
        transactionRepository.getDetailTransaction(request: TransactionDetailRequestModel(tokenTransID: tokenTransID)).subscribe {
            [weak self] res in
            guard let self = self else { return }
            transactionInfoSubj.accept(res.result)
            if let relatedTokenTransId = res.result?.relatedTokenTransId, !relatedTokenTransId.isEmpty {
                getRelatedTransactionDetail(tokenTransID: relatedTokenTransId)
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getTransactionList(orderCode: String) {
        isLoadingSubj.accept(true)
        transactionRepository.getListTransaction(request: TransactionHistoryRequestModel(
            limit: 1,
            offset: 0,
            actionTypeFilter: ""))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let transaction = res.items?.first
            getTransactionDetail(tokenTransID: transaction?.tokenTransID ?? "")
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getRelatedTransactionDetail(tokenTransID: String, loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            self.isLoadingSubj.accept(true)
        }
        transactionRepository.getDetailTransaction(request: TransactionDetailRequestModel(tokenTransID: tokenTransID)).subscribe {
            [weak self] res in
            guard let self = self else { return }
            relatedTransactionInfoSubj.accept(res.result)
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getSign() -> String {
        let data = output.transactionInfo.value
        return data?.walletAddress != nil
            && data?.toWalletAddress != nil
            && data?.walletAddress == data?.toWalletAddress
            ? "+" : "-"
    }

    func getGiftDetail(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
        myRewardRepository.getMyRewardDetail(giftTransactionCode: output.transactionInfo.value?.orderCode ?? "")
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result?.items?.first {
                loadGiftDetailResultSubj.onNext(.success(data))
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            loadGiftDetailResultSubj.onNext(.failure(error))
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

}
