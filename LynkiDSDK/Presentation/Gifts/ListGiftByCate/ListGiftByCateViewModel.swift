//
//  ListGiftByCateViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ListGiftByCateViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let giftsRepository: GiftsRepository
    private let userRepository: UserRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
        let onSelectedCate: AnyObserver<GiftCategory>
    }

    struct Output {
        let isLoadingGiftCates: BehaviorRelay<Bool>
        let giftCates: BehaviorRelay<[GiftCategory]>

        let isLoadingGifts: BehaviorRelay<Bool>
        let gifts: BehaviorRelay<[GiftInfoItem]>
        let selectedCate: BehaviorRelay<GiftCategory?>

        let isLoadingGiftGroup: BehaviorRelay<Bool>
        let giftGroup: BehaviorRelay<GiftGroupItem?>

        let isRefreshing: BehaviorRelay<Bool>
        let isLoadMore: BehaviorRelay<Bool>

        let sorting: BehaviorRelay<GiftSorting>
        let filterModel: BehaviorRelay<GiftFilterModel?>
        let userPoint: BehaviorRelay<UserPoint?>
    }

    var input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()
    let onSelectedCateSubj = PublishSubject<GiftCategory>()

    var output: Output
    let isLoadingGiftCatesSubj = BehaviorRelay(value: true)
    let giftCatesSubj = BehaviorRelay<[GiftCategory]>(value: [])
    let isLoadingGiftsSubj = BehaviorRelay(value: true)
    let giftsSubj = BehaviorRelay<[GiftInfoItem]>(value: [])
    let selectedCateSubj = BehaviorRelay<GiftCategory?>(value: nil)

    let isLoadingGiftGroupSubj = BehaviorRelay(value: true)
    let giftGroupSubj = BehaviorRelay<GiftGroupItem?>(value: GiftGroupItem())

    let isRefreshingSubj = BehaviorRelay(value: false)
    let isLoadMoreSubj = BehaviorRelay(value: false)

    let sortingSubj = BehaviorRelay<GiftSorting>(value: .displayOrder)
    let filterModelSubj = BehaviorRelay<GiftFilterModel?>(value: nil)
    let userPointSubj = BehaviorRelay<UserPoint?>(value: nil)


    var page = 0
    var totalCount = 0
    var itemsPerPage = 10

    init(giftsRepository: GiftsRepository, userRepository: UserRepository, cate: GiftCategory) {
        self.giftsRepository = giftsRepository
        self.userRepository = userRepository

        self.input = Input(
            viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver(),
            onSelectedCate: onSelectedCateSubj.asObserver()
        )
        self.output = Output(
            isLoadingGiftCates: isLoadingGiftCatesSubj,
            giftCates: giftCatesSubj,
            isLoadingGifts: isLoadingGiftsSubj,
            gifts: giftsSubj,
            selectedCate: selectedCateSubj,
            isLoadingGiftGroup: isLoadingGiftGroupSubj,
            giftGroup: giftGroupSubj,
            isRefreshing: isRefreshingSubj,
            isLoadMore: isLoadMoreSubj,
            sorting: sortingSubj,
            filterModel: filterModelSubj,
            userPoint: userPointSubj
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

        self.onSelectedCateSubj.subscribe(onNext: { [weak self] category in
            guard let self = self else { return }
            selectedCateSubj.accept(category)
            // mỗi lần chọn cate sorting theo quà mới nhất
            sortingSubj.accept(.displayOrder)
            giftsSubj.accept([])
            page = 0
            getListGiftByCate(loadingState: .loading)
        })
            .disposed(by: disposeBag)

        selectedCateSubj.accept(cate)
    }

    func fetchData() {
        getListCate()
        getHighlightGifts()
        getUserPoint()
        getListGiftByCate(loadingState: .refresh)
    }

    func onLoadMore() {
        page += 1
        getListGiftByCate(loadingState: .loadMore)
    }

    func onApplyFilterModelCallBack(filterModel: GiftFilterModel?) {
        filterModelSubj.accept(filterModel)
        refreshListGift()
    }

    func onSorting() {
        let sorting = output.sorting.value
        if (sorting == GiftSorting.requiredCoinDesc) {
            sortingSubj.accept(GiftSorting.requiredCoinAsc)
        } else {
            sortingSubj.accept(GiftSorting.requiredCoinDesc)
        }
        refreshListGift()
    }

    func refreshListGift() {
        page = 0
        totalCount = 0
        giftsSubj.accept([])
        getListGiftByCate()
    }

    func getListGiftByCate(loadingState: LoadingState = .loading) {
        switch loadingState {
        case .loading:
            self.isLoadingGiftsSubj.accept(true)
        case .loadMore:
            self.isLoadMoreSubj.accept(true)
        default: break
        }
        dispatchGroup.enter()
        giftsRepository.getALlGifts(request: AllGiftsRequestModel(
            category: output.selectedCate.value,
            limit: itemsPerPage,
            offset: page * itemsPerPage,
            filterModel: output.filterModel.value,
            sorting: output.sorting.value,
            tokenBalance: output.userPoint.value?.tokenBalance ?? 0
            )
        )
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
            totalCount = res.data?.totalCount ?? 0
            isLoadingGiftsSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftsSubj.accept(false)
            isLoadMoreSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

    func getListCate() {
        isLoadingGiftCatesSubj.accept(true)
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

    func getHighlightGifts() {
        isLoadingGiftGroupSubj.accept(true)
        dispatchGroup.enter()
        giftsRepository.getListGiftGroupForHomepage(maxItem: 6)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            giftGroupSubj.accept(res.data)
            isLoadingGiftGroupSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftGroupSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

    func getUserPoint() {
        userRepository.getUserPoint()
            .subscribe { [weak self] res in
            guard let self = self else { return }
                userPointSubj.accept(res.data?.items)
        }.disposed(by: disposeBag)
    }

    func checkIsFilter() -> Bool {
        let filterModel = output.filterModel.value
        return filterModel != nil
    }
}
