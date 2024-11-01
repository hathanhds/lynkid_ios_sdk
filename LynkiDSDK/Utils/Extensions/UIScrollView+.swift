//
//  UIScrollView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/02/2024.
//

import UIKit

extension UIScrollView {

    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    func scrollToBottom(animated: Bool = true) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }

    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }

    func addPullToRefresh(target: Any?, action: Selector, topOffset: Double? = nil, tintColor: UIColor? = .mainColor) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        if let top = topOffset {
            refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x,
                y: top,
                width: refreshControl.bounds.size.width,
                height: refreshControl.bounds.size.height)
        }

        self.addSubview(refreshControl)
    }

    func removePullToRefresh() {
        for view in self.subviews {
            if let view = view as? UIRefreshControl {
                view.removeFromSuperview()
                return
            }
        }
    }

    func endRefreshing() {
        for view in self.subviews {
            if let view = view as? UIRefreshControl {
                view.endRefreshing()
                return
            }
        }
    }

    var refreshControl: UIRefreshControl? {
        return self.subviews.first(where: { $0 is UIRefreshControl }) as? UIRefreshControl
    }
}
