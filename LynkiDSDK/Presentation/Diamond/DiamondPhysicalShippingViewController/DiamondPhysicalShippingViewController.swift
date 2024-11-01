//
//  DiamondPhysicalShippingViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/06/2024.
//

import Foundation
import UIKit

class DiamondPhysicalShippingViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: DiamondPhysicalShippingViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: DiamondPhysicalShippingViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var nameTF: FloatingLabelTextField!
    @IBOutlet weak var nameErrorView: UIView!
    @IBOutlet weak var nameErrorLabel: UILabel!

    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var phoneTF: FloatingLabelTextField!
    @IBOutlet weak var phoneErrorView: UIView!
    @IBOutlet weak var phoneErrorLabel: UILabel!


    @IBOutlet weak var cityTF: FloatingLabelTextField!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var cityDropDownImageView: UIImageView!


    @IBOutlet weak var districtTF: FloatingLabelTextField!
    @IBOutlet weak var districtView: UIView!
    @IBOutlet weak var districtButton: UIButton!
    @IBOutlet weak var districtDropDownImageView: UIImageView!

    @IBOutlet weak var wardTF: FloatingLabelTextField!
    @IBOutlet weak var wardView: UIView!
    @IBOutlet weak var wardButton: UIButton!
    @IBOutlet weak var wardDropDownImageView: UIImageView!

    @IBOutlet weak var detailAddressContainerView: UIView!
    @IBOutlet weak var detailAddressTF: FloatingLabelTextField!
    @IBOutlet weak var noteContainerView: UIView!
    @IBOutlet weak var noteTF: UITextField!

    var viewModel: DiamondPhysicalShippingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadSubj.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.setDiamondButtonGradient()
        view.setDiamondBackgroundGradient()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }

    override func initView() {
        self.title = "Thông tin người nhận"
        self.addDiamondBackButton()
        initTextField()
    }

    func initTextField() {
        nameTF.placeholder = "Họ và tên"
        phoneTF.placeholder = "Số điện thoại"
        cityTF.placeholder = "Tỉnh/Thành Phố"
        districtTF.placeholder = "Quận/Huyện"
        wardTF.placeholder = "Phường/Xã"
        detailAddressTF.placeholder = "Địa chỉ chi tiết"
        noteTF.placeholder = "Ghi chú"

        nameTF.floatingColor = .cA7A7B3!
        phoneTF.floatingColor = .cA7A7B3!
        cityTF.floatingColor = .cA7A7B3!
        districtTF.floatingColor = .cA7A7B3!
        wardTF.floatingColor = .cA7A7B3!
        detailAddressTF.floatingColor = .cA7A7B3!
        noteTF.placeholder = "Ghi chú"


        nameTF.keyboardAppearance = .dark
        phoneTF.keyboardAppearance = .dark
        detailAddressTF.keyboardAppearance = .dark
        noteTF.keyboardAppearance = .dark

        nameTF.setClearButtonWithImage(image: .iconDiamondClearTF)
        phoneTF.setClearButtonWithImage(image: .iconDiamondClearTF)
        detailAddressTF.setClearButtonWithImage(image: .iconDiamondClearTF)
        noteTF.setClearButtonWithImage(image: .iconDiamondClearTF)

    }

    override func bindToView() {
        // Button
        viewModel.output.isEnableButton.subscribe(onNext: { [weak self] isEnable in
            guard let self = self else { return }
            if (isEnable) {
                self.continueButton.enable()
            } else {
                self.continueButton.disable()
            }
        }).disposed(by: disposeBag)

        viewModel.output.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                showDiamondLoading()
            } else {
                hideLoading()
            }
        }).disposed(by: disposeBag)

        // Số điện thoại
        phoneTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
            self?.viewModel.validatePhone(self?.phoneTF.text)
        }).disposed(by: self.disposeBag)

        viewModel.output.phoneErrorText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            phoneErrorLabel.text = text
            showHideView(
                textField: phoneTF,
                containerView: phoneContainerView,
                errorView: phoneErrorView,
                label: phoneErrorLabel,
                isShowError: text != nil)
        }).disposed(by: disposeBag)

        phoneTF.rx.text.orEmpty
            .bind(to: viewModel.output.phoneInput)
            .disposed(by: disposeBag)

        // Họ và tên
        nameTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
            self?.viewModel.validateName(self?.nameTF.text)

        }).disposed(by: self.disposeBag)

        viewModel.output.nameErrorText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            nameErrorLabel.text = text
            showHideView(
                textField: nameTF,
                containerView: nameContainerView,
                errorView: nameErrorView,
                label: nameErrorLabel,
                isShowError: text != nil)
        }).disposed(by: disposeBag)

        nameTF.rx.text.orEmpty
            .bind(to: viewModel.output.nameInput)
            .disposed(by: disposeBag)

        // Tỉnh/Thành phố
        viewModel.output.selectedCity.subscribe(onNext: { [weak self] city in
            guard let self = self else { return }
            cityTF.text = city?.name
        }).disposed(by: disposeBag)

        viewModel.output.isCitiesLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            handleIndicator(imageView: cityDropDownImageView, isLoading: isLoading)
        }).disposed(by: disposeBag)

        // Quận/Huyện
        viewModel.output.selectedDistrict.subscribe(onNext: { [weak self] district in
            guard let self = self else { return }
            districtTF.text = district?.name
        }).disposed(by: disposeBag)

        viewModel.output.isDistrictLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            handleIndicator(imageView: districtDropDownImageView, isLoading: isLoading)
        }).disposed(by: disposeBag)

        viewModel.output.districts.subscribe(onNext: { [weak self] districts in
            guard let self = self else { return }
            handleLocationView(view: districtView,
                button: districtButton,
                isEnable: !districts.isEmpty)
        }).disposed(by: disposeBag)

        // Phường/Xã
        viewModel.output.selectedWard.subscribe(onNext: { [weak self] ward in
            guard let self = self else { return }
            wardTF.text = ward?.name
        }).disposed(by: disposeBag)

        viewModel.output.isWardsLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            handleIndicator(imageView: wardDropDownImageView, isLoading: isLoading)
        }).disposed(by: disposeBag)

        viewModel.output.wards.subscribe(onNext: { [weak self] wards in
            guard let self = self else { return }
            handleLocationView(view: wardView,
                button: wardButton,
                isEnable: !wards.isEmpty)
        }).disposed(by: disposeBag)

        // Địa chỉ chi tiết
        detailAddressTF.rx.text.orEmpty
            .bind(to: viewModel.output.detailAddressInput)
            .disposed(by: disposeBag)

        detailAddressTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
            self?.viewModel.onEditDetailAddress()
        }).disposed(by: self.disposeBag)

        // Ghi chú
        noteTF.rx.text.orEmpty
            .bind(to: viewModel.output.noteInput)
            .disposed(by: disposeBag)
    }

    override func bindToViewModel() {
        viewModel.output.nameInput
            .bind(to: nameTF.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.phoneInput
            .bind(to: phoneTF.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.detailAddressInput
            .bind(to: detailAddressTF.rx.text)
            .disposed(by: disposeBag)

    }

    fileprivate func showHideView(textField: UITextField, containerView: UIView, errorView: UIView, label: UILabel, isShowError: Bool) {
        if (isShowError) {
            errorView.isHidden = false
            setUpUIContainerView(view: containerView, status: .inValid)
        } else {
            errorView.isHidden = true
            hanldeFocus(textField)
        }
    }

    func handleLocationView(view: UIView, button: UIButton, isEnable: Bool) {
        if isEnable {
            view.backgroundColor = .clear
            button.isEnabled = true
        } else {
            view.backgroundColor = .c332D2E
            button.isEnabled = false
        }
    }

    fileprivate func setUpUIContainerView(view: UIView, status: Status) {
        switch status {
        case .normal:
            view.borderColor = .c37363A
        case .inValid:
            view.borderColor = .red
        case .focused:
            view.borderColor = .diamondColor
        }
    }

    fileprivate func handleIndicator(imageView: UIImageView, isLoading: Bool) {
        if (isLoading) {
            imageView.setImageColor(color: .clear)
            imageView.showIndicator()
        } else {
            imageView.setImageColor(color: .cA7A7B3!)
            imageView.hideIndicator()
        }
    }

    // MARK: -Action

    @IBAction func selectCityAction(_ sender: Any) {
        hanldeFocus(cityTF)
        self.navigator.show(segue: .diamondShippingLocation(data: ShippingLocationArguments(locationType: .city,
            locations: viewModel.output.cities.value,
            title: "Tỉnh/Thành phố",
            callBack: { [weak self] location in
                self?.viewModel.onSelectedCity(location: location)
            }))) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func selectDistrictAction(_ sender: Any) {
        hanldeFocus(districtTF)
        self.navigator.show(segue: .diamondShippingLocation(data: ShippingLocationArguments(locationType: .district,
            locations: viewModel.output.districts.value,
            title: "Quận/Huyện",
            callBack: { [weak self] location in
                self?.viewModel.onSelectedDistrict(location: location)
            }))) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func selectWardAction(_ sender: Any) {
        hanldeFocus(wardTF)
        self.navigator.show(segue: .diamondShippingLocation(data: ShippingLocationArguments(locationType: .ward,
            locations: viewModel.output.wards.value,
            title: "Phường/Xã",
            callBack: { [weak self] location in
                self?.viewModel.onSelectedWard(location: location)
            }))) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func onContinueAction(_ sender: Any) {
        self.navigator.show(segue: .diamondExchangeConfirm(
            data: GiftConfirmExchangeArguments(giftsRepository: GiftsRepositoryImpl(),
                giftInfo: viewModel.giftInfo,
                giftExchangePrice: viewModel.giftExchangePrice,
                receiverInfo: viewModel.getReceiverInfo()
            ))) { [weak self]
            vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}


extension DiamondPhysicalShippingViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hanldeFocus(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        hanldeFocus(textField)
    }

    func hanldeFocus(_ textField: UITextField) {
        setUpUIContainerView(view: nameContainerView, status: .normal)
        setUpUIContainerView(view: phoneContainerView, status: .normal)
        setUpUIContainerView(view: detailAddressContainerView, status: .normal)
        setUpUIContainerView(view: noteContainerView, status: .normal)
        switch textField {
        case nameTF:
            setUpUIContainerView(view: nameContainerView, status: .focused)
        case phoneTF:
            setUpUIContainerView(view: phoneContainerView, status: .focused)
        case detailAddressTF:
            setUpUIContainerView(view: detailAddressContainerView, status: .focused)
        case noteTF:
            setUpUIContainerView(view: noteContainerView, status: .focused)
        default:
            break
        }
        if (!(viewModel.output.nameErrorText.value ?? "").isEmpty) {
            setUpUIContainerView(view: nameContainerView, status: .inValid)
        }
        if (!(viewModel.output.phoneErrorText.value ?? "").isEmpty) {
            setUpUIContainerView(view: phoneContainerView, status: .inValid)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newLength = 0
        if let text = textField.text,
            let rangeOfTextToReplace = Swift.Range(range, in: text) {
            let substringToReplace = text[rangeOfTextToReplace]
            newLength = text.count - substringToReplace.count + string.count
        }
        if textField == phoneTF {
            return newLength < 13
                && !string.containsAlphabetLetters()
                && !string.containsSpecialCharacters()
        } else {
            return newLength < 255
        }
    }
}

fileprivate enum Status {
    case normal
    case inValid
    case focused
}
