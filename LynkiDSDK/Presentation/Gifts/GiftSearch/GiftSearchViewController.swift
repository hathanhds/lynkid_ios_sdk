//
//  GiftSearchViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 29/05/2024.
//

import UIKit
import RxSwift
import Tabman
import Pageboy

class GiftSearchViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: GiftSearchViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: GiftSearchViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var sortImageView: UIImageView!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var icFilterImageView: UIImageView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var icTickCircleImageView: UIImageView!
    @IBOutlet weak var filterContainerView: UIView!


    // Variables
    var viewModel: GiftSearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.setCommonGradient()
        floatingView.setCommonGradient()
    }

    override func initView() {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: GiftTableViewCell.self)
        tableView.register(cellType: GiftSectionTitleTableViewCell.self)
        searchTF.returnKeyType = .search
        searchTF.becomeFirstResponder()
    }

    override func setImage() {
        icFilterImageView.image = .iconFilter
        icTickCircleImageView.image = .iconTickCircle
    }

    override func bindToView() {
        // search state
        viewModel.output.searchState.subscribe(onNext: { [weak self] searchState in
            guard let self = self else { return }
            if searchState == SearchState.initial {
                self.tableView.isHidden = true
                self.hideLoading()
            } else {
                self.tableView.isHidden = false
            }
            self.floatingView.isHidden = searchState == SearchState.initial
        }).disposed(by: disposeBag)

        // loading
        viewModel.output.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            tableView.reloadData()
        }).disposed(by: disposeBag)

        // Filter icon
        viewModel.output.filterModel
            .subscribe(onNext: { [weak self] filterModel in
            guard let self = self else { return }
            self.icTickCircleImageView.isHidden = filterModel == nil
        }).disposed(by: disposeBag)

        // sorting
        viewModel.output.sorting
            .subscribe(onNext: { [weak self] sorting in
            guard let self = self else { return }
            if (sorting == GiftSorting.requiredCoinAsc) {
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

    }

    override func bindToViewModel() {
        viewModel.output.searchText
            .bind(to: searchTF.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: -Action
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func filterAction(_ sender: Any) {
        self.navigator.show(segue: .giftFilter(filterModel: viewModel.output.filterModel.value, applyFilterAction: { filterModel in
            self.viewModel.onApplyFilterModelCallBack(filterModel: filterModel)
        }, isShowCates: true
            )) { vc in
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }

    }

    @IBAction func searchAnotherTextAction(_ sender: Any) {
        viewModel.searchTextSubj.accept("")
        viewModel.searchStateSubj.accept(.initial)
        searchTF.becomeFirstResponder()
    }
}

extension GiftSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        }
        return viewModel.getDisplayGifts().count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hasSearchData = viewModel.output.searchState.value == .searchResult
        if (section == 0) {
            if (hasSearchData) {
                return nil
            }
            let section = tableView.dequeueCell(ofType: GiftSearchEmptyTableViewCell.self)
            return section.contentView
        }
        let section = tableView.dequeueCell(ofType: GiftSectionTitleTableViewCell.self)
        section.setDataForCell(isShowSearchResult: hasSearchData, title: hasSearchData ? "\(viewModel.totalCount) kết quả" : "Gợi ý cho bạn")
        return section.contentView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }


    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: GiftTableViewCell.self, for: indexPath)
        let gift = viewModel.getDisplayGifts()[indexPath.row]
        cell.setDataForCell(data: gift)
        return cell
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gift = viewModel.getDisplayGifts()[indexPath.row]
        if let giftId = gift.giftInfor?.id {
            UtilHelper.openGiftDetailScreen(from: self, giftInfo: gift, giftId: "\(giftId)", isDiamond: gift.giftInfor?.isGiftDiamond ?? false)
        }
    }
}

extension GiftSearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.floatingView.isHidden = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.floatingView.isHidden = viewModel.output.searchState.value != SearchState.searchResult
    }
}

extension GiftSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.output.searchText.accept(textField.text?.trim())
        viewModel.input.onSearch.onNext(())
        return true
    }
}
