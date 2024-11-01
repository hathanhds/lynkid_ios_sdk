//
//  ListGiftViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/02/2024.
//

import UIKit
import RxSwift
import SkeletonView

class ListDiamondGiftByCateViewController: BaseViewController, ViewControllerType {

    var navView: UIView?
    var navImageView: UIImageView?

    typealias ViewModel = ListDiamondGiftByCateViewModel

    static func create(with navigator: Navigator, viewModel: ListDiamondGiftByCateViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: ListDiamondGiftByCateViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets

    @IBOutlet weak var cateCollectionView: UICollectionView!
    @IBOutlet weak var giftCollectionView: UICollectionView!
    @IBOutlet var collectionEmptyView: UIView!
    @IBOutlet weak var giftContainerView: UIView!
    @IBOutlet weak var cateContainerView: UIView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortImageView: UIImageView!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var lcCateTopToSuperViewTop: NSLayoutConstraint!

    var viewModel: ListDiamondGiftByCateViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadSubj.onNext(())
        setupImagetViewBehindBars()
        setupNavigationBar(isTransparent: true)
        self.hideNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let v = self.giftCollectionView.refreshControl, v.isRefreshing {
            v.endRefreshing()
            v.beginRefreshing()
            self.giftCollectionView.contentOffset = CGPoint(x: 0, y: -(v.bounds.height))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.floatingView.setGradient(colors: [.c92653E!, .cD4A666!, .c92653E!], direction: .right)
        collectionEmptyView.setGradient(colors: [.c0F0F0F!, .c47372B!], direction: .down)
        giftContainerView.setGradient(colors: [.c0F0F0F!, .c47372B!], direction: .down)
    }

    func setupNavigationBar(isTransparent: Bool) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        if #available(iOS 15, *) {

            if(isTransparent == true) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                // Set the title text attributes for a white color in the appearance object
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                navigationBar.standardAppearance = appearance
                navigationBar.compactAppearance = appearance // For iPhone small navigation bar in landscape.
                navigationBar.scrollEdgeAppearance = appearance // For large title navigation bar.
            } else {
                let appearance = UINavigationBarAppearance()
                navigationBar.standardAppearance = appearance
                navigationBar.compactAppearance = appearance
                navigationBar.scrollEdgeAppearance = appearance
                navigationBar.setGradientBackground(colors: [UIColor.c332D2E!.cgColor, UIColor.c332D2E!.cgColor], titleColor: UIColor.cE9B161!)
                navigationBar.tintColor = .cE9B161
            }

        }
    }

    override func initView() {
        // init nib
        cateCollectionView.registerCellFromNib(ofType: GiftCategoryCollectionViewCell.self)
        let cateLayout = UICollectionViewFlowLayout()
        cateLayout.scrollDirection = .horizontal
        cateLayout.itemSize = CGSize(width: 80, height: 100)
        cateCollectionView.collectionViewLayout = cateLayout

        giftCollectionView.registerCustomViewFromNib(ofType: DiamondGiftCollectionViewHeader.self, forKind: UICollectionView.elementKindSectionHeader)
        giftCollectionView.registerCustomViewFromNib(ofType: LoadMoreFooterCollectionView.self, forKind: UICollectionView.elementKindSectionFooter)
        giftCollectionView.registerCellFromNib(ofType:
                DiamondGiftCollectionViewCell.self)
        giftCollectionView.addPullToRefresh(target: self, action: #selector(self.onRefresh), tintColor: .white)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let itemWidth = (self.view.frame.width - 48) / 2;
        let itemHeight = itemWidth * 172 / 164
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        giftCollectionView.collectionViewLayout = layout

        backButton.layer.cornerRadius = 16;
        backButton.layer.masksToBounds = true;

    }

    func setupImagetViewBehindBars() {
        if(navView != nil || navImageView != nil) {
            navImageView?.removeFromSuperview()
            navView?.removeFromSuperview()
        }
        let ratio = 211.0 / 375.0
        let width = view.frame.size.width
        navView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width * ratio))
        navImageView = UIImageView(frame: navView!.frame)

        navImageView?.image = .imageBgHeaderDiamond
//        navImageView?.contentMode = .scaleAspectFill
        navView?.addSubview(navImageView!)

        let gradientView = UIView(frame: CGRect(x: 0, y: navView!.frame.size.height / 2, width: navView!.frame.size.width, height: navView!.frame.height / 2))
        gradientView.setGradient(colors: [.c242021!.withAlphaComponent(0), .c171514!], direction: .down)
        navView?.addSubview(gradientView)
        // Place the gradient view behind all other views
        view.addSubview(navView!)
        view.sendSubviewToBack(navView!)
    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }

    @IBAction func onBack(_ sender: Any) {
        self.pop()
    }


    @objc func handleSearchButtonClick() {
        self.openSearchScreen()
    }

    override func bindToView() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self.giftCollectionView.endRefreshing()
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
//                self.tableView.addBottomLoadingView()
            } else {
//                self.tableView.removeBottomLoadingView()
            }
        }).disposed(by: disposeBag)

        // Selelect cates
        viewModel.output.selectedCate.subscribe(onNext: { [weak self] selectedCate in
            guard let self = self else { return }
//            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }).disposed(by: disposeBag)

        // Gift
        viewModel.output.isLoadingGifts.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showDiamondLoading()
            } else {
                self.hideLoading()
            }
            self.giftCollectionView.reloadData()
        })
            .disposed(by: disposeBag)

        viewModel.output.sorting
            .subscribe(onNext: { [weak self] sorting in
            guard let self = self else { return }
            if (sorting == GiftSorting.popular) {
                sortLabel.text = "Phổ biến nhất"
                sortImageView.image = .iconSortAsc
            } else {
                sortLabel.text = "Giá rẻ nhất"
                sortImageView.image = .iconSortDesc
            }
        }).disposed(by: disposeBag)


        // Button
        sortButton.rx.tap
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigator.show(segue: .popupDiamondFilter(dismissable: true, selectedOption: self.viewModel.output.sorting.value, applyButtonAction: { selectedOption in

                self.viewModel.onFiltering(selectedOption: selectedOption)

            })) { [weak self] vc in
                guard let self = self else { return }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.navigationController?.present(vc, animated: true)
            }


        }).disposed(by: disposeBag)
    }

}

// CollectionView

extension ListDiamondGiftByCateViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Datasource
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        if(skeletonView == cateCollectionView) {
            return String(describing: GiftCategoryCollectionViewCell.self)
        } else {
            return String(describing: DiamondGiftCollectionViewCell.self)
        }
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(skeletonView == cateCollectionView) {
            return 6
        } else {
            return viewModel.output.gifts.value.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == cateCollectionView) {
            return self.viewModel.output.giftCates.value.count
        } else {
            let itemCount = self.viewModel.output.gifts.value.count
            giftCollectionView.backgroundView = (viewModel.output.isLoadingGifts.value == false && itemCount == 0) ? collectionEmptyView : nil
            return itemCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == giftCollectionView {
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueHeaderHeaderView(ofType: DiamondGiftCollectionViewHeader.self, forKind: kind, for: indexPath)
                // Configure your header view here
                header.setDataForCell(data: viewModel.output.selectedCate.value!)
                return header
            } else if (kind == UICollectionView.elementKindSectionFooter) {
                let footer = collectionView.dequeueHeaderFooterView(ofType: LoadMoreFooterCollectionView.self, forKind: kind, for: indexPath)
                footer.indicator.color = .cE9B161
                footer.indicator.startAnimating()
                return footer

            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if(collectionView == giftCollectionView) {
            if let descTitle = viewModel.output.selectedCate.value!.descTitle, let descContent = viewModel.output.selectedCate.value!.descContent {
                if(descTitle.count + descContent.count == 0) {
                    return CGSizeZero
                } else {
                    // Assuming there is a method to calculate the text height based on the content
                    let width = collectionView.bounds.width
                    let horizontalPadding: CGFloat = 28
                    let verticalPadding: CGFloat = 12
                    let spaceBetween: CGFloat = 4
                    let contentWidth = width - horizontalPadding * 2

                    // Calculate the height of each label
                    let label1Height = descTitle.count > 0 ? UtilHelper.heightForLabel(text: descTitle, font: .f14s!, width: contentWidth) : 0
                    let label2Height = descContent.count > 0 ? UtilHelper.heightForLabel(text: descContent, font: .f14r!, width: contentWidth) : 0

                    // Sum up all the heights and any additional padding
                    let totalHeight = label1Height + label2Height + 2 * verticalPadding + spaceBetween + 20

                    return CGSize(width: width, height: totalHeight)
                }
            }
        }

        return CGSizeZero

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let isLoadingGift = self.viewModel.output.isLoadingGifts.value
        let isLoadMore = self.viewModel.output.isLoadMore.value
        if(collectionView == giftCollectionView && isLoadingGift == false && isLoadMore == true) {
            return CGSize(width: collectionView.frame.width, height: 64)
        }
        return CGSizeZero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == cateCollectionView) {
            let cell = collectionView.dequeueCell(ofType: GiftCategoryCollectionViewCell.self, for: indexPath)
            let category = viewModel.output.giftCates.value[indexPath.row]
            let selectedCate = viewModel.output.selectedCate.value
            cell.setDataForCell(cate: category, isSelectedCate: category == selectedCate, isDiamond: true)
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: DiamondGiftCollectionViewCell.self, for: indexPath)
            let gift = viewModel.output.gifts.value[indexPath.row]
            cell.setDataForCell(data: gift.giftInfor, imageLink: gift.imageLink?.first?.fullLink)
            return cell
        }
    }

    // MARK: - Delegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLoadMore = viewModel.output.isLoadMore.value
        let currentGifts = viewModel.output.gifts.value
        if indexPath.row == currentGifts.count - 1,
            currentGifts.count < viewModel.totalCount,
            !isLoadMore {
            viewModel.onLoadMore()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == cateCollectionView) {
            let category = viewModel.output.giftCates.value[indexPath.row]
            viewModel.input.onSelectedCate.onNext(category)
            collectionView.reloadData()
        } else {
            let gift = viewModel.output.gifts.value[indexPath.row]
            let giftId = gift.giftInfor?.id ?? 0
            self.navigator.show(segue: .giftDetailDiamond(giftInfo: gift, giftId: "\(giftId)")) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
    }
}


extension ListDiamondGiftByCateViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        floatingView.isHidden = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        floatingView.isHidden = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let yOffset = self.giftCollectionView.contentOffset.y
        if(yOffset > 25 && yOffset < 170) {
            lcCateTopToSuperViewTop.constant = 170 - yOffset
        }

        if(yOffset >= 170) {
            lcCateTopToSuperViewTop.constant = 0
            self.showNavigationBar()
            self.addBackButton(withIcon: .icBackDiamondBtn)
            self.addRightBarButtonWith(image: .icSearchDiamondBtn, selector: #selector(self.handleSearchButtonClick))
            self.title = "Diamond"
            setupNavigationBar(isTransparent: false)
            cateContainerView.backgroundColor = .c332D2E
            cateContainerView.add(border: .top, color: .c524C4D!, width: 1.0)
            backButton.isHidden = true
        } else {
            self.hideNavigationBar()
            setupNavigationBar(isTransparent: true)
            cateContainerView.backgroundColor = .clear
            cateContainerView.remove1(border: .top)
            backButton.isHidden = false
        }
    }
}


