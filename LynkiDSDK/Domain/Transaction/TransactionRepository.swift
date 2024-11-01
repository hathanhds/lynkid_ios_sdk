//
//  TransactionRepository.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 03/06/2024.
//

import RxSwift

protocol TransactionRepository {
    func getListTransaction(request: TransactionHistoryRequestModel) -> Single<TransactionListResultModel>
    func getDetailTransaction(request: TransactionDetailRequestModel) -> Single<TransactionDetailResponseModel>

}
