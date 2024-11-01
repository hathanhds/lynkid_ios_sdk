//
//  GiftFilterViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/03/2024.
//

import UIKit
import RxSwift

class GiftFilterViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = GiftFilterViewModel

    static func create(with navigator: Navigator, viewModel: GiftFilterViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: GiftFilterViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var layoutView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var fromCoinTF: UITextField!
    @IBOutlet weak var toCoinTF: UITextField!
    @IBOutlet weak var disableSelectedPriceView: UIView!
    @IBOutlet weak var isSuitablePriceButton: UIButton!
    @IBOutlet weak var priceCollectionView: UICollectionView!
    @IBOutlet weak var giftTypeCollectionView: UICollectionView!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    // Danh mục
    @IBOutlet weak var cateStackView: UIStackView!
    @IBOutlet weak var catesCollectionView: UICollectionView!
    @IBOutlet weak var catesCollectionViewHeightConstraint: NSLayoutConstraint!


    fileprivate let listPrice = RangeCoin.defaultRangeCoinList
    fileprivate let rowHeight = 44.0

    var viewModel: GiftFilterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initView() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        self.scrollView.addGestureRecognizer(panGesture)

        headerView.layer.masksToBounds = false
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        catesCollectionView.registerCellFromNib(ofType: OptionItemCollectionViewCell.self)
        giftTypeCollectionView.registerCellFromNib(ofType: OptionItemCollectionViewCell.self)
        locationCollectionView.registerCellFromNib(ofType: OptionItemCollectionViewCell.self)

        cateStackView.isHidden = !viewModel.isShowCates
    }

    override func bindToView() {
        viewModel.output.isSuitablePrice.subscribe { [weak self] isSelected in
            guard let self = self else { return }
            isSuitablePriceButton.setImage(with: isSelected ? .iconCheckBox : .iconUncheckBox)
            disableSelectedPriceView.isHidden = !isSelected
        }.disposed(by: disposeBag)

        viewModel.output.selectedRangePrice.subscribe { [weak self] selectedRangePrice in
            guard let self = self else { return }
            if let price = selectedRangePrice {
                fromCoinTF.text = price.fromCoin.formatter()
                toCoinTF.text = price.toCoin.formatter()
            }
            self.priceCollectionView.reloadData()
        }.disposed(by: disposeBag)

        viewModel.output.selectedCates.subscribe { [weak self] selectedRangePrice in
            guard let self = self else { return }
            self.catesCollectionView.reloadData()
        }.disposed(by: disposeBag)

        viewModel.output.selectedGiftType.subscribe { [weak self] selectedRangePrice in
            guard let self = self else { return }
            self.giftTypeCollectionView.reloadData()
        }.disposed(by: disposeBag)


        viewModel.output.selectedLocations.subscribe { [weak self] selectedRangePrice in
            guard let self = self else { return }
            self.locationCollectionView.reloadData()
        }.disposed(by: disposeBag)

        viewModel.output.isLoadingGiftCates.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }).disposed(by: disposeBag)

        viewModel.output.giftCates.subscribe(onNext: { [weak self] cates in
            guard let self = self else { return }
            cateStackView.isHidden = cates.isEmpty
            let numberOfRow = (cates.count + 1) / 2
            let spacing = 8.0
            catesCollectionViewHeightConstraint.constant = (rowHeight + spacing) * Double(numberOfRow)
            catesCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: Actions

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)

        switch gestureRecognizer.state {
        case .changed:
            // Update the position of the view based on the gesture translation
            view.frame.origin.y = max(translation.y, 0)

        case .ended:
            let velocity = gestureRecognizer.velocity(in: view)

            // If the gesture ends with sufficient velocity or the view is swiped halfway down, dismiss the view controller with animation
            if velocity.y >= 1000 || view.frame.origin.y > view.frame.size.height / 2 {
                dismissWithAnimation()
            } else {
                // Otherwise, animate the view back to its original position
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }

        default:
            break
        }
    }

    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.size.height
        }, completion: { _ in
                self.dismiss(animated: false, completion: nil)
            })
    }

    @IBAction func onCloseAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func dimissKeyBoard(_ sender: Any) {
        //view.endEditing(true)
    }


    @IBAction func fromCoinEditChanged(_ sender: UITextField) {
        viewModel.input.onEdittingFromCoin.onNext(sender.text)
        if let amountString = sender.text?.currencyFomatter() {
            fromCoinTF.text = amountString
        }
    }

    @IBAction func toCoinEdittChanged(_ sender: UITextField) {
        viewModel.input.onEdittingToCoin.onNext(sender.text)
        if let amountString = sender.text?.currencyFomatter() {
            toCoinTF.text = amountString
        }
    }


    @IBAction func onIsSuitablePriceAction(_ sender: Any) {
        let isSuitablePriceSubj = viewModel.isSuitablePriceSubj.value
        viewModel.isSuitablePriceSubj.accept(!isSuitablePriceSubj)
    }

    @IBAction func onApplyFilterAction(_ sender: Any) {
        viewModel.input.onApplyFilter.onNext(())
        self.dismiss(animated: true)
    }

    @IBAction func onResetFilterAction(_ sender: Any) {
        viewModel.input.onResetFilter.onNext(())
    }
}

extension GiftFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case priceCollectionView:
            let cell = collectionView.dequeueCell(ofType: GiftFilterPriceCollectionViewCell.self, for: indexPath)
            let price = listPrice[indexPath.row]
            cell.setDataForCell(data: price, isSelected: viewModel.output.selectedRangePrice.value == price)
            return cell
        case catesCollectionView:
            let cate = viewModel.output.giftCates.value[indexPath.row]
            let option = OptionModel(id: cate.code ?? "", title: cate.name ?? "")
            let cell = collectionView.dequeueCell(ofType: OptionItemCollectionViewCell.self, for: indexPath)
            cell.setDataForCell(data: option, isSelected: viewModel.output.selectedCates.value.contains(option))
            return cell
        case giftTypeCollectionView:
            let option = GiftFilterModel.giftTypes[indexPath.row]
            let cell = collectionView.dequeueCell(ofType: OptionItemCollectionViewCell.self, for: indexPath)
            cell.setDataForCell(data: option, isSelected: viewModel.output.selectedGiftType.value == option)
            return cell
        case locationCollectionView:
            let option = GiftFilterModel.locations[indexPath.row]
            let cell = collectionView.dequeueCell(ofType: OptionItemCollectionViewCell.self, for: indexPath)
            cell.setDataForCell(data: option, isSelected: viewModel.output.selectedLocations.value.contains(option))
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case priceCollectionView:
            return listPrice.count
        case catesCollectionView:
            return viewModel.output.giftCates.value.count
        case giftTypeCollectionView:
            return GiftFilterModel.giftTypes.count
        case locationCollectionView:
            return GiftFilterModel.locations.count
        default:
            return 0
        }
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        switch collectionView {
        case priceCollectionView:
            let price = listPrice[index]
            viewModel.input.onSelectRangePrice.onNext(price)
            break
        case catesCollectionView:
            let cate = viewModel.output.giftCates.value[index]
            viewModel.input.onSelectCate.onNext(OptionModel(id: cate.code ?? "", title: cate.name ?? ""))
        case giftTypeCollectionView:
            let option = GiftFilterModel.giftTypes[index]
            viewModel.input.onSelectGiftType.onNext(option)
            break
        case locationCollectionView:
            let option = GiftFilterModel.locations[index]
            viewModel.input.onSelectLocation.onNext(option)
            break
        default:
            break
        }
    }

    // MARK: - Flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 8.0
        switch collectionView {
        case priceCollectionView:
            let _spacing: Double = spacing * Double((listPrice.count - 1))
            let width = CGFloat(collectionView.frame.width - _spacing) / CGFloat(listPrice.count)
            return CGSize(width: width, height: 40.0)
        case catesCollectionView:
            let width = (collectionView.frame.width - spacing) / min (CGFloat(viewModel.output.giftCates.value.count), 2.0)
            return CGSize(width: width, height: rowHeight)
        case giftTypeCollectionView:
            let width = (collectionView.frame.width - spacing) / CGFloat(GiftFilterModel.giftTypes.count)
            return CGSize(width: width, height: rowHeight)
        case locationCollectionView:
            let width = (collectionView.frame.width - spacing) / CGFloat(GiftFilterModel.locations.count)
            return CGSize(width: width, height: rowHeight)
        default:
            return collectionView.bounds.size
        }
    }

}

extension GiftFilterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let maxLength = 13
        return newText.count < maxLength
//            && string.containsNumbers() || string.containsSpecialCharacters(exceptions: ["."])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
