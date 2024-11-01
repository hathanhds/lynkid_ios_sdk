//
//  EgiftRewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import RxSwift
import RxCocoa


class EgiftRewardDetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let myRewardRepository: MyrewardRepository
    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let giftInfo: BehaviorRelay<GiftInfoItem?>
        let updateGiftStatusResult: Observable<Result<Void, APIErrorResponseModel>>
        let loadGiftDetailResult: Observable<Result<GiftInfoItem, Error>>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let giftInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)
    var updateGiftStatusResultSubj = PublishSubject<Result<Void, APIErrorResponseModel>>()
    let loadGiftDetailResultSubj = PublishSubject<Result<GiftInfoItem, Error>>()

    let giftTransactionCode: String

    init(myRewardRepository: MyrewardRepository, giftsRepository: GiftsRepository, giftTransactionCode: String, giftInfo: GiftInfoItem) {
        self.myRewardRepository = myRewardRepository
        self.giftTransactionCode = giftTransactionCode
        self.giftsRepository = giftsRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj,
            giftInfo: giftInfoSubj,
            updateGiftStatusResult: updateGiftStatusResultSubj.asObservable(),
            loadGiftDetailResult: loadGiftDetailResultSubj)

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            if (!giftTransactionCode.isEmpty) {
                self.getMyRewardDetail()
            }
            giftInfoSubj.accept(giftInfo)
        }.disposed(by: disposeBag)
    }

    func getMyRewardDetail(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
        myRewardRepository.getMyRewardDetail(giftTransactionCode: self.giftTransactionCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result?.items?.first {
                giftInfoSubj.accept(data)
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func updateEgiftStatus() {
        isLoadingSubj.accept(true)
        let giftInfo = output.giftInfo.value
        let transactionCode = giftInfo?.giftTransaction?.code ?? ""
        myRewardRepository.updateGiftStatus(transactionCode: transactionCode, topupChannel: getTopupChannel())
            .subscribe { [weak self] res in
            guard let self = self else { return }
            getMyRewardDetail()
            self.updateGiftStatusResultSubj.onNext(.success(()))
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
            if let error = error as? APIErrorResponseModel {
                self.updateGiftStatusResultSubj.onNext(.failure(error))
            } else {
                self.updateGiftStatusResultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }
        }.disposed(by: disposeBag)
    }

    func getGiftDetail(giftId: String) {
        isLoadingSubj.accept(true)
        giftsRepository.getGiftDetail(giftId: giftId)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.data {
                loadGiftDetailResultSubj.onNext(.success(data))
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }
}

extension EgiftRewardDetailViewModel {

    func displaydDateInfo(giftInfo: GiftInfoItem?) -> RewarddDateInfoModel {
        let egift = giftInfo?.eGift
        let giftTransaction = giftInfo?.giftTransaction
        let expiredDate = formatDate(date: egift?.expiredDate)
        let sentDate = formatDate(date: giftTransaction?.transferTime)
        let usedDate = formatDate(date: giftTransaction?.eGiftUsedAt)

        let whyHaveIt = giftTransaction?.whyHaveIt
        let usedStatus = egift?.usedStatus
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue && !sentDate.isEmpty) {
            return RewarddDateInfoModel(title: "Đã tặng vào \(sentDate)", color: .cF5574E!)
        } else if (usedStatus == EgiftRewardStatus.expired.rawValue && !expiredDate.isEmpty) {
            return RewarddDateInfoModel(title: "Hết hạn vào \(expiredDate)", color: .cF5574E!)
        } else if (usedStatus == EgiftRewardStatus.used.rawValue) {
            return RewarddDateInfoModel(title: !usedDate.isEmpty ? "Đã dùng vào \(usedDate)" : "Đã sử dụng", color: .cF5574E!)
        } else {
            return RewarddDateInfoModel(title: !expiredDate.isEmpty ? "HSD: \(expiredDate)" : "", color: .c6D6B7A!)
        }
    }

    func formatDate(date: String?, toFormatter: DateFormatterType = .HHmmddMMyyyy) -> String {
        if let date = date {
            let dateFormatter1 = Date.init(fromString: date, formatter: .yyyyMMddThhmmss)?.toString(formatter: toFormatter) ?? ""
            let dateFormatter2 = Date.init(fromString: date, formatter: .yyyyMMddThhmmssSSZ)?.toString(formatter: toFormatter) ?? ""
            if (!dateFormatter1.isEmpty) {
                return dateFormatter1
            } else {
                return dateFormatter2
            }
        }
        return ""
    }

    func isShowMarkUsedButton() -> Bool {
        let giftInfo = output.giftInfo.value
        let eGift = giftInfo?.eGift
        // Check hệ thống có tự động cập nhật trạng thái mua quà
        let isUsageCheck = giftInfo?.eGift?.usageCheck ?? false
        // Check điều kiện quà chưa sử dụng:
        // - Quà ở trạng thái redeem
        // - Quà chưa được tặng
        let whyHaveIt = giftInfo?.giftTransaction?.whyHaveIt
        let isNotUsed = eGift?.usedStatus == EgiftRewardStatus.redeemed.rawValue && whyHaveIt != WhyHaveRewardType.sent.rawValue
        return !isUsageCheck && isNotUsed
    }

    func caculateTicketPosition() -> CGFloat {
        let giftName = output.giftInfo.value?.giftTransaction?.giftName ?? ""
        let imageHeight = 64.0
        let titleHeight = UtilHelper.heightForLabel(text: giftName, font: .f18s!, width: UtilHelper.screenWidth - 64)
        let dateHeight = 16.0
        let space = CGFloat(24 + 8 + 8 + 18)
        return CGFloat(imageHeight + titleHeight + dateHeight + space)
    }
}

extension EgiftRewardDetailViewModel {
    func parseIntroduce(_ introduce: String) -> String {
        // Custom hướng dẫn sử dụng với quà thẻ nạp
        if (introduce.contains("PrePaid") && introduce.contains("PostPaid")) {
            if let data = getToupPhoneSyntax(), let prePaid = data.prePaid, let postPaid = data.postPaid {
                return "Nạp tiền bằng cách bấm trên bàn phím điện thoại: \n- Trả trước: \(prePaid)\n- Trả sau: \(postPaid)"
            }
        } else if (introduce.contains("Syntax") && introduce.contains("ToNumber")) {
            if let data = getToupDataSyntax(), let syntax = data.syntax, let toNumber = data.toNumber {
                return "Hướng dẫn sử dụng quà thẻ nạp data:\nSoạn \(syntax) gửi đến \(toNumber)";
            }
        }
        return introduce
    }

    func getToupPhoneSyntax() -> TopupPhoneSyntaxModel? {
        let introduce = output.giftInfo.value?.giftTransaction?.introduce ?? ""
        if (introduce.contains("PrePaid") && introduce.contains("PostPaid")) {
            if let jsonData = introduce.data(using: .utf8),
                let model = try? jsonData.decoded(type: TopupPhoneSyntaxModel.self) {
                return model
            }
        }
        return nil
    }

    func getToupDataSyntax() -> TopupDataSyntaxModel? {
        let introduce = output.giftInfo.value?.giftTransaction?.introduce ?? ""
        if (introduce.contains("Syntax") && introduce.contains("ToNumber")) {
            if let jsonData = introduce.data(using: .utf8),
                let model = try? jsonData.decoded(type: TopupDataSyntaxModel.self) {
                return model
            }
        }
        return nil
    }

    func getListCodeAndSeri() -> [TopupPopupModel] {
        let giftInfo = output.giftInfo.value
        var list = [TopupPopupModel]()
        if let code = giftInfo?.eGift?.code, !code.isEmpty {
            list.append(TopupPopupModel(title: "Sao chép mã thẻ", detail: code))
        }
        if let serialNo = giftInfo?.giftTransaction?.serialNo, !serialNo.isEmpty {
            list.append(TopupPopupModel(title: "Sao chép số seri", detail: serialNo))
        }
        return list
    }

    func getListTopupPhoneSyntax() -> [TopupPopupModel] {
        var list = [TopupPopupModel]()
        if let phoneSyntax = getToupPhoneSyntax() {
            if let prePaid = phoneSyntax.prePaid, !prePaid.isEmpty {
                list.append(TopupPopupModel(title: "Nạp trả trước", detail: prePaid))
            }
            if let postPaid = phoneSyntax.postPaid, !postPaid.isEmpty {
                list.append(TopupPopupModel(title: "Nạp trả sau", detail: postPaid))
            }
        }
        return list
    }

    func getTopupChannel() -> TopupChannel? {
        let giftInfo = output.giftInfo.value
        let isTopup = giftInfo?.vendorInfo?.type == "TopupPhone"
        let syntax = giftInfo?.giftTransaction?.introduce ?? ""
        let topupType = giftInfo?.topupType
        let brandName = giftInfo?.brandInfo?.brandName ?? ""
        let brandType = UtilHelper.getTopupBrandType(brandName: brandName)
        if (!isTopup || syntax.isEmpty) {
            return nil
        }
        if (syntax.contains("Syntax") && syntax.contains("ToNumber")
                || brandType == .vinaphone && topupType == .topupData
                || brandType == .mobifone && topupType == .topupData) {
            return .sms
        } else {
            return .ussd
        }
    }
}

struct RewarddDateInfoModel {
    let title: String
    let color: UIColor
    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
}
