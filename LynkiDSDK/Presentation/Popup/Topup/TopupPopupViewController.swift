//
//  TopupPopupViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/08/2024.
//

import UIKit

class TopupPopupViewController: BaseViewController {
    var viewModel: TopupPopupViewModel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    class func create(with navigator: Navigator, viewModel: TopupPopupViewModel) -> TopupPopupViewController {
        let vc = UIStoryboard.popup.instantiateViewController(ofType: TopupPopupViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        titleLabel.text = viewModel.type.rawValue
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension TopupPopupViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Datasouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: TopupPopupTableViewCell.self, for: indexPath)
        cell.setDataForCell(data: viewModel.list[indexPath.row], isLastItem: indexPath.row == viewModel.list.count - 1)
        return cell
    }

    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        viewModel.onSelected(viewModel.list[indexPath.row])
    }
}

