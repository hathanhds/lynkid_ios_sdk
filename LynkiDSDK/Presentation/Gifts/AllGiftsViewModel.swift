//
//  AllGiftsViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class AllGiftsViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
    }

    struct Output {
        let isLoadingGiftCates: BehaviorRelay<Bool>
        let giftCates: BehaviorRelay<[GiftCategory]>
        let selectedCate: BehaviorRelay<GiftCategory?>

        let isLoadingGiftGroup: BehaviorRelay<Bool>
        let giftsByGroup: BehaviorRelay<[GiftGroupItem]>

        let isRefreshing: BehaviorRelay<Bool>

    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingGiftCatesSubj = BehaviorRelay(value: true)
    let giftCatesSubj = BehaviorRelay<[GiftCategory]>(value: [])
    let selectedCateSubj = BehaviorRelay<GiftCategory?>(value: nil)

    let isLoadingGiftGroupSubj = BehaviorRelay(value: true)
    let giftsByGroupSubj = BehaviorRelay<[GiftGroupItem]>(value: [])

    let isRefreshingSubj = BehaviorRelay(value: false)


    init(giftsRepository: GiftsRepository) {
        self.giftsRepository = giftsRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver())
        self.output = Output(
            isLoadingGiftCates: isLoadingGiftCatesSubj,
            giftCates: giftCatesSubj,
            selectedCate: selectedCateSubj,
            isLoadingGiftGroup: isLoadingGiftGroupSubj,
            giftsByGroup: giftsByGroupSubj, isRefreshing: isRefreshingSubj
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
            fetchData(loadingState: .refresh)
        }.disposed(by: disposeBag)

    }

    func fetchData(loadingState: LoadingState = .loading) {
        getListCate(loadingState: loadingState)
        getAllGiftGroups(loadingState: loadingState)
    }


    func getListCate(loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            isLoadingGiftCatesSubj.accept(true)
        }
        dispatchGroup.enter()
        giftsRepository.getListGiftCate()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            var cates = res.data?.row2 ?? []
            // Insert cate Tất cả
            if (!cates.isEmpty) {
                cates.insert(GiftCategory().cateAll, at: 0)
            }
            giftCatesSubj.accept(cates)
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)

    }

    func getAllGiftGroups(loadingState: LoadingState = .loading) {
        if (loadingState == .loading) {
            isLoadingGiftCatesSubj.accept(true)
        }
        dispatchGroup.enter()
        giftsRepository.getAllGiftGroups()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            giftsByGroupSubj.accept(res.data?.items ?? [])
            isLoadingGiftGroupSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftGroupSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)

    }
}
