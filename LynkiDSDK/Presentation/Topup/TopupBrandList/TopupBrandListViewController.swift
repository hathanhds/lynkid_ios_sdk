//
//  TopupBrandListViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/08/2024.
//

import UIKit

class TopupBrandListViewController: BaseViewController {

    var viewModel: TopupBrandListViewModel!

    class func create(with navigator: Navigator, viewModel: TopupBrandListViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupBrandListViewController.self)
        vc.viewModel = viewModel
        return vc as! Self
    }

    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.addObserver(self, forKeyPath: "contentSize",
            options: .new, context: nil)
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
            self.tableViewHeightConstraint.constant = height
        }
    }

    override func initView() {
        headerView.layer.masksToBounds = false
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    // MARK: -Action
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension TopupBrandListViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: -Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.brandList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: TopupBrandTableViewCell.self)
        let brand = viewModel.brandList[indexPath.row].brandMapping
        let isSelectedBrand = viewModel.currentBrand?.brandId == brand?.brandId
        let isLastItem = indexPath.row == viewModel.brandList.count - 1
        if let brand = brand {
            cell.setDataForCell(brandInfo: brand, isSelected: isSelectedBrand, isLastItem: isLastItem)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: -Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let brand = viewModel.brandList[indexPath.row].brandMapping {
            viewModel.onSelectedBrand(brand)
        }
        self.dismiss(animated: true)
    }
}
