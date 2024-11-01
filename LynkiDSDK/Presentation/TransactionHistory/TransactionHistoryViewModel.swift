//
//  TransactionHistoryViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class TransactionHistoryViewModel{
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()
    
    private let merchantRepository: MerchantRepository
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
    
    }
    
    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
   
    
    init(merchantRepository: MerchantRepository) {
        self.merchantRepository = merchantRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output()

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData()
        }.disposed(by: disposeBag)

    }
    
    func fetchData() {
        dispatchGroup.enter()
        merchantRepository.getListMerchant(request: MerchantRequestModel()).subscribe{ _ in
          
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }
}
