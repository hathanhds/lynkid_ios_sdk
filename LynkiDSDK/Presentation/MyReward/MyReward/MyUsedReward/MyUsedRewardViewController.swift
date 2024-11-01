//
//  MyUsedRewardViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 05/04/2024.
//

import UIKit

class MyUsedRewardViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: MyUsedRewardViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: MyUsedRewardViewController.self)
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc as! Self
    }

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet var _tableEmptyView: UIView!
    @IBOutlet weak var _exploreNowButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var icFilterImageView: UIImageView!

    var viewModel: MyUsedRewardViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let v = self._tableView.refreshControl, v.isRefreshing {
            v.endRefreshing()
            v.beginRefreshing()
            self._tableView.contentOffset = CGPoint(x: 0, y: -(v.bounds.height))
        }
    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }

    override func initView() {
        _tableView.register(cellType: MyRewardTableViewCell.self)
        _tableView.addPullToRefresh(target: self, action: #selector(self.onRefresh))
        _exploreNowButton.setCommonGradient()
    }

    override func bindToView() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self._tableView.endRefreshing()
            self._tableView.reloadData()
        }.disposed(by: disposeBag)

        // Loading
        viewModel.output.isLoadingListReward.subscribe (onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            self._tableView.reloadData()
        })
            .disposed(by: disposeBag)

        // LoadMore
        viewModel.output.isLoadMore
            .subscribe(onNext: { [weak self] isLoadMore in
            guard let self = self else { return }
            if isLoadMore {
                self._tableView.addBottomLoadingView()
            } else {
                self._tableView.removeBottomLoadingView()
            }
        }).disposed(by: disposeBag)

        // Filter icon
        viewModel.output.filterModel
            .subscribe(onNext: { [weak self] filterModel in
            guard let self = self else { return }
            self.icFilterImageView.isHidden = filterModel == nil
        }).disposed(by: disposeBag)

    }



    @IBAction func onTapExploreNow(_ sender: Any) {

    }

    @IBAction func onFilterAction(_ sender: Any) {
        self.navigator.show(segue: .myrewardFilter(myRewardType: MyRewardType.myUsedReward, filterModel: viewModel.output.filterModel.value, applyFilterAction: { filterModel in
            self.viewModel.onApplyFilterModelCallBack(filterModel: filterModel)
        })) { vc in
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }

    @IBAction func openGiftListScreen(_ sender: Any) {
        self.navigator.show(segue: .allGifts) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension MyUsedRewardViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = viewModel.output.listReward.value.count // Assume items is your data source array
        _tableView.backgroundView = (viewModel.output.isLoadingListReward.value == false && itemCount == 0) ? _tableEmptyView: nil
        return itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MyRewardTableViewCell.self, for: indexPath)
        let isLastItem = indexPath.row == viewModel.output.listReward.value.count - 1
        let gift = viewModel.output.listReward.value[indexPath.row]
        cell.selectionStyle = .none
        cell.setDataForCell(data: gift, isUsedGift: true, isLastItem: isLastItem)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLoadMore = viewModel.output.isLoadMore.value
        let currentGifts = viewModel.output.listReward.value
        if indexPath.row == currentGifts.count - 1,
            currentGifts.count < viewModel.totalCount,
            !isLoadMore {
            viewModel.onLoadMore()
        }
    }


    // MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gift = viewModel.output.listReward.value[indexPath.row]
        // Nếu là quà trải nghiệm hiển thị popup cài app
        // Quà trải nghiệm là quà đổi trên luồng quà diamond
        if let isExperienceGift = gift.giftTransaction?.isExperienceGift, isExperienceGift {
            self.navigator.show(segue: .installAppPopup(isVpbankDiamond: true)) { [weak self] vc in
                guard let self = self else { return }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        } else {
            if let _ = gift.eGift {
                self.navigator.show(segue: .egiftRewardDetail(giftInfo: gift, giftTransactionCode: gift.giftTransaction?.code ?? "")) { [weak self] vc in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self.navigator.show(segue: .physicalRewardDetail(giftInfo: gift, giftTransactionCode: gift.giftTransaction?.code ?? "")) { [weak self] vc in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
