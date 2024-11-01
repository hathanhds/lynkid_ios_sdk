//
//  ListGiftByGroup.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 01/03/2024.
//

import Foundation
import UIKit
import RxSwift


class ListGiftByGroupViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = ListGiftByGroupViewModel

    static func create(with navigator: Navigator, viewModel: ListGiftByGroupViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: ListGiftByGroupViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    @IBOutlet weak var tableView: UITableView!


    var viewModel: ListGiftByGroupViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadSubj.onNext(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }

    override func initView() {
        self.addBackButton()
        self.addRightBarButtonWith(image: .iconSearchWhite, selector: #selector(self.onSearch))
        self.title = viewModel.groupName ?? "Danh sách ưu đãi"
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

        // init nib
        tableView.register(cellType: GiftTableViewCell.self)

    }

    @objc func onSearch() {
        self.openSearchScreen()
    }

    override func bindToView() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self.tableView.endRefreshing()
        }.disposed(by: disposeBag)

        // Loading
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

    }
}

extension ListGiftByGroupViewController: UITableViewDataSource, UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.gifts.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: GiftTableViewCell.self, for: indexPath)
        let gift = viewModel.output.gifts.value[indexPath.row]
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

    // MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let giftInfo = viewModel.output.gifts.value[indexPath.row]
        if let giftId = giftInfo.giftInfor?.id {
            UtilHelper.openGiftDetailScreen(from: self, giftInfo: giftInfo, giftId: "\(giftId)", isDiamond: giftInfo.giftInfor?.isGiftDiamond ?? false)
        }
    }
}
