//
//  ShippingLocationViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/06/2024.
//

import Foundation
import UIKit
import RxSwift

class DiamondShippingLocationViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: DiamondShippingLocationViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: DiamondShippingLocationViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!

    // Variables
    var viewModel: DiamondShippingLocationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadSubj.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.setDiamondBackgroundGradient()
    }

    override func initView() {
        self.title = viewModel.data.title
        self.addDiamondBackButton()
        searchTF.keyboardAppearance = .dark
        tableView.backgroundColor = .clear
    }

    override func bindToView() {
        searchTF.rx.controlEvent([.editingChanged])
            .debounce(.microseconds(1000), scheduler: MainScheduler.instance)
            .asObservable().subscribe({ [weak self] _ in
            guard let self = self else { return }
            viewModel.onSearch(searchText: searchTF.text)
        }).disposed(by: disposeBag)

        viewModel.output.displayLocations.subscribe(onNext: { [weak self] locations in
            guard let self = self else { return }
            tableView.backgroundView = locations.isEmpty ? emptyView : nil
            tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension DiamondShippingLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.displayLocations.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: ShipLocationTableViewCell.self, for: indexPath)
        let list = viewModel.output.displayLocations.value
        cell.setDataForCell(location: list[indexPath.row], isLastItem: indexPath.row == list.count - 1)
        return cell

    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = viewModel.output.displayLocations.value[indexPath.row]
        viewModel.data.callBack(location)
        self.pop()
    }

}
