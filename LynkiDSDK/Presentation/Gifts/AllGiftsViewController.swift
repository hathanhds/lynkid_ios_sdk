//
//  AllVouchersViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 29/01/2024.
//

import UIKit
import RxSwift
import SkeletonView

class AllGiftsViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = AllGiftsViewModel

    static func create(with navigator: Navigator, viewModel: AllGiftsViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: AllGiftsViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var bgHeaderImageView: UIImageView!

    @IBOutlet weak var myRewardFloatView: UIView!

    var viewModel: AllGiftsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar(animated: true)
        tableView.addObserver(self, forKeyPath: "contentSize",
            options: .new, context: nil)
        if let v = self.scrollView.refreshControl, v.isRefreshing {
            v.endRefreshing()
            v.beginRefreshing()
            self.scrollView.contentOffset = CGPoint(x: 0, y: -(v.bounds.height))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.showNavigationBar(animated: false)
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myRewardFloatView.setCommonGradient()
    }

    override func setImage() {
        backButton.setImage(with: .iconBack)
        searchImageView.image = .iconSearchWhite
        bgHeaderImageView.image = .bgHeader
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard
        keyPath == "contentSize",
            let newValue = change?[.newKey] as? CGSize,
            let object = object
            else {
            return
        }
        if object is UITableView {
            let height = newValue.height
            self.tableViewHeightConstant.constant = height
        }
    }

    override func initView() {
        scrollView.addPullToRefresh(target: self, action: #selector(self.onRefresh))
        // Init nib view
        categoryCollectionView.registerCellFromNib(ofType: GiftCategoryCollectionViewCell.self)
        tableView.register(cellType: GiftGroupTableViewCell.self)
        categoryContainerView.layer.masksToBounds = false
        categoryContainerView.layer.shadowOpacity = 0.13

    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }

    override func bindToView() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self.scrollView.endRefreshing()
        }.disposed(by: disposeBag)

        // Gift cates
        viewModel.output.isLoadingGiftCates.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            self.categoryCollectionView.reloadData()
        })
            .disposed(by: disposeBag)

        viewModel.output.selectedCate.subscribe(onNext: { [weak self] selectedCate in
            guard let self = self else { return }
            self.categoryCollectionView.reloadData()
        })
            .disposed(by: disposeBag)

        // Gift groups
        viewModel.output.isLoadingGiftGroup.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            self.tableView.reloadData()
        })
            .disposed(by: disposeBag)

    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: Any) {
        self.pop()
    }

    @IBAction func searchAction(_ sender: Any) {
        self.openSearchScreen()
    }

    @IBAction func openMyrewardScreen(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            if let myrewardNavController = tabBarController.viewControllers?[1] as? UINavigationController {
                myrewardNavController.popToRootViewController(animated: false)
            }
            self.backToHomeScreen()
            // Switch to the first tab
            tabBarController.selectedIndex = 1
        }
    }

}

// CollectionView

extension AllGiftsViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Datasource
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {

        return String(describing: GiftCategoryCollectionViewCell.self)
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.output.giftCates.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: GiftCategoryCollectionViewCell.self, for: indexPath)
        let category = viewModel.output.giftCates.value[indexPath.row]
        let selectedCate = viewModel.output.selectedCate.value
        cell.setDataForCell(cate: category, type: .twoRow, isSelectedCate: selectedCate == category)
        return cell
    }

    // MARK: - Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.output.giftCates.value[indexPath.row]
        if (category.isCashOut) {
            UtilHelper.showInstallAppPopup(parentVC: self)
        } else if (category.isDiamond) {
            self.navigator.show(segue: .listDiamondGiftByCate(cate: category)) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.navigator.show(segue: .listGiftByCate(cate: category), withAction: { [weak self] vc in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(vc, animated: true)

                })
        }

    }

    // MARK: - Flow

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.layer.bounds.width
        let collectionViewHeight = collectionView.layer.bounds.height
        let itemWidth = collectionViewWidth / 4.0
        let itemHeight = collectionViewHeight / 2.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// TableView

extension AllGiftsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.giftsByGroup.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: GiftGroupTableViewCell.self, for: indexPath)
        let giftGroupItem = viewModel.output.giftsByGroup.value[indexPath.row]
        let giftGroup = giftGroupItem.giftGroup
        cell.setDatForCell(giftGroupItem: giftGroupItem)
        cell.didOpenListGift = {
            self.navigator.show(segue: .listGiftByGroup(groupName: giftGroup?.name, groupCode: giftGroup?.code ?? "")) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        cell.didOpenGift = { (giftId, giftInfo) in
            UtilHelper.openGiftDetailScreen(from: self, giftInfo: giftInfo, giftId: giftId, isDiamond: giftInfo.giftInfor?.isGiftDiamond ?? false)
        }
        return cell
    }

}

extension AllGiftsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.categoryCollectionView == scrollView) {
            let minX: CGFloat = 0
            let maxX = scrollView.contentSize.width - scrollView.bounds.width
            let currentX = min(max(scrollView.contentOffset.x, minX), maxX)

            let indicatorWidth = 25.0

            let scale = indicatorWidth / scrollView.contentSize.width
            self.indicatorLeadingConstraint.constant = currentX * scale
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != categoryCollectionView) {
            myRewardFloatView.isHidden = true
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != categoryCollectionView) {
            myRewardFloatView.isHidden = false
        }
    }
}

