//
//  ListGiftViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/02/2024.
//

import UIKit
import RxSwift

class ListGiftByCateViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = ListGiftByCateViewModel

    static func create(with navigator: Navigator, viewModel: ListGiftByCateViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: ListGiftByCateViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets

    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var cateCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cateContainerView: UIView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortImageView: UIImageView!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var icFilterImageView: UIImageView!
    @IBOutlet weak var icTickCircleImageView: UIImageView!

    var viewModel: ListGiftByCateViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadSubj.onNext(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        if let v = self.tableView.refreshControl, v.isRefreshing {
            v.endRefreshing()
            v.beginRefreshing()
            self.tableView.contentOffset = CGPoint(x: 0, y: -(v.bounds.height))
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.floatingView.setCommonGradient()
    }


    override func initView() {
        self.addBackButton()
        self.addRightBarButtonWith(image: .icSearchGift, selector: #selector(self.onSearch))
        self.title = "Danh mục ưu đãi"
        cateContainerView.add(border: .bottom, color: .cEFEFF6!, width: 1.0)
        tableView.tableFooterView = UIView()

        // init nib
        cateCollectionView.registerCellFromNib(ofType: GiftCategoryCollectionViewCell.self)
        tableView.register(cellType: GiftTableViewCell.self)
        tableView.register(cellType: GiftGroupTableViewCell.self)
        tableView.register(cellType: GiftSectionTitleTableViewCell.self)
        tableView.addPullToRefresh(target: self, action: #selector(self.onRefresh))
    }

    override func setImage() {
        icTickCircleImageView.image = .iconTickCircle
        icFilterImageView.image = .iconFilter
    }

    @objc func onSearch() {
        self.openSearchScreen()
    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }


    override func bindToView() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self.tableView.endRefreshing()
        }.disposed(by: disposeBag)

        viewModel.output.isLoadingGiftCates
            .subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            self.cateCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // LoadMore
        viewModel.output.isLoadMore
            .subscribe(onNext: { [weak self] isLoadMore in
            guard let self = self else { return }
            if isLoadMore {
                self.tableView.addBottomLoadingView()
            } else {
                self.tableView.removeBottomLoadingView()
            }
        }).disposed(by: disposeBag)

        // Selelect cates
        viewModel.output.selectedCate.subscribe(onNext: { [weak self] selectedCate in
            guard let self = self else { return }
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }).disposed(by: disposeBag)

        // Gift
        viewModel.output.isLoadingGifts.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            self.tableView.reloadData()
        })
            .disposed(by: disposeBag)

        // Filter icon
        viewModel.output.filterModel
            .subscribe(onNext: { [weak self] filterModel in
            guard let self = self else { return }
            self.icTickCircleImageView.isHidden = filterModel == nil
        }).disposed(by: disposeBag)

        viewModel.output.sorting
            .subscribe(onNext: { [weak self] sorting in
            guard let self = self else { return }
            if (sorting == GiftSorting.requiredCoinAsc || sorting == GiftSorting.displayOrder) {
                sortLabel.text = "Giá tăng dần"
                sortImageView.image = .iconSortAsc
            } else {
                sortLabel.text = "Giá giảm dần"
                sortImageView.image = .iconSortDesc
            }
        }).disposed(by: disposeBag)


        // Button
        sortButton.rx.tap
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.onSorting()

        }).disposed(by: disposeBag)

        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let selectedCate = viewModel.output.selectedCate.value
            let isSelectCateAll = selectedCate?.categoryTypeCode == "all"
            self.navigator.show(segue: .giftFilter(filterModel: viewModel.output.filterModel.value, applyFilterAction: { filterModel in
                self.viewModel.onApplyFilterModelCallBack(filterModel: filterModel)
            }, isShowCates: isSelectCateAll)) { vc in
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}

// CollectionView

extension ListGiftByCateViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//    // MARK: - Datasource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel.output.giftCates.value.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: GiftCategoryCollectionViewCell.self, for: indexPath)
        let category = viewModel.output.giftCates.value[indexPath.row]
        let selectedCate = viewModel.output.selectedCate.value
        cell.setDataForCell(cate: category, isSelectedCate: category == selectedCate)
        return cell
    }

    // MARK: - Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.output.giftCates.value[indexPath.row]
        viewModel.input.onSelectedCate.onNext(category)
        collectionView.reloadData()
        if (category.isCashOut) {
            UtilHelper.showInstallAppPopup(parentVC: self)
        } else if (category.isDiamond) {
            self.navigator.show(segue: .listDiamondGiftByCate(cate: category)) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ListGiftByCateViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = tableView.dequeueCell(ofType: GiftSectionTitleTableViewCell.self)
        return section.contentView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return .leastNormalMagnitude
        }
        let totalGifts = viewModel.output.gifts.value.count
        return totalGifts > 0 ? 55 : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = viewModel.output.gifts.value.count
        tableView.backgroundView = (viewModel.output.isLoadingGifts.value == false && itemCount == 0) ? emptyView : nil

        if (itemCount == 0) {
            return 0
        }

        if (section == 0) {
            return 1
        }
        return itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Nếu section = 0
        // Đang không chọn cate Tất cả
        // Hoặc không có quà ưu đãi nổi bật
        // Ẩn cate theo group
        if (indexPath.section == 0 && (viewModel.output.selectedCate.value != GiftCategory().cateAll || (viewModel.output.giftGroup.value?.gifts ?? []).isEmpty)) {
            return .leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueCell(ofType: GiftGroupTableViewCell.self, for: indexPath)
            let giftGroupItem = viewModel.output.giftGroup.value
            let groupName = "Ưu đãi nổi bật"
            cell.setDatForCell(giftGroupItem: giftGroupItem ?? GiftGroupItem())
            cell.groupNameLabel.text = groupName
            cell.didOpenListGift = {
                self.navigator.show(segue: .listGiftByGroup(groupName: groupName, groupCode: giftGroupItem?.giftGroup?.code ?? "")) { vc in
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.didOpenGift = { (giftId, giftInfo) in
                UtilHelper.openGiftDetailScreen(from: self, giftInfo: giftInfo, giftId: giftId, isDiamond: giftInfo.giftInfor?.isGiftDiamond ?? false)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(ofType: GiftTableViewCell.self, for: indexPath)
            let gift = viewModel.output.gifts.value[indexPath.row]
            cell.setDataForCell(data: gift)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLoadMore = viewModel.output.isLoadMore.value
        let currentGifts = viewModel.output.gifts.value
        if indexPath.row == currentGifts.count - 1,
            currentGifts.count < viewModel.totalCount,
            !isLoadMore {
            viewModel.onLoadMore()
        }
    }


    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var giftId = ""
        var giftInfo: GiftInfoItem?
        if (indexPath.section == 0) {
            if let gifts = viewModel.output.giftGroup.value?.gifts, let id = gifts[indexPath.row].giftInfo?.id {
                giftInfo = GiftInfoItem(giftInfor: gifts[indexPath.row].giftInfo)
                giftId = "\(id)"
            }
        } else {
            if let id = viewModel.output.gifts.value[indexPath.row].giftInfor?.id {
                giftInfo = viewModel.output.gifts.value[indexPath.row]
                giftId = "\(id)"
            }
        }
        UtilHelper.openGiftDetailScreen(from: self, giftInfo: giftInfo, giftId: giftId, isDiamond: giftInfo?.giftInfor?.isGiftDiamond ?? false)
    }
}


extension ListGiftByCateViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != cateCollectionView) {
            floatingView.isHidden = true
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != cateCollectionView) {
            floatingView.isHidden = false
        }
    }
}
