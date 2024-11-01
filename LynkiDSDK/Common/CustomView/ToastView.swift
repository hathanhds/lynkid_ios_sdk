//
//  ToastView.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/05/2024.
//

import UIKit

enum ToastType {
    case success, error, warning

    var icon: UIImage? {
        switch self {
        case .success:
            return .icGiftCheckCircleWhite
        case .error:
            return .iconWarning
        case .warning:
            return .iconWarning
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .success:
            return .c34C759
        case .error:
            return .red
        case .warning:
            return .cFFAD33
        }
    }
}

class ToastView: UIView {

    private enum ToastState {
        case showing, hidden, gone
    }

    private class func topWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window
            }
        }
        return nil
    }

    private let backgroundView: UIView = {
        let v = UIView()
        v.cornerRadius = 8
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()

    private var state = ToastState.hidden {
        didSet {
            if self.state != oldValue {
                self.forceUpdates()
            }
        }
    }

    private let minimumHeight: CGFloat = 48
    private var minimumHeightConstraint: NSLayoutConstraint!
    private var showingConstraint: NSLayoutConstraint?
    private var hiddenConstraint: NSLayoutConstraint?
    private var commonConstraints = [NSLayoutConstraint]()
    var navBarHeight: CGFloat = 0

    required init(type: ToastType, message: String?) {
        super.init(frame: CGRect.zero)
        self.addGestures()
        messageLabel.text = message
        iconImageView.image = type.icon
        backgroundView.backgroundColor = type.backgroundColor
        layer.cornerRadius = 8.0
        setup()
    }

    private func forceUpdates() {
        guard let superview = self.superview,
            let showingConstraint = self.showingConstraint,
            let hiddenConstraint = self.hiddenConstraint
            else { return }
        switch self.state {
        case .hidden:
            superview.removeConstraint(showingConstraint)
            superview.addConstraint(hiddenConstraint)
        case .showing:
            superview.removeConstraint(hiddenConstraint)
            superview.addConstraint(showingConstraint)
        case .gone:
            superview.removeConstraint(hiddenConstraint)
            superview.removeConstraint(showingConstraint)
            superview.removeConstraints(commonConstraints)
        }
        self.setNeedsLayout()
        self.setNeedsUpdateConstraints()
        superview.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
    }

    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        self.addGestureRecognizer(tap)

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.dismiss))
        swipe.direction = .up
        self.addGestureRecognizer(swipe)
    }

    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        addSubview(iconImageView)
        addSubview(messageLabel)
        messageLabel.sizeToFit()

        let padding = 16.0

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: padding),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),

            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            ])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = self.superview, self.state != .gone else { return }
        self.commonConstraints = self.constraintsWithAttributes([.width], .equal, to: superview)
        superview.addConstraints(commonConstraints)

        let constant = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 8 + self.navBarHeight
        self.showingConstraint = self.constraintWithAttribute(.top, .equal, to: .top, of: superview, constant: constant)
        let yOffset: CGFloat = -7.0 // Offset the bottom constraint to make room for the shadow to animate off screen.
        self.hiddenConstraint = self.constraintWithAttribute(.bottom, .equal, to: .top, of: superview, constant: yOffset)
    }

    func show(_ view: UIView? = nil, duration: TimeInterval? = 3) {
        guard let view = view ?? ToastView.topWindow() else { return }
        view.addSubview(self)
        self.forceUpdates()
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            self.state = .showing
        }, completion: { finished in
                guard let duration = duration else { return }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(1000.0 * duration))) {
                    self.dismiss()
                }
            })
    }

//    func show(_ view: UIView? = nil, duration: TimeInterval? = 1.0) {
//        guard let view = view ?? ToastView.topWindow() else { return }
//        view.addSubview(self)
//        self.forceUpdates()
//        UIView.animate(withDuration: duration ?? 5.0, delay: 1.0, options: .curveEaseInOut, animations: {
//            self.state = .showing
//        }, completion: { (isCompleted) in
//                self.alpha = 0.0
//                guard let duration = duration else { return }
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(1000.0 * duration))) {
//                    self.dismiss()
//                }
//            })
//    }


    @objc func dismiss(animated: Bool = true) {
        guard state == .showing else { return }
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
                self.state = .hidden
            }, completion: { finished in
                    self.state = .gone
                    self.removeFromSuperview()
                })
        } else {
            self.state = .gone
            self.removeFromSuperview()
        }
    }

}

extension UIView {

    fileprivate func constraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to constant: CGFloat, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
    }

    fileprivate func constraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to otherAttribute: NSLayoutConstraint.Attribute, of item: AnyObject? = nil, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: item ?? self, attribute: otherAttribute, multiplier: multiplier, constant: constant)
    }

    fileprivate func constraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to item: AnyObject, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: item, attribute: attribute, multiplier: multiplier, constant: constant)
    }

    fileprivate func constraintsWithAttributes(_ attributes: [NSLayoutConstraint.Attribute], _ relation: NSLayoutConstraint.Relation, to item: AnyObject, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> [NSLayoutConstraint] {
        return attributes.map { self.constraintWithAttribute($0, relation, to: item, multiplier: multiplier, constant: constant) }
    }

}
