//
//  TransactionHistoryDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 10/06/2024.
//

import UIKit

class TransactionHistoryDetailViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: TransactionHistoryDetailModel) -> Self {
        let vc = UIStoryboard.transactionHistory.instantiateViewController(ofType: TransactionHistoryDetailViewController.self)
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc as! Self
    }

    var viewModel: TransactionHistoryDetailModel!
    var data: [[TransactionDetailCustomModel]] = []


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var lbHeaderTitle: UILabel!
    @IBOutlet weak var lbHeaderCoin: UILabel!
    @IBOutlet weak var successImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar()
    }

    override func initView() {
        self.addBackButton()
        self.title = "Chi tiết giao dịch"

        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = nil
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.sectionHeaderHeight = 0
        tableView.register(cellType: TransactionDetailTableViewCell.self)
        tableView.register(cellType: TransactionDetailHelpCenterTableViewCell.self)
        tableView.register(cellType: MyRewardTableViewCell.self)
        tableView.register(cellType: TransactionItemTableViewCell.self)
        tableView.isHidden = true
        successImageView.image = .imageExchangeGiftSuccess
    }

    override func bindToView() {
        // loading
        viewModel.output.isLoading.subscribe (onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            self.reloadTableView()
        })
            .disposed(by: disposeBag)

        // load giftDetail result
        viewModel.output.loadGiftDetailResult.subscribe (onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let giftInfo):
                if giftInfo.eGift != nil {
                    self.navigator.show(segue: .egiftRewardDetail(giftInfo: giftInfo, giftTransactionCode: "")) { [weak self] vc in
                        guard let self = self else { return }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    self.navigator.show(segue: .physicalRewardDetail(giftInfo: giftInfo, giftTransactionCode: "")) { [weak self] vc in
                        guard let self = self else { return }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                break
            case .failure: break
                // do nothing
            }
        })
            .disposed(by: disposeBag)
    }

    func reloadTableView() {
        if UserDefaults.standard.data(forKey: Constant.kAllMerchant) != nil {
            if let tokenTransDetail = viewModel.output.transactionInfo.value {
                //            let isTopup = tokenTransDetail?.actionType == "Topup"
                //            let isOrder = tokenTransDetail?.actionType == "Order"
                //            let isPrime = TransactionHistoryItemString.shared.isPrime(tokenTransDetail?.actionCodeDetail)
                //            let isDiamond = TransactionHistoryItemString.shared.isDiamond(tokenTransDetail?.actionCodeDetail)
                //            let isScripted = TransactionHistoryItemString.shared.isScriptedCampaign(tokenTransDetail?.actionCodeDetail)
                //            let isReferral = tokenTransDetail?.actionType == "Action" && (tokenTransDetail?.actionCode == "Referee" || tokenTransDetail?.actionCode == "Referrer")
                lbHeaderTitle.text = tokenTransDetail.title ?? "Số dư điểm LynkiD thay đổi"


                let sign = (tokenTransDetail.walletAddress != nil && tokenTransDetail.toWalletAddress != nil && tokenTransDetail.walletAddress == tokenTransDetail.toWalletAddress)
                    ? "+"
                : "-"

                let coinTextColor: UIColor = sign == "+"
                    ? UIColor.c34C759!
                : UIColor.cF5574E!
                let tokenAmount = tokenTransDetail.amount ?? 0
                if tokenAmount > 0 {
                    lbHeaderCoin.text = "\(sign) \(tokenTransDetail.amount!.formatter())"
                    lbHeaderCoin.textColor = coinTextColor
                } else {
                    lbHeaderCoin.text = "\(tokenAmount.formatter())"
                    lbHeaderCoin.textColor = .c242424
                }



                var commonInfoSectionArray: [TransactionDetailCustomModel] = []
                data = []
                commonInfoSectionArray.append(TransactionDetailCustomModel(
                    id: 1,
                    leftText: "Mã giao dịch",
                    rightText: (tokenTransDetail.orderCode != nil) ? tokenTransDetail.orderCode! : "",
                    type: .trasaction_info_normal))

                var leftText = ""
                if (tokenTransDetail.partnerPointAmount != nil && (tokenTransDetail.partnerPointAmount)! > 0) {
                    leftText = "Thời gian đổi"
                } else {
                    leftText = "Thời gian"
                }

                commonInfoSectionArray.append(TransactionDetailCustomModel(
                    id: 2,
                    leftText: leftText,
                    rightText: tokenTransDetail.creationTime != nil ? (tokenTransDetail.creationTime)! : "",
                    isDate: true,
                    type: .trasaction_info_normal))

                if let partnerName = tokenTransDetail.partnerName, !partnerName.isEmpty {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 3,
                        leftText: "Đối tác",
                        rightText: partnerName,
                        logo: tokenTransDetail.partnerIcon ?? "",
                        type: .trasaction_info_normal))
                }

                if (tokenTransDetail.partnerPointAmount != nil && (tokenTransDetail.partnerPointAmount)! > 0) {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 4,
                        leftText: "Số điểm đối tác",
                        rightText: String((tokenTransDetail.partnerPointAmount)!),
                        type: .trasaction_info_normal))
                }

                if let expiredTime = tokenTransDetail.expiredTime {
                    // Giao dịch đổi quà, thu hồi điểm không hiển thị ngày Sử dụng đến ngày
                    if(!expiredTime.isEmpty && sign == "+") {
                        commonInfoSectionArray.append(TransactionDetailCustomModel(
                            id: 5,
                            leftText: "Sử dụng đến ngày",
                            rightText: expiredTime,
                            isDate: true,
                            type: .trasaction_info_normal))
                    }
                }

                if let serviceName = tokenTransDetail.serviceName, !serviceName.isEmpty {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 6,
                        leftText: "Dịch vụ",
                        rightText: serviceName,
                        type: .trasaction_info_normal))
                }

                if let packageName = tokenTransDetail.packageName, !packageName.isEmpty {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 7,
                        leftText: "Gói sản phẩm",
                        rightText: packageName,
                        type: .trasaction_info_normal))
                }

                if let toPhoneNumber = tokenTransDetail.toPhoneNumber, !toPhoneNumber.isEmpty {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 8,
                        leftText: "Số điện thoại",
                        rightText: toPhoneNumber,
                        type: .trasaction_info_normal))
                }

                if let usageAddress = tokenTransDetail.usageAddress, !usageAddress.isEmpty {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 9,
                        leftText: "Địa điểm",
                        rightText: usageAddress,
                        type: .trasaction_info_normal))
                }


                if let _ = tokenTransDetail.giftName {
                    commonInfoSectionArray.append(TransactionDetailCustomModel(
                        id: 10,
                        type: .trasaction_info_gift_detail, data: tokenTransDetail))
                }

                data.append(commonInfoSectionArray)

                if let relatedTransactionInfo = viewModel.output.relatedTransactionInfo.value {
                    data.append([TransactionDetailCustomModel(
                        id: 11,
                        type: .trasaction_info_related_transaction,
                        data: relatedTransactionInfo)])
                    tableView.reloadData()
                }

                data.append([TransactionDetailCustomModel(
                    id: 12,
                    type: .trasaction_info_support)])
                tableView.isHidden = false
                tableView.reloadData()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.isHidden = false
                self.reloadTableView()
            }
        }
    }
}


extension TransactionHistoryDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sectionData = data[indexPath.section]
        let cellData: TransactionDetailCustomModel = sectionData[indexPath.row]

        switch cellData.type {
        case .trasaction_info_normal:
            let cell = tableView.dequeueCell(ofType: TransactionDetailTableViewCell.self, for: indexPath)
            cell.setLastCell(isLastCell: indexPath.row == sectionData.count - 1)
            cell.setDataForCell(item: cellData)
            cell.copyCodeAction = { [weak self] code in
                guard let self = self else { return }
                UIPasteboard.general.string = code
                self.showToast(ofType: .success, withMessage: "Sao chép mã giao dịch thành công")
            }
            return cell
        case .trasaction_info_gift_detail:
            let cell = tableView.dequeueCell(ofType: MyRewardTableViewCell.self, for: indexPath)
            cell.setLastCell(isLastCell: indexPath.row == sectionData.count - 1)
            cell.setDataForTransactionDetail(data: cellData.data!)
            return cell
        case .trasaction_info_related_transaction:
            let cell = tableView.dequeueCell(ofType: TransactionItemTableViewCell.self, for: indexPath)
            cell.setLastCell(isLastCell: indexPath.row == sectionData.count - 1)
            cell.setDataForTransactionDetail(item: cellData.data!)
            return cell
        case .trasaction_info_support:
            let cell = tableView.dequeueCell(ofType: TransactionDetailHelpCenterTableViewCell.self, for: indexPath)
            return cell
        default:
            return UITableViewCell.init()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let cellData: TransactionDetailCustomModel = sectionData[indexPath.row]

        if(cellData.type == .trasaction_info_support) {
            UtilHelper.callLynkiDHotLine()
        } else if (cellData.type == .trasaction_info_gift_detail) {
            viewModel.getGiftDetail()
        } else if (cellData.type == .trasaction_info_related_transaction) {
            self.navigator.show(segue: .transactionDetail(tokenTransID: "\(cellData.data?.tokenTransId ?? "")")) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
