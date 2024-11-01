//
//  CustomPageControl.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 29/01/2024.
//

import Foundation
import UIKit

class CustomPageControl: UIView {
    var numberOfPage: Int
    var currentpage: Int = 0 { didSet { reloadView() } }
    var currentIndicatorColor: UIColor = .black
    var indicatorColor: UIColor = UIColor(white: 0.9, alpha: 1)
    var circleIndicator: Bool = false
    private var dotView = [UIView]()
    private let spacing: CGFloat = 6
    private lazy var extraWidth: CGFloat = circleIndicator ? 6 : 4

    init(numberOfPages: Int, currentPage: Int, isCircular: Bool) {
        self.numberOfPage = numberOfPages
        self.currentpage = currentPage
        self.circleIndicator = isCircular
        super.init(frame: .zero)
        configView()
    }
    required init?(coder: NSCoder) { fatalError("not implemented") }

    private func configView() {
        backgroundColor = .clear
        (0..<numberOfPage).forEach { _ in
            let view = UIView()
            addSubview(view)
            dotView.append(view)
        }
    }

    private func reloadView() {
        dotView.forEach { $0.backgroundColor = indicatorColor }
        dotView[currentpage].backgroundColor = currentIndicatorColor
        UIView.animate(withDuration: 0.2) {
            self.dotView[self.currentpage].frame.origin.x = self.dotView[self.currentpage].frame.origin.x - self.extraWidth
            self.dotView[self.currentpage].frame.size.width = self.dotView[self.currentpage].frame.size.width + (self.extraWidth * 2)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for (i, view) in dotView.enumerated() {
            view.clipsToBounds = true
            view.layer.cornerRadius = bounds.height / 2
            let width: CGFloat = circleIndicator ? self.bounds.height : CGFloat(self.bounds.width / CGFloat(self.numberOfPage) - self.spacing) - self.extraWidth
            UIView.animate(withDuration: 0.2) {
                view.frame = CGRect(x: ((self.bounds.width / CGFloat(self.numberOfPage)) * CGFloat(i)) + self.spacing, y: 0, width: width, height: self.bounds.height)
            }
        }
        reloadView()
    }
}
