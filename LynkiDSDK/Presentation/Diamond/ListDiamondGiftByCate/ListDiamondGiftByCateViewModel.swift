//
//  ListGiftByCateViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ListDiamondGiftByCateViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let giftsRepository: GiftsRepository
    private let userRepository: UserRepository
    private let parentCate: GiftCategory



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
        let giftGroup: BehaviorRelay<GiftInfor?>

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
    let giftGroupSubj = BehaviorRelay<GiftInfor?>(value: GiftInfor())

    let isRefreshingSubj = BehaviorRelay(value: false)
    let isLoadMoreSubj = BehaviorRelay(value: false)

    let sortingSubj = BehaviorRelay<GiftSorting>(value: .popular)
    let filterModelSubj = BehaviorRelay<GiftFilterModel?>(value: nil)
    let userPointSubj = BehaviorRelay<UserPoint?>(value: nil)

    var page = 0
    var totalCount = 0
    var itemsPerPage = 10

    init(giftsRepository: GiftsRepository, userRepository: UserRepository, cate: GiftCategory) {
        self.giftsRepository = giftsRepository
        self.userRepository = userRepository
        self.parentCate = cate

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
            sortingSubj.accept(.popular)
            giftsSubj.accept([])
            page = 0
            getListGiftByCate(loadingState: .loading)
        })
            .disposed(by: disposeBag)

        selectedCateSubj.accept(cate)
    }

    func fetchData() {
        getListCate()
    }

    func onLoadMore() {
        page += 1
        getListGiftByCate(loadingState: .loadMore)
    }

    func onApplyFilterModelCallBack(filterModel: GiftFilterModel?) {
        filterModelSubj.accept(filterModel)
        refreshListGift()
    }

    func onFiltering(selectedOption: GiftSorting = .popular) {
        output.sorting.accept(selectedOption)

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
        giftsRepository.getALlDiamondGifts(request: AllGiftsRequestModel(
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

            var newGifts: [GiftInfoItem] = []
            guard let items = res.data?.items else { return }
            for item in items {
                newGifts.append(item)
            }

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
        giftsRepository.getListGiftDiamondCate(request: ListCateDiamondRequestModel(maxLevelFilter: "2", parentCodeFilter: parentCate.code))
            .subscribe { [weak self] res in
            var cates: [GiftCategory] = [];
            guard let self = self else { return }
            if let result = res.result {
                cates = GiftDiamondCateResponseModel.from(model: result)
            }

            var allCateCode = ""
            if let parentCode = self.parentCate.code {
                allCateCode = cates.map { "\(String(describing: self.parentCate.code!)),\(String(describing: $0.code!))" }.joined(separator: ";")
                allCateCode = "\(parentCode);\(allCateCode)"
            }

            // Insert cate Tất cả
            if (!cates.isEmpty) {
                cates.insert(GiftCategory(code: allCateCode, name: "Tất cả", fullLink: "ic_cate_all", categoryTypeCode: "all"), at: 0)
            }

            for index in cates.indices {
                if(index != 0) {
                    if let currentCode = cates[index].code {
                        cates[index].code = "\(String(describing: self.parentCate.code!)),\(String(describing: currentCode))"
                    }
                }
            }

            giftCatesSubj.accept(cates)
            if(cates.count > 0) {
                selectedCateSubj.accept(cates[0])
                getListGiftByCate(loadingState: .loading)
            }
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)

    }



    func checkIsFilter() -> Bool {
        let filterModel = output.filterModel.value
        return filterModel != nil
    }
}
