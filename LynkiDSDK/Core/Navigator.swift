//
//  Navigator.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//

import UIKit


class Navigator {

    enum Segue {
        case main
        case launchScreen
        case termsAndPolivy(type: TermsAndPolicyType)
        case accountExistAndConnected
        case accountNotExistAndConnected
        case accountExistAndNotConnected
        case accountNotExistAndNotConnected
        case authenConnectedPhoneNumber
        case popup (dismissable: Bool = true, isDiamond: Bool = false, type: PopupType, title: String, message: String, image: UIImage, confirmnButton: PopupViewModel.ConfirmButton? = nil, cancelButton: PopupViewModel.CancelButton? = nil)
        case allGifts
        case listGiftByCate(cate: GiftCategory)
        case listDiamondGiftByCate(cate: GiftCategory)
        case listGiftByGroup(groupName: String?, groupCode: String)
        case giftFilter(filterModel: GiftFilterModel?, applyFilterAction: GiftFilterViewModel.ApplyFilterActionType?, isShowCates: Bool = false)
        case diamondExchangeError
        case anonymous(title: String)
        case installAppPopup(isVpbankDiamond: Bool = false, isTabbar: Bool = false)
        case egiftRewardDetail(giftInfo: GiftInfoItem, giftTransactionCode: String)
        case physicalRewardDetail(giftInfo: GiftInfoItem, giftTransactionCode: String)
        case myrewardFilter(myRewardType: MyRewardType, filterModel: MyrewardFilterModel?, applyFilterAction: MyRewardFilterViewModel.ApplyFilterActionType?)
        case giftLocation(giftCode: String)
        case markUsed(didFinish: () -> Void)
        case giftDetail(giftInfo: GiftInfoItem? = nil, giftId: String)
        case giftDetailDiamond(giftInfo: GiftInfoItem?, giftId: String)
        case search
        case popupDiamondFilter(dismissable: Bool = true, selectedOption: GiftSorting = .popular, closeButtonAction: PopupDiamondFilterViewModel.CloseButton? = nil, applyButtonAction: PopupDiamondFilterViewModel.ApplyButton? = nil, selectMostPopularOptionAction: PopupDiamondFilterViewModel.SelectMostPopularButton? = nil, selectCheapestOptionAction: PopupDiamondFilterViewModel.SelectCheapestButton? = nil)
        case transactionDetail(tokenTransID: String? = nil, orderCode: String? = nil)
        case giftExchangeConfirm(data: GiftConfirmExchangeArguments)
        case giftExchangeSuccess(giftInfo: GiftInfoItem, transactionInfo: CreateTransactionItem, quantity: Int)
        case physicalShipping(giftInfo: GiftInfoItem, giftExchangePrice: Double, receiverInfoModel: ReceiverInfoModel? = nil)
        case shippingLocation(data: ShippingLocationArguments)
        case otp(data: OTPArguments)
        case flashSalePopup
        case diamondExchangeConfirm(data: GiftConfirmExchangeArguments)
        case diamondExchangeSuccess(giftInfo: GiftInfoItem, transactionInfo: CreateTransactionItem, quantity: Int)
        case diamondPhysicalShipping(giftInfo: GiftInfoItem, giftExchangePrice: Double, receiverInfoModel: ReceiverInfoModel? = nil)
        case diamondShippingLocation(data: ShippingLocationArguments)
        case diamondOtp(data: OTPArguments)
        case diamondLocation(giftCode: String)
        case popupLogin(isDiamond: Bool = false)
        case topup(topupType: TopupType = .topupPhone)
        case topupBrandList(selectedBrandAction: TopupBrandListViewModel.SelectedBrandAction, currentBrand: TopupBrandItem?, brandList: [TopupBrandModel])
        case topupConfirm(data: TopupConfirmArgument)
        case topupSuccess(data: TopupSuccessArgument)
        case topupTransaction
        case topupPopup(data: TopupPopupArgument)

    }

    public func show(segue: Segue, withAction action: (_ vc: UIViewController) -> Void) {
        var vc: UIViewController!
        switch segue {
            // MARK: - Main
        case .main:
            let vm = MainTabBarViewModel()
            vc = MainTabBarController.create(with: self, viewModel: vm)
        case .launchScreen:
            let vm = LaunchScreenViewModel(authenRepository: AuthRepositoryImp())
            vc = LaunchScreenViewController.create(with: self, viewModel: vm)
        case .termsAndPolivy(let type):
            let vm = TermsAndPolicyViewModel(type: type, authRepository: AuthRepositoryImp())
            vc = TermsAndPolicyViewController.create(with: self, viewModel: vm)
        case .accountExistAndConnected:
            let vm = AccountExistAndConnectedViewModel()
            vc = AccountExistAndConnectedViewController.create(with: self, viewModel: vm)
        case .accountNotExistAndConnected:
            let vm = AccountNotExistAndConnectedViewModel(authenRepository: AuthRepositoryImp())
            vc = AccountNotExistAndConnectedViewController.create(with: self, viewModel: vm)
        case .accountExistAndNotConnected:
            let vm = AccountExistAndNotConnectedViewModel()
            vc = AccountExistAndNotConnectedViewController.create(with: self, viewModel: vm)
        case .accountNotExistAndNotConnected:
            let vm = AccountNotExistAndNotConnectedViewModel(authenRepository: AuthRepositoryImp())
            vc = AccountNotExistAndNotConnectedViewController.create(with: self, viewModel: vm)
        case .authenConnectedPhoneNumber:
            let vm = AuthenConnectedPhoneNumberViewModel(authRepository: AuthRepositoryImp())
            vc = AuthenConnectedPhoneNumberViewController.create(with: self, viewModel: vm)
        case .popup(let dismissable, let isDiamond, let type, let title, let message, let image, let confirmnButton, let cancelButton):
            let vm = PopupViewModel(dismissable: dismissable, isDiamond: isDiamond, type: type, title: title, message: message, image: image, confirmnButton: confirmnButton, cancelButton: cancelButton)
            vc = PopupViewController.create(with: self, viewModel: vm)
        case .allGifts:
            let vm = AllGiftsViewModel(giftsRepository: GiftsRepositoryImpl())
            vc = AllGiftsViewController.create(with: self, viewModel: vm)
        case .listDiamondGiftByCate(let cate):
            let vm = ListDiamondGiftByCateViewModel(giftsRepository: GiftsRepositoryImpl(), userRepository: UserRepositoryImpl(), cate: cate)
            vc = ListDiamondGiftByCateViewController.create(with: self, viewModel: vm)
        case .listGiftByCate(let cate):
            let vm = ListGiftByCateViewModel(giftsRepository: GiftsRepositoryImpl(), userRepository: UserRepositoryImpl(), cate: cate)
            vc = ListGiftByCateViewController.create(with: self, viewModel: vm)
        case .listGiftByGroup(let groupName, let groupCode):
            let vm = ListGiftByGroupViewModel(giftsRepository: GiftsRepositoryImpl(), groupName: groupName, groupCode: groupCode)
            vc = ListGiftByGroupViewController.create(with: self, viewModel: vm)
        case .giftFilter(let filterModel, let applyFilterAction, let isShowCates):
            let vm = GiftFilterViewModel(giftsRepository: GiftsRepositoryImpl(), filterModel: filterModel, applyFilterAction: applyFilterAction, isShowCates: isShowCates)
            vc = GiftFilterViewController.create(with: self, viewModel: vm)
        case .diamondExchangeError:
            let vm = DiamondExchangeErrorViewModel()
            vc = DiamondExchangeErrorViewController.create(with: self, viewModel: vm)
        case .anonymous(let title):
            let vm = AnonymousViewModel(title: title)
            vc = AnonymousViewController.create(with: self, viewModel: vm)
        case .installAppPopup(let isVpbankDiamond, let isTabbar):
            let vm = InstallAppPopupViewModel(isVpbankDiamond: isVpbankDiamond, isTabbar: isTabbar)
            vc = InstallAppPopupViewController.create(with: self, viewModel: vm)
        case .egiftRewardDetail(let giftInfo, let giftTransactionCode):
            let vm = EgiftRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), giftsRepository: GiftsRepositoryImpl(), giftTransactionCode: giftTransactionCode, giftInfo: giftInfo)
            vc = EgiftRewardDetailViewController.create(with: self, viewModel: vm)
        case .physicalRewardDetail(let giftInfo, let giftTransactionCode):
            let vm = PhysicalRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), userRepository: UserRepositoryImpl(), giftTransactionCode: giftTransactionCode, giftInfo: giftInfo)
            vc = PhysicalRewardDetailViewController.create(with: self, viewModel: vm)
        case .myrewardFilter(let myRewardType, let filterModel, let applyFilterAction):
            let vm = MyRewardFilterViewModel(filterModel: filterModel, applyFilterAction: applyFilterAction, myRewardType: myRewardType)
            vc = MyRewardFilterViewController.create(with: self, viewModel: vm)
        case .giftLocation(let giftCode):
            let vm = GiftLocationViewModel(giftsRepository: GiftsRepositoryImpl(), giftCode: giftCode)
            vc = GiftLocationViewController.create(with: self, viewModel: vm)
        case .markUsed(let didFinish):
            let vm = MarkUsedViewModel(didFinish: didFinish)
            vc = MarkUsedViewController.create(with: self, viewModel: vm)
        case .giftDetail(let giftInfo, let giftId):
            let vm = GiftDetailViewModel(giftsRepository: GiftsRepositoryImpl(), giftInfo: giftInfo, giftId: giftId)
            vc = GiftDetailViewController.create(with: self, viewModel: vm)
        case .search:
            let vm = GiftSearchViewModel(giftsRepository: GiftsRepositoryImpl(), userRepository: UserRepositoryImpl())
            vc = GiftSearchViewController.create(with: self, viewModel: vm)
            break
        case .transactionDetail(let tokenTransID, let orderCode):
            let vm = TransactionHistoryDetailModel(tokenTransID: tokenTransID, orderCode: orderCode, transactionRepository: ListTransactionRepositoryImp(), myRewardRepository: MyrewardRepositoryImpl())
            vc = TransactionHistoryDetailViewController.create(with: self, viewModel: vm)

        case .popupDiamondFilter(let dismissable, let selectedOption, let closeButtonAction, let applyButtonAction, let selectMostPopularOptionAction, let selectCheapestOptionAction):
            let vm = PopupDiamondFilterViewModel(dismissable: dismissable,
                selectedOption: selectedOption,
                closeButtonAction: closeButtonAction,
                applyButtonAction: applyButtonAction,
                selectMostPopularOptionAction: selectMostPopularOptionAction,
                selectCheapestOptionAction: selectCheapestOptionAction)
            vc = PopupDiamondFilterViewController.create(with: self, viewModel: vm)
        case .giftExchangeConfirm(let data):
            let vm = GiftConfirmExchangeViewModel(
                data: GiftConfirmExchangeArguments(giftsRepository: data.giftsRepository,
                    giftInfo: data.giftInfo,
                    giftExchangePrice: data.giftExchangePrice,
                    receiverInfo: data.receiverInfo
                ))
            vc = GiftConfirmExchangeViewController.create(with: self, viewModel: vm)
        case .giftExchangeSuccess(let giftInfo, let transactionInfo, let quantity):
            let vm = GiftExchangeSuccessViewModel(giftInfo: giftInfo, transactionInfo: transactionInfo, quantity: quantity)
            vc = GiftExchangeSuccessViewController.create(with: self, viewModel: vm)
        case .physicalShipping(let giftInfo, let giftExchangePrice, let receiverInfoModel):
            let vm = PhysicalShippingViewModel(userRepository: UserRepositoryImpl(),
                giftInfo: giftInfo,
                giftExchangePrice: giftExchangePrice,
                receiverInfoModel: receiverInfoModel)
            vc = PhysicalShippingViewController.create(with: self, viewModel: vm)
        case .shippingLocation(let data):
            let vm = ShippingLocationViewModel(data: data)
            vc = ShippingLocationViewController.create(with: self, viewModel: vm)
        case .otp(let data):
            let vm = OTPViewModel(data: data)
            vc = OTPViewController.create(with: self, viewModel: vm)
        case .giftDetailDiamond(let giftInfo, let giftId):
            let vm = GiftDetailDiamondViewModel(
                giftsRepository: GiftsRepositoryImpl(),
                userRepository: UserRepositoryImpl(),
                giftInfo: giftInfo,
                giftId: giftId)
            vc = GiftDetailDiamondViewController.create(with: self, viewModel: vm)
        case .flashSalePopup:
            let vm = FlashSalePopupViewModel()
            vc = FlashSalePopupViewController.create(with: self, viewModel: vm)
        case .diamondExchangeConfirm(let data):
            let vm = DiamondConfirmExchangeViewModel(
                data: GiftConfirmExchangeArguments(giftsRepository: data.giftsRepository,
                    giftInfo: data.giftInfo,
                    giftExchangePrice: data.giftExchangePrice,
                    receiverInfo: data.receiverInfo
                ))
            vc = DiamondConfirmExchangeViewController.create(with: self, viewModel: vm)
        case .diamondExchangeSuccess(let giftInfo, let transactionInfo, let quantity):
            let vm = DiamondExchangeSuccessViewModel(giftInfo: giftInfo, transactionInfo: transactionInfo, quantity: quantity)
            vc = DiamondExchangeSuccessViewController.create(with: self, viewModel: vm)
        case .diamondPhysicalShipping(let giftInfo, let giftExchangePrice, let receiverInfoModel):
            let vm = DiamondPhysicalShippingViewModel(userRepository: UserRepositoryImpl(),
                giftInfo: giftInfo,
                giftExchangePrice: giftExchangePrice,
                receiverInfoModel: receiverInfoModel)
            vc = DiamondPhysicalShippingViewController.create(with: self, viewModel: vm)
        case .diamondShippingLocation(let data):
            let vm = DiamondShippingLocationViewModel(data: data)
            vc = DiamondShippingLocationViewController.create(with: self, viewModel: vm)
        case .diamondOtp(let data):
            let vm = DiamondOTPViewModel(data: data)
            vc = DiamondOTPViewController.create(with: self, viewModel: vm)
        case .diamondLocation(let giftCode):
            let vm = DiamondLocationViewModel(giftsRepository: GiftsRepositoryImpl(), giftCode: giftCode)
            vc = DiamondLocationViewController.create(with: self, viewModel: vm)
        case .popupLogin(let isDiamond):
            let vm = PopupLoginViewModel(isDiamond: isDiamond)
            vc = PopupLoginViewController.create(with: self, viewModel: vm)
        case .topup(let topupType):
            let vm = TopupViewModel(topupType: topupType)
            vc = TopupViewController.create(with: self, viewModel: vm)
        case .topupBrandList(let selectedBrandAction, let currentBrand, let brandList):
            let vm = TopupBrandListViewModel(selectedBrandAction: selectedBrandAction, currentBrand: currentBrand, brandList: brandList)
            vc = TopupBrandListViewController.create(with: self, viewModel: vm)
        case .topupConfirm(let data):
            let vm = TopupConfirmViewModel(giftsRepository: GiftsRepositoryImpl(), data: data)
            vc = TopupConfirmViewController.create(with: self, viewModel: vm)
        case .topupSuccess(let data):
            let vm = TopupSuccessViewModel(data: data)
            vc = TopupSuccessViewController.create(with: self, viewModel: vm)
        case .topupTransaction:
            let vm = TopupTransactionViewModel()
            vc = TopupTransactionViewController.create(with: self, viewModel: vm)
        case .topupPopup(let data):
            let vm = TopupPopupViewModel(data: data)
            vc = TopupPopupViewController.create(with: self, viewModel: vm)
        default:
            break
        }
        vc.hidesBottomBarWhenPushed = true
        action(vc)

    }
}
