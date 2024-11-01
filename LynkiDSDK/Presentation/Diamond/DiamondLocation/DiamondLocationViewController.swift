//
//  GiftLocationViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/05/2024.
//

import UIKit
import RxSwift

class DiamondLocationViewController: BaseViewController, ViewControllerType {

    static func create(with navigator: Navigator, viewModel: DiamondLocationViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: DiamondLocationViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchImageView: UIImageView!

    // Variables
    var viewModel: DiamondLocationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoadSubj.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setDiamondBackgroundGradient()
    }

    override func initView() {
        self.title = "Địa điểm áp dụng"
        self.addDiamondBackButton()
        tableView.register(cellType: GiftLocationTableViewCell.self)
        tableView.addPullToRefresh(target: self, action: #selector(self.onRefresh), tintColor: .white)
        tableView.backgroundColor = .clear
        searchTF.keyboardAppearance = .dark
        searchTF.placeHolderColor = .cA7A7B3
    }

    override func setImage() {
        searchImageView.image = .iconSearchGray
    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }
    override func bindToViewModel() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self.tableView.endRefreshing()
        }.disposed(by: disposeBag)

        // Loading
        viewModel.output.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showDiamondLoading()
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

    override func bindToView() {
        searchTF.rx.controlEvent([.editingChanged])
            .debounce(.microseconds(1000), scheduler: MainScheduler.instance)
            .asObservable().subscribe({ [weak self] _ in
            guard let self = self else { return }
            viewModel.input.onSearch.onNext(searchTF.text?.trim() ?? "")
        }).disposed(by: disposeBag)
    }

}

extension DiamondLocationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.locations.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: GiftLocationTableViewCell.self, for: indexPath)
        let list = viewModel.output.locations.value
        cell.setDataForCell(data: list[indexPath.row], isLastItem: indexPath.row == list.count - 1, isDiamond: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.locations.value[indexPath.count]
        UtilHelper.openGoogleMap(navigator: self.navigator, parentVC: self, address: data.address ?? "", isDiamond: true)
    }

}
