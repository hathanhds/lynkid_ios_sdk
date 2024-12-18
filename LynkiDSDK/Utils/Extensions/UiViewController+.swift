//
//  UiViewController+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//

import UIKit
import iCarousel
import EasyTipView

extension UIViewController {

    func hideNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIViewController {

    func setupTransparentNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        // Set navigation bar's background to a clear image
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true

        // Keep the title text
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Or any color you want


        // For iOS 15 and later, you might need to configure the appearance as well
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            // Set the title text attributes for a white color in the appearance object
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance // For iPhone small navigation bar in landscape.
            navigationBar.scrollEdgeAppearance = appearance // For large title navigation bar.
        }
    }

    func setupGradientViewBehindBars() {
        var gradientView: UIView?
        var gradientImageView: UIImageView?

        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let tabmanBarHeight: CGFloat = 48 // Adjust if you have a custom size for Tabman bar
        if(gradientView != nil || gradientImageView != nil) {
            gradientImageView?.removeFromSuperview()
            gradientView?.removeFromSuperview()
        }

        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: UtilHelper.statusBarHeight + navigationBarHeight + tabmanBarHeight))
        gradientImageView = UIImageView(frame: gradientView!.bounds)
        gradientImageView?.image = .bgTabHeader
        gradientView?.addSubview(gradientImageView!)
        // Place the gradient view behind all other views
        view.addSubview(gradientView!)
        view.sendSubviewToBack(gradientView!)
    }
}

extension UIViewController {

    func showLoading(color: UIColor = .mainColor!) {
        LoadingManager.shared.showLoading(in: self.view, color: color)
        self.view.endEditing(true)
    }

    func showDiamondLoading() {
        showLoading(color: .white)
    }

    func hideLoading() {
        LoadingManager.shared.hideLoading()
    }
}

extension UIViewController {

    @discardableResult
    func showToast(ofType type: ToastType, view: UIView? = nil, withMessage message: String?, dismissOtherToasts: Bool = false, topOffset: CGFloat? = nil, afterSeconds seconds: TimeInterval? = nil) -> ToastView {
        let toast = ToastView(type: type, message: message)
        if let topOffset = topOffset {
            toast.navBarHeight = topOffset
        } else if let navBar = (self as? UINavigationController)?.navigationBar ?? self.navigationController?.navigationBar, !navBar.isHidden {
            toast.navBarHeight = navBar.frame.height
        }
        if let seconds = seconds, seconds > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                guard let self = self else { return }
                if dismissOtherToasts {
                    self.dismissAllToasts(animated: false)
                }
                toast.show(view)
            }
        } else {
            if dismissOtherToasts {
                self.dismissAllToasts(animated: false)
            }
            toast.show(view)
        }
        return toast
    }

    func dismissAllToasts(animated: Bool = true) {
        self.view.subviews.forEach { v in
            if let v = v as? ToastView {
                v.dismiss(animated: animated)
            }
        }
    }
}

extension UIViewController {
    private func dismissAllPresentedViewControllers(animated: Bool, completion: (() -> Void)? = nil) {
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: animated) {
                self.dismissAllPresentedViewControllers(animated: animated, completion: completion)
            }
        } else {
            completion?()
        }
    }

    func dimissAllViewControllers() {
        if #available(iOS 13.0, *) {
            if let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootViewController.dismissAllPresentedViewControllers(animated: true)
            }
        } else {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                rootViewController.dismissAllPresentedViewControllers(animated: true)
            }
        }
    }
}

extension UIViewController {
    func setUpEasyView(tipView: inout EasyTipView) {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dimissTipView))
//        self.view.addGestureRecognizer(gesture)

        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = .systemFont(ofSize: 14)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = .c242424!
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        tipView = EasyTipView(text: "Ưu đãi có giá trị sử dụng đến 23:59 căn cứ theo giờ Việt Nam (GMT+7) và theo hệ thống LYNKID.", preferences: preferences)
    }

    @objc func dimissTipView(sender: UITapGestureRecognizer) {
        for v in self.view.subviews {
            if let v = v as? EasyTipView {
                v.dismiss()
                return
            }
        }
    }
}

extension UIViewController {

    func setUpCarousel(carousel: iCarousel, cornerRadius: CGFloat = 0) {
        carousel.type = .linear
        carousel.layer.masksToBounds = false
        carousel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        carousel.layer.cornerRadius = cornerRadius
        carousel.scrollToItem(at: 0, animated: true)
        carousel.isPagingEnabled = true
    }
}
