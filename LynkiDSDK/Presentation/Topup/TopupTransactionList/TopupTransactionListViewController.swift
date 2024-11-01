//
//  TopupTransactionListViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/08/2024.
//

import UIKit

class TopupTransactionListViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: TopupTransactionListViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupTransactionListViewController.self)
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc as! Self
    }

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet var _tableEmptyView: UIView!
    @IBOutlet weak var _exploreNowButton: UIButton!

    var viewModel: TopupTransactionListViewModel!

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
        viewModel.output.isLoading.subscribe (onNext: { [weak self] isLoading in
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
    }

    @IBAction func openListGiftScreen(_ sender: Any) {
        self.navigator.show(segue: .topup(topupType: .topupData)) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension TopupTransactionListViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = viewModel.output.transactions.value.count // Assume items is your data source array
        _tableView.backgroundView = (viewModel.output.isLoading.value == false && viewModel.output.isRefreshing.value == false && itemCount == 0) ? _tableEmptyView: nil
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
        let isLastItem = indexPath.row == viewModel.output.transactions.value.count - 1
        let transaction = viewModel.output.transactions.value[indexPath.row]
        cell.selectionStyle = .none
        cell.setDataForTopupTransaction(data: transaction, isLastItem: isLastItem)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLoadMore = viewModel.output.isLoadMore.value
        let currentGifts = viewModel.output.transactions.value
        if indexPath.row == currentGifts.count - 1,
            currentGifts.count < viewModel.totalCount,
            !isLoadMore {
            viewModel.onLoadMore()
        }
    }


    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trasaction = viewModel.output.transactions.value[indexPath.row]
        self.navigator.show(segue: .egiftRewardDetail(giftInfo: GiftInfoItem(), giftTransactionCode: trasaction.code ?? "")) { [weak self]vc in
            guard let self = self else { return }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

