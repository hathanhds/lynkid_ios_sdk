//
//  TopupListViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 09/08/2024.
//

import UIKit
import ContactsUI

class TopupListViewController: BaseViewController {

    static func create(with navigator: Navigator, viewModel: TopupListViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupListViewController.self)
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc as! Self
    }

    var viewModel: TopupListViewModel!
    private let headerViewHeight: CGFloat = 50
    private let cellHeight: CGFloat = 56

    // IBOutlets
    // Input
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var phoneInputContainerView: UIView!

    // Nhà mạng
    @IBOutlet weak var brandContainerView: UIView!
    @IBOutlet weak var brandCollectionView: UICollectionView!

    // Ưu đãi hot
    @IBOutlet weak var topupGroupViewContainer: UIView!
    @IBOutlet weak var discountContainerView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var noteContainerView: UIView!
    @IBOutlet weak var hotGiftCollectionView: UICollectionView!

    // Danh sách thẻ
    @IBOutlet weak var topupGroupCollectionView: UICollectionView!
    @IBOutlet weak var topupGroupHeightConstraint: NSLayoutConstraint!

    // Bottom button
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var earnMoreCoinView: EarnPointView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!

    override func viewDidLoad() {
        self.view.backgroundColor = .clear
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.setCommonGradient()
        discountContainerView.setGradient(colors: [.cFF7990!, .cFF3D5C!], direction: .right)
    }

    override func initView() {
        phoneTitleLabel.text = "Số của tôi"
        phoneTF.text = AppConfig.shared.phoneNumber.formatPhoneWithoutZone()
        registerCell()
//        setUpBottomBorder()
        handleShowHideView()
        earnMoreCoinView.initView(fromVC: self)
        earnMoreCoinView.isHidden = true

    }

    func registerCell() {
        brandCollectionView.registerCellFromNib(ofType: TopupBrandCollectionViewCell.self)
        hotGiftCollectionView.registerCellFromNib(ofType: TopupDataCollectionViewCell.self)
        hotGiftCollectionView.registerCellFromNib(ofType: TopupPhoneCollectionViewCell.self)
        topupGroupCollectionView.registerCellFromNib(ofType: TopupPhoneCollectionViewCell.self)
        topupGroupCollectionView.registerCellFromNib(ofType: TopupDataCollectionViewCell.self)

        topupGroupCollectionView.registerCustomViewFromNib(ofType: TopupSectionCollectionReusableView.self, forKind: UICollectionView.elementKindSectionHeader)
    }

    func setUpBottomBorder() {
        borderView.layer.masksToBounds = true
        borderView.layer.cornerRadius = 12
        borderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func handleShowHideView() {
        noteContainerView.isHidden = true
        if (viewModel.topupType == .topupPhone) {
            if (viewModel.topupPhoneType == .prePaid || viewModel.topupPhoneType == .postPaid) {
                inputStackView.isHidden = false
                brandContainerView.isHidden = true

            } else {
                inputStackView.isHidden = true
                brandContainerView.isHidden = false
            }
            noteContainerView.isHidden = viewModel.topupPhoneType != .postPaid
        }

        if (viewModel.topupType == .topupData) {
            if (viewModel.topupDataType == .topup) {
                inputStackView.isHidden = false
                brandContainerView.isHidden = true
            } else {
                inputStackView.isHidden = true
                brandContainerView.isHidden = false
            }
        }
    }

    override func bindToView() {
        // loading
        viewModel.isLoadingGift.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
                topupGroupHeightConstraint.constant = 300;
                topupGroupCollectionView.backgroundView = viewModel.giftGroupList.value.isEmpty ? emptyView : nil
                emptyLabel.text = viewModel.getEmptyTitle();
            }
        }).disposed(by: disposeBag)

        // brand loading
        viewModel.isLoadingBrand.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                brandImageView.showIndicator()
            } else {
                brandImageView.hideIndicator()
            }
            brandCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // brand list
        viewModel.brandList.subscribe(onNext: { [weak self] brandList in
            guard let self = self else { return }
            brandCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // gift group list
        viewModel.hotGiftList.subscribe(onNext: { [weak self] giftGorup in
            guard let self = self else { return }
            topupGroupViewContainer.isHidden = giftGorup.isEmpty
            hotGiftCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // gift list
        viewModel.giftGroupList.subscribe(onNext: { [weak self] giftList in
            guard let self = self else { return }
            topupGroupCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // selected brand
        viewModel.selectedBrand.subscribe(onNext: { [weak self] brand in
            guard let self = self else { return }
            brandImageView.setSDImage(with: brand?.linkLogo)
            brandCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // selected gift
        viewModel.selectedGift.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let earnMoreCoin = viewModel.getEarnMoreCoin()
            earnMoreCoinView.earnMoreCoin = earnMoreCoin
            earnMoreCoinView.isHidden = earnMoreCoin < 0
            hotGiftCollectionView.reloadData()
            topupGroupCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // phone input
        viewModel.phoneErrorText.subscribe(onNext: { [weak self] errorText in
            guard let self = self else { return }
            if ((errorText ?? "").isEmpty) {
                errorView.isHidden = true
                errorLabel.text = errorText
                phoneInputContainerView.borderColor = .cD8D6DD
            } else {
                errorLabel.text = errorText
                errorView.isHidden = false
                phoneInputContainerView.borderColor = .cF5574E
            }
        }).disposed(by: disposeBag)

        // enable button
        viewModel.isEnableButton.subscribe(onNext: { [weak self] isEnable in
            guard let self = self else { return }
            if (isEnable) {
                continueButton.enable()
            } else {
                continueButton.disable()
            }
        }).disposed(by: disposeBag)
    }

    override func bindToViewModel() {

        self.phoneTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.phoneTF.text = viewModel.getPhoneFormatter(self.phoneTF.text)
        })
            .disposed(by: self.disposeBag)

        phoneTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            viewModel.validatePhone(phoneTF.text)
            phoneTitleLabel.text = viewModel.getPhoneTitle(phoneTF.text)
        }).disposed(by: self.disposeBag)

        phoneTF.rx.text.orEmpty
            .bind(to: viewModel.phoneInput)
            .disposed(by: disposeBag)
    }



    // MARK: -Action

    @IBAction func openContactAction(_ sender: Any) {
        openPhoneContact()
    }

    @IBAction func continueAction(_ sender: Any) {
        if let giftInfo = viewModel.selectedGift.value, let brandInfo = viewModel.selectedBrand.value {
            self.navigator.show(segue: .topupConfirm(data: TopupConfirmArgument(
                giftInfo: giftInfo,
                brandInfo: brandInfo,
                topupPhoneType: viewModel.topupPhoneType,
                topupDataType: viewModel.topupDataType,
                topupType: viewModel.topupType,
                phoneNumber: viewModel.phoneInput.value ?? "",
                contactName: viewModel.getPhoneTitle(phoneTF.text)))) { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction func openBrandListAction(_ sender: Any) {
        self.navigator.show(segue: .topupBrandList(selectedBrandAction: { [weak self] brand in
            self?.viewModel.setSelectedBrand(brand: brand)
        }, currentBrand: viewModel.selectedBrand.value,
            brandList: viewModel.brandList.value)) { [weak self] vc in
            guard let self = self else { return }
//            let delegate = BottomSheetTransitioningDelegate(configuration: .default)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }

}

extension TopupListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: -Datasource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (collectionView == topupGroupCollectionView) {
            let sectionCount = viewModel.giftGroupList.value.count
            var totalRowHeight: CGFloat = 0
            let lineSpace = 8.0
            for i in 0..<sectionCount {
                let numberOfRow = (viewModel.giftGroupList.value[i].gifts.count + 1) / 2
                totalRowHeight += CGFloat(numberOfRow) * (cellHeight + lineSpace)
            }
            topupGroupHeightConstraint.constant = CGFloat(sectionCount) * headerViewHeight + totalRowHeight
            collectionView.updateConstraints()
            collectionView.updateConstraintsIfNeeded()
            return viewModel.giftGroupList.value.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == brandCollectionView) {
            return viewModel.brandList.value.count
        } else if(collectionView == hotGiftCollectionView) {
            return viewModel.hotGiftList.value.count
        } else if (collectionView == topupGroupCollectionView) {
            return viewModel.giftGroupList.value[section].gifts.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (collectionView == topupGroupCollectionView) {
            let headerView = collectionView.dequeueHeaderHeaderView(ofType: TopupSectionCollectionReusableView.self, forKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            let group = viewModel.giftGroupList.value[indexPath.section]
            headerView.titleLabel.text = group.title
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (collectionView == topupGroupCollectionView) {
            return CGSize(width: collectionView.frame.width, height: headerViewHeight)
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == brandCollectionView) {
            let cell = collectionView.dequeueCell(ofType: TopupBrandCollectionViewCell.self, for: indexPath)
            if let brandInfo = viewModel.brandList.value[indexPath.row].brandMapping {
                let isSelected = brandInfo.brandId == viewModel.selectedBrand.value?.brandId
                cell.setDataForCell(brandInfo: brandInfo, isSelected: isSelected)
            }
            return cell
        } else if(collectionView == hotGiftCollectionView) {
            let gift = viewModel.hotGiftList.value[indexPath.row]
            let isSelected = gift.giftInfor?.id == viewModel.selectedGift.value?.giftInfor?.id
            if viewModel.topupType == .topupPhone {
                let cell = collectionView.dequeueCell(ofType: TopupPhoneCollectionViewCell.self, for: indexPath)
                cell.setDataForCell(gift: gift, isSelected: isSelected)
                return cell
            } else {
                let cell = collectionView.dequeueCell(ofType: TopupDataCollectionViewCell.self, for: indexPath)
                cell.setDataForCell(gift: gift, isSelected: isSelected)
                return cell
            }
        } else if (collectionView == topupGroupCollectionView) {
            let group = viewModel.giftGroupList.value[indexPath.section]
            let gift = group.gifts[indexPath.row]
            let isSelected = gift.giftInfor?.id == viewModel.selectedGift.value?.giftInfor?.id
            if (viewModel.topupType == .topupPhone) {
                let phoneCell = collectionView.dequeueCell(ofType: TopupPhoneCollectionViewCell.self, for: indexPath)
                phoneCell.setDataForCell(gift: gift, isSelected: isSelected)
                return phoneCell
            } else {
                let dataCell = collectionView.dequeueCell(ofType: TopupDataCollectionViewCell.self, for: indexPath)
                dataCell.setDataForCell(gift: gift, isSelected: isSelected)
                return dataCell
            }
        }
        return UICollectionViewCell()
    }


    // MARK: -Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == brandCollectionView) {
            if let brandInfo = viewModel.brandList.value[indexPath.row].brandMapping {
                viewModel.setSelectedBrand(brand: brandInfo)
            }
        } else if(collectionView == hotGiftCollectionView) {
            let gift = viewModel.hotGiftList.value[indexPath.row]
            viewModel.setSelectedGift(gift: gift)
        } else if (collectionView == topupGroupCollectionView) {
            let gift = viewModel.giftGroupList.value[indexPath.section].gifts[indexPath.row]
            viewModel.setSelectedGift(gift: gift)
        }
    }

    // MARK: -Flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 16.0
        let spacing = 8.0
        let width = (UtilHelper.screenWidth - padding * 2 - spacing) / 2.0
        if (collectionView == brandCollectionView) {
            return CGSize(width: 62, height: 62)
        } else if (collectionView == hotGiftCollectionView) {
            return CGSize(width: width, height: 64)
        } else {
            return CGSize(width: width, height: cellHeight)
        }
    }
}

extension TopupListViewController: CNContactPickerDelegate {
    func openPhoneContact() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0") // Only show contacts with phone numbers
        present(contactPicker, animated: true, completion: nil)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        for phoneNumber in contact.phoneNumbers {
            let number = phoneNumber.value.stringValue
            print("Selected phone number: \(number)")
            let fullName = "\(contact.givenName) \(contact.familyName)"
            phoneTitleLabel.text = fullName
            let phoneFormatter = viewModel.getPhoneFormatter(number)
            phoneTF.text = phoneFormatter
            viewModel.validatePhone(phoneFormatter)
        }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("User canceled contact picker")
    }
}

extension TopupListViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newLength = 0
        if let text = textField.text,
            let rangeOfTextToReplace = Swift.Range(range, in: text) {
            let substringToReplace = text[rangeOfTextToReplace]
            newLength = text.count - substringToReplace.count + string.count
        }
        return newLength < 11
            && !string.containsAlphabetLetters()
            && !string.containsSpecialCharacters()
    }
}
