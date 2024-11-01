//
//  MyRewardFilterViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/05/2024.
//

import UIKit
import RxSwift

class MyRewardFilterViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = MyRewardFilterViewModel

    static func create(with navigator: Navigator, viewModel: MyRewardFilterViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: MyRewardFilterViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var layoutView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!

    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var giftTypeCollectionView: UICollectionView!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var presentCollectionView: UICollectionView!

    @IBOutlet weak var divider1View: UIView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var divider2View: UIView!
    @IBOutlet weak var presentContainerView: UIView!


    let listPrice = RangeCoin.defaultRangeCoinList

    var viewModel: MyRewardFilterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.contentStackView.addGestureRecognizer(panGesture)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onCloseAction))
        self.layoutView.addGestureRecognizer(gesture)

        headerView.layer.masksToBounds = false
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        giftTypeCollectionView.registerCellFromNib(ofType: OptionItemCollectionViewCell.self)
        statusCollectionView.registerCellFromNib(ofType: OptionItemCollectionViewCell.self)
        presentCollectionView.registerCellFromNib(ofType: OptionItemCollectionViewCell.self)
    }


    override func bindToView() {
        viewModel.output.selectedGiftType.subscribe { [weak self] option in
            guard let self = self else { return }

            giftTypeCollectionView.reloadData()
        }.disposed(by: disposeBag)

        viewModel.output.selectedGiftType.subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            if (option?.id == "PhysicalGift") {
                self.hideEgiftFilter()
            } else {
                self.showEgiftFilter()
            }
            giftTypeCollectionView.reloadData()
        })
            .disposed(by: disposeBag)

        viewModel.output.selectedStatus.subscribe { [weak self] option in
            guard let self = self else { return }
            statusCollectionView.reloadData()
        }.disposed(by: disposeBag)

        viewModel.output.selectedPresentType.subscribe { [weak self] option in
            guard let self = self else { return }
            presentCollectionView.reloadData()
        }.disposed(by: disposeBag)
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

    @IBAction func onApplyFilterAction(_ sender: Any) {
        viewModel.input.onApplyFilter.onNext(())
        self.dismiss(animated: true)
    }

    @IBAction func onResetFilterAction(_ sender: Any) {
        viewModel.input.onResetFilter.onNext(())
    }
}

extension MyRewardFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case giftTypeCollectionView:
            let option = viewModel.getListGiftType()[indexPath.row]
            let cell = collectionView.dequeueCell(ofType: OptionItemCollectionViewCell.self, for: indexPath)
            cell.setDataForCell(data: option, isSelected: viewModel.output.selectedGiftType.value == option)
            return cell
        case statusCollectionView:
            let option = viewModel.getListStatus()[indexPath.row]
            let cell = collectionView.dequeueCell(ofType: OptionItemCollectionViewCell.self, for: indexPath)
            cell.setDataForCell(data: option, isSelected: viewModel.output.selectedStatus.value == option)
            return cell
        case presentCollectionView:
            let option = viewModel.getListPresent()[indexPath.row]
            let cell = collectionView.dequeueCell(ofType: OptionItemCollectionViewCell.self, for: indexPath)
            cell.setDataForCell(data: option, isSelected: viewModel.output.selectedPresentType.value == option)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case giftTypeCollectionView:
            return viewModel.getListGiftType().count
        case statusCollectionView:
            return viewModel.getListStatus().count
        case presentCollectionView:
            return viewModel.getListPresent().count
        default:
            return 0
        }
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        switch collectionView {
        case giftTypeCollectionView:
            let option = viewModel.getListGiftType()[index]
            viewModel.input.onSelectGiftType.onNext(option)
            break
        case statusCollectionView:
            let option = viewModel.getListStatus()[index]
            viewModel.input.onSelectStatus.onNext(option)
            break
        case presentCollectionView:
            let option = viewModel.getListPresent()[index]
            viewModel.input.onSelectPresentType.onNext(option)
            break
        default:
            break
        }
    }

    // MARK: - Flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case giftTypeCollectionView:
            return calculateItemSize(list: viewModel.getListGiftType(), collectionView: collectionView)
        case statusCollectionView:
            return calculateItemSize(list: viewModel.getListStatus(), collectionView: collectionView)
        case presentCollectionView:
            return calculateItemSize(list: viewModel.getListPresent(), collectionView: collectionView)
        default:
            return collectionView.bounds.size
        }
    }

    func calculateItemSize(list: [OptionModel], collectionView: UICollectionView) -> CGSize {
        let padding = 8.0
        let _spacing: Double = list.count > 1 ? padding * Double((list.count - 1)) : 0
        let width = CGFloat(collectionView.frame.width - _spacing) / CGFloat(list.count)
        let height = 40.0
        return CGSize(width: width, height: height)
    }

}


extension MyRewardFilterViewController {
    func showEgiftFilter() {
        UIView.transition(with: self.contentStackView, duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.divider1View.isHidden = false
                self.divider2View.isHidden = false
                self.statusContainerView.isHidden = false
                self.presentContainerView.isHidden = false
            })
    }

    func hideEgiftFilter() {
        UIView.transition(with: self.contentStackView, duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.divider1View.isHidden = true
                self.divider2View.isHidden = true
                self.statusContainerView.isHidden = true
                self.presentContainerView.isHidden = true
            })
    }
}
