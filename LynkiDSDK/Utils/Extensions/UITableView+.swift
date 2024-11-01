//
//  UITableView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import UIKit

extension UITableView {

    func dequeueCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func dequeueCell<T: UITableViewCell>(ofType type: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }

    public func register<T: UITableViewCell>(cellType: T.Type) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: UIStoryboard.bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    public func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0) }
    }
}

extension UITableView {
    func addBottomLoadingView(withHeight height: CGFloat = 40) {
        let loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.startAnimating()

        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: height))
        v.backgroundColor = .clear
        v.addSubview(loadingView)
        loadingView.constraint(to: v)

        self.tableFooterView = v
    }

    func removeBottomLoadingView() {
        self.tableFooterView = nil
    }
}
