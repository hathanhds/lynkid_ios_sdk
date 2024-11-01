//
//  TransactionHistoryChildViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 31/05/2024.
//

import UIKit

class TransactionHistoryChildViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: TransactionHistoryChildModel) -> Self {
        let vc = UIStoryboard.transactionHistory.instantiateViewController(ofType: TransactionHistoryChildViewController.self)
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc as! Self
    }

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet var _tableEmptyView: UIView!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var exploreMessageLabel: UILabel!

    var viewModel: TransactionHistoryChildModel!

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exploreButton.setCommonGradient()
    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }

    override func initView() {
        _tableView.register(cellType: TransactionItemTableViewCell.self)
        _tableView.register(cellType: TransactionSectionTableViewCell.self)
        _tableView.addPullToRefresh(target: self, action: #selector(self.onRefresh))

        let currentTab = viewModel.currentTab
        if (currentTab == .all || currentTab == .used) {
            exploreButton.setTitle("Khám phá ngay", for: .normal)
            exploreMessageLabel.text = "Bạn chưa có giao dịch nào. Kiếm điểm và sử dụng điểm đổi vô vàn ưu đãi từ LynkiD bạn nhé!"
        } else {
            exploreButton.setTitle("Mẹo tích điểm", for: .normal)
            exploreMessageLabel.text = "Bạn chưa có giao dịch tích điểm nào.Tìm hiểu mẹo tích điểm và kiếm điểm ngay bạn nhé!"
        }
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
            self.reloadTableView()
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

    func reloadTableView() {
        if UserDefaults.standard.data(forKey: Constant.kAllMerchant) != nil {
            _tableView.reloadData()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.reloadTableView()
            }
        }
    }

    // MARK: -Action
    @IBAction func exploreAction(_ sender: Any) {
        let currentTab = viewModel.currentTab
        if (currentTab == .all || currentTab == .used) {
            self.navigator.show(segue: .allGifts) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            UtilHelper.showInstallAppPopup(parentVC: self)
        }

    }

}

extension TransactionHistoryChildViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = viewModel.output.listGroupTransaction.value.count
        _tableView.backgroundView = (viewModel.output.isLoading.value == false
                && sectionCount == 0) ? _tableEmptyView: nil
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = viewModel.output.listGroupTransaction.value[section].transactions.count // Assume items is your data source array
        return itemCount
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueCell(ofType: TransactionSectionTableViewCell.self)
        let group = viewModel.output.listGroupTransaction.value[section]
        cell.titleLabel.text = group.dateString
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: TransactionItemTableViewCell.self, for: indexPath)
        let transaction = viewModel.output.listGroupTransaction.value[indexPath.section].transactions[indexPath.row]
        cell.selectionStyle = .none
        cell.setDataForCell(item: transaction)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLoadMore = viewModel.output.isLoadMore.value
        let currentGifts = viewModel.output.listTransaction.value

        let groups = viewModel.output.listGroupTransaction.value
        if indexPath.section == groups.count - 1,
            currentGifts.count < viewModel.totalCount,
            !isLoadMore {
            viewModel.onLoadMore()
        }
    }

    // MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = viewModel.output.listGroupTransaction.value[indexPath.section].transactions[indexPath.row]
        self.navigator.show(segue: .transactionDetail(tokenTransID: transaction.tokenTransID)) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
