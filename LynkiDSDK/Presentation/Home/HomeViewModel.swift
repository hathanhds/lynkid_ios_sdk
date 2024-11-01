//
//  HomeViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class HomeViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let dispatchGroup = DispatchGroup()

    private let newsRepository: NewsRepository
    private let giftsRepository: GiftsRepository
    private let userRepository: UserRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let refreshData: AnyObserver<Void>
        let onShowOrHideCoin: AnyObserver<Void>
    }

    struct Output {
        let isShowCoin: BehaviorRelay<Bool>

        let isLoadingUserInfo: BehaviorRelay<Bool?>
        let userInfo: BehaviorRelay<MemberView?>
        let userPoint: BehaviorRelay<UserPoint?>

        let isLoadingGiftCates: BehaviorRelay<Bool?>
        let giftCates: BehaviorRelay<[GiftCategory]>

        let isLoadingNewsAndBanner: BehaviorRelay<Bool?>
        let news: BehaviorRelay<[NewsItem]>
        let banners: BehaviorRelay<[NewsItem]>
        let currentBannerPageControlIndex: BehaviorRelay<Int>

        let isLoadingGiftGroup: BehaviorRelay<Bool?>
        let giftGroupInfo: BehaviorRelay<GiftGroupItem?>

        let isRefreshing: BehaviorRelay<Bool>

    }

    var input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let refreshDataSubj = PublishSubject<Void>()
    let onShowOrHideCoinSubj = PublishSubject<Void>()


    var output: Output
    let isShowCoinSubj = BehaviorRelay(value: false)

    let isLoadingUserInfoSubj = BehaviorRelay<Bool?>(value: nil)
    let userInfoSubj = BehaviorRelay<MemberView?>(value: nil)
    let userPointSubj = BehaviorRelay<UserPoint?>(value: nil)

    let isLoadingGiftCatesSubj = BehaviorRelay<Bool?>(value: nil)
    let giftCatesSubj = BehaviorRelay<[GiftCategory]>(value: [])

    let isLoadingNewsAndBannerSubj = BehaviorRelay<Bool?>(value: nil)
    let newsSubj = BehaviorRelay<[NewsItem]>(value: [])
    let bannersSubj = BehaviorRelay<[NewsItem]>(value: [])
    let currentBannerPageControlIndexSubj = BehaviorRelay(value: 0)

    let isLoadingGiftGroupSubj = BehaviorRelay<Bool?>(value: nil)
    let giftGroupInfoSubj = BehaviorRelay<GiftGroupItem?>(value: nil)

    let isRefreshingSubj = BehaviorRelay(value: false)

    init(newsRepository: NewsRepository, giftsRepository: GiftsRepository, userRepository: UserRepository) {

        self.newsRepository = newsRepository
        self.giftsRepository = giftsRepository
        self.userRepository = userRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            refreshData: refreshDataSubj.asObserver(),
            onShowOrHideCoin: onShowOrHideCoinSubj.asObserver())

        self.output = Output(isShowCoin: isShowCoinSubj,
            isLoadingUserInfo: isLoadingUserInfoSubj,
            userInfo: userInfoSubj,
            userPoint: userPointSubj,
            isLoadingGiftCates: isLoadingGiftCatesSubj,
            giftCates: giftCatesSubj,
            isLoadingNewsAndBanner: isLoadingNewsAndBannerSubj,
            news: newsSubj,
            banners: bannersSubj,
            currentBannerPageControlIndex: currentBannerPageControlIndexSubj, isLoadingGiftGroup: isLoadingGiftGroupSubj, giftGroupInfo: giftGroupInfoSubj,
            isRefreshing: isRefreshingSubj)

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
            self.fetchData()
        }.disposed(by: disposeBag)

        self.onShowOrHideCoinSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isShowCoinSubj.accept(!self.isShowCoinSubj.value)
        }.disposed(by: disposeBag)

        // MARK: -NotificationCenter
        NotificationCenter.observe(name: .updateUerCoin) { _ in
            self.getUserPoint()
        }

    }

    func fetchData() {
        if (AppConfig.shared.viewMode == .authenticated) {
            getMemberView()
            getUserPoint()
        }
        getListNewsAndBanner()
        getListGiftGroup()
        getListCate()
    }

    func getMemberView() {
        isLoadingUserInfoSubj.accept(true)
        dispatchGroup.enter()
        userRepository.getMemberView()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let userInfo = res.data
            AppUserDefaults.userId = userInfo?.id ?? 0
            userInfoSubj.accept(userInfo)
            isLoadingUserInfoSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingUserInfoSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

    func getUserPoint() {
        userRepository.getUserPoint()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let items = res.data?.items
            userPointSubj.accept(items)
        }.disposed(by: disposeBag)
    }

    func getListNewsAndBanner() {
        isLoadingNewsAndBannerSubj.accept(true)
        dispatchGroup.enter()
        newsRepository.getListNewsAndBanner()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let result = res.data
            let news = result?.filter { $0.type == 0 }.first?.resultDto?.items ?? []
            newsSubj.accept(news)

            let banners = result?.filter { $0.type == 1 }.first?.resultDto?.items ?? []
            bannersSubj.accept(banners)
            isLoadingNewsAndBannerSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingNewsAndBannerSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

    func getListGiftGroup() {
        isLoadingGiftGroupSubj.accept(true)
        dispatchGroup.enter()
        giftsRepository.getListGiftGroupForHomepage(maxItem: 6)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            giftGroupInfoSubj.accept(res.data)
            isLoadingGiftGroupSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftGroupSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }

    func getListCate() {
        isLoadingGiftCatesSubj.accept(true)
        dispatchGroup.enter()
        giftsRepository.getListGiftCate()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let cates = res.data?.row2 ?? []
            giftCatesSubj.accept(cates)
            AppUserDefaults.categories = cates
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }
}
