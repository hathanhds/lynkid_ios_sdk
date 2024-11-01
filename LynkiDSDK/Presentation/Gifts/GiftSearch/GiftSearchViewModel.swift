//
//  GiftSearchViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 29/05/2024.
//

import Foundation
import RxSwift
import RxCocoa


class GiftSearchViewModel {
    let disposeBag = DisposeBag()

    private let giftsRepository: GiftsRepository
    private let userRepository: UserRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let onSearch: AnyObserver<Void>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let isLoadMore: BehaviorRelay<Bool>
        let searchState: BehaviorRelay<SearchState>
        let sorting: BehaviorRelay<GiftSorting>
        let searchText: BehaviorRelay<String?>
        let filterModel: BehaviorRelay<GiftFilterModel?>
        let gifts: BehaviorRelay<[GiftInfoItem]>
        let userPoint: BehaviorRelay<UserPoint?>

        let isLoadingRecommendGifts: BehaviorRelay<Bool>
        let recommendGiftsgifts: BehaviorRelay<[GiftInfoItem]>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let onSearchSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let isLoadMoreSubj = BehaviorRelay<Bool>(value: false)
    let searchStateSubj = BehaviorRelay<SearchState>(value: .initial)
    let sortingSubj = BehaviorRelay<GiftSorting>(value: .requiredCoinAsc)
    let searchTextSubj = BehaviorRelay<String?>(value: nil)
    let filterModelSubj = BehaviorRelay<GiftFilterModel?>(value: nil)
    let giftsSubj = BehaviorRelay<[GiftInfoItem]>(value: [])
    let userPointSubj = BehaviorRelay<UserPoint?>(value: nil)

    let isLoadingRecommendGiftsSubj = BehaviorRelay<Bool>(value: false)
    let recommendGiftsgiftsSubj = BehaviorRelay<[GiftInfoItem]>(value: [])

    var page = 0
    var totalCount = 0
    var itemsPerPage = 10


    init(giftsRepository: GiftsRepository, userRepository: UserRepository) {
        self.giftsRepository = giftsRepository
        self.userRepository = userRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            onSearch: onSearchSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj,
            isLoadMore: isLoadMoreSubj,
            searchState: searchStateSubj,
            sorting: sortingSubj,
            searchText: searchTextSubj,
            filterModel: filterModelSubj,
            gifts: giftsSubj,
            userPoint: userPointSubj,
            isLoadingRecommendGifts: isLoadingRecommendGiftsSubj,
            recommendGiftsgifts: recommendGiftsgiftsSubj
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            getListRecommendedGift()
        }.disposed(by: disposeBag)

        self.onSearchSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            searchStateSubj.accept(.initial)
            refreshListGift()
        }.disposed(by: disposeBag)
    }

    func onApplyFilterModelCallBack(filterModel: GiftFilterModel?) {
        filterModelSubj.accept(filterModel)
        refreshListGift()
    }

    func onLoadMore() {
        page += 1
        getListGift(loadingState: .loadMore)
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
        getListGift()
    }

    func getListGift(loadingState: LoadingState = .loading) {
        switch loadingState {
        case .loading:
            self.isLoadingSubj.accept(true)
        case .loadMore:
            self.isLoadMoreSubj.accept(true)
        default: break
        }
        giftsRepository.getALlGifts(request: AllGiftsRequestModel(
            limit: itemsPerPage,
            offset: page * itemsPerPage,
            filterModel: output.filterModel.value,
            sorting: output.sorting.value,
            searchText: searchTextSubj.value
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
            if (gifts.isEmpty) {
                searchStateSubj.accept(.emptyResult)
            } else {
                searchStateSubj.accept(.searchResult)
            }
            giftsSubj.accept(gifts)
            totalCount = res.data?.totalCount ?? 0
            isLoadingSubj.accept(false)
            isLoadMoreSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if (giftsSubj.value.isEmpty) {
                searchStateSubj.accept(.emptyResult)
            } else {
                searchStateSubj.accept(.searchResult)
            }
            isLoadingSubj.accept(false)
            isLoadMoreSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getListRecommendedGift() {
        giftsRepository.getALlGifts(request: AllGiftsRequestModel(
            limit: itemsPerPage,
            offset: 0,
            sorting: GiftSorting.totalWish)
        )
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let gifts = res.data?.items ?? []
            recommendGiftsgiftsSubj.accept(gifts)
            isLoadingRecommendGiftsSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingRecommendGiftsSubj.accept(false)
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

    func getDisplayGifts() -> [GiftInfoItem] {
        switch output.searchState.value {
        case .searchResult:
            return output.gifts.value
        case .emptyResult:
            return output.recommendGiftsgifts.value
        default:
            return []
        }
    }
}

