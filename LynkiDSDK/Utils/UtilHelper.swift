//
//  UtilHelper.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import UIKit
import CoreImage
import RxSwift

class UtilHelper {

    static let bundle = Bundle(for: LaunchScreenViewController.self)

    static func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                print("open error")
            }
        }
    }

    static func openPhoneCall(number: String) {
        let _number = number.replacingOccurrences(of: " ", with: "")
        openURL(urlString: "tel://\(_number)")
    }

    static func openEmail(email: String) {
        openURL(urlString: "mailto://\(email)")
    }

    static func callLynkiDHotLine() {
        openPhoneCall(number: Constant.lynkiDHotLine)
    }

    static func callVpBankHotLine() {
        openPhoneCall(number: Constant.vpbankHotline)
    }

    static func callVpBankDiamondHotLine() {
        openPhoneCall(number: Constant.vpbankDiamondHotline)
    }

    static func openLynkiDAPP() {
        if let url = URL(string: "linkid_uat://") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                openURL(urlString: "https://apps.apple.com/vn/app/lynkid/id1523437266?l=vi")
            }
        } else {
            openURL(urlString: "https://apps.apple.com/vn/app/lynkid/id1523437266?l=vi")
        }
    }


    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    static func copyToClipboard(text: String, completion: (() -> Void)? = nil) {
        UIPasteboard.general.string = text
        completion?()
    }
}

extension UtilHelper {
    static func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

extension UtilHelper {
    static func openGoogleMap(navigator: Navigator, parentVC: UIViewController, address: String, isDiamond: Bool = false) {
        UtilHelper.copyToClipboard(text: address)
        navigator.show(segue: .popup(
            dismissable: true,
            isDiamond: isDiamond,
            type: .twoOption,
            title: "Truy cập Google Map",
            message: "Coppy địa chỉ thành công. Bạn có muốn mở ứng dụng Google Maps để xem địa chỉ không?",
            image: .imgGiftMap!,
            confirmnButton: (title: "Đồng ý", action: {
                UtilHelper.openURL(urlString: "https://www.google.com/maps/dir/?api=1&destination=\(address)")
            }),
            cancelButton: (title: "Huỷ", action: nil)
            )) { vc in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            parentVC.navigationController?.present(vc, animated: true)
        }
    }

    static func openGiftDetailScreen(from viewController: BaseViewController, giftInfo: GiftInfoItem? = nil, giftId: String, isDiamond: Bool = false) {
        if (isDiamond) {
            viewController.navigator.show(segue: .giftDetailDiamond(giftInfo: giftInfo, giftId: giftId)) { vc in
                viewController.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            viewController.navigator.show(segue: .giftDetail(giftInfo: giftInfo, giftId: giftId)) { vc in
                viewController.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension UtilHelper {

    static func showAPIErrorPopUp(parentVC: BaseViewController,
        title: String? = nil,
        message: String? = nil,
        isDiamond: Bool = false) {
        parentVC.navigator.show(segue: .popup(
            dismissable: true,
            isDiamond: isDiamond,
            type: .oneOption,
            title: title ?? "Có lỗi xảy ra",
            message: message ?? "Có lỗi trong quá trình kết nối bạn vui lòng thực hiện lại nhé.",
            image: .imageMascotError!,
            confirmnButton: (title: "Đồng ý", action: nil)
            )) { vc in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            parentVC.present(vc, animated: true)
        }
    }

    static func showInstallAppPopup(parentVC: BaseViewController, isVpbankDiamond: Bool = false) {
        parentVC.navigator.show(segue: .installAppPopup(isVpbankDiamond: isVpbankDiamond)) { vc in
            vc.modalPresentationStyle = .fullScreen
            parentVC.present(vc, animated: true)
        }
    }

    static func getTopViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            return getTopViewController(from: rootController)
        }
        return nil
    }

    static func getTopViewController(from viewController: UIViewController) -> UIViewController? {
        if let presentedController = viewController.presentedViewController {
            // If the current view controller has a presented view controller, recurse into it
            return getTopViewController(from: presentedController)
        } else if let navigationController = viewController as? UINavigationController {
            // If it's a navigation controller, check its visible view controller
            return getTopViewController(from: navigationController.visibleViewController ?? navigationController)
        } else if let tabController = viewController as? UITabBarController {
            // If it's a tab bar controller, check the selected view controller
            return getTopViewController(from: tabController.selectedViewController ?? tabController)
        } else {
            // Otherwise, it's the topmost view controller
            return viewController
        }
    }

    static func showAccessTokenExpired() {
        if let currentVC = getTopViewController() {
            DispatchQueue.main.async {
                Navigator().show(segue: .popup(dismissable: false,
                    isDiamond: false, type: .twoOption,
                    title: "Phiên đăng nhập hết hạn",
                    message: "Vui lòng đăng nhập lại để tiếp tục trải nghiệm nhé.",
                    image: .imageMascotError!,
                    confirmnButton: (title: "Đăng nhập", action: {
                        openLaunchScreen()
                    }),
                    cancelButton: (title: "Đóng", action: nil))) { vc in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    currentVC.present(vc, animated: true)
                }
            }
        }
    }

    static func openLaunchScreen() {
        DispatchQueue.main.async {
            (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            if let window = UIApplication.shared.windows.first {
                let vc = LaunchScreenViewController.create(with: Navigator(), viewModel: LaunchScreenViewModel(authenRepository: AuthRepositoryImp()))

                window.rootViewController = UINavigationController(rootViewController: vc)
                window.makeKeyAndVisible()
            }
        }
    }
}

extension UtilHelper {
    static func formatDate(date: String?, toFormatter: DateFormatterType = .HHmmddMMyyyy) -> String {
        if let date = date {
            let dateFormatter1 = Date.init(fromString: date, formatter: .yyyyMMddThhmmss)?.toLocalTime().toString(formatter: toFormatter) ?? ""
            let dateFormatter2 = Date.init(fromString: date, formatter: .yyyyMMddThhmmssSSZ)?.toLocalTime().toString(formatter: toFormatter) ?? ""
            if (!dateFormatter1.isEmpty) {
                return dateFormatter1
            } else {
                return dateFormatter2
            }
        }
        return ""
    }
}

extension UtilHelper {
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")

            if let qrCodeImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQRCodeImage = qrCodeImage.transformed(by: transform)

                if let cgImage = CIContext().createCGImage(scaledQRCodeImage, from: scaledQRCodeImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }

        return nil
    }
}

extension UtilHelper {
    static func hanldeAPIError(error: Error, resultSubj: PublishSubject<Result<AnyObject, APIErrorResponseModel>>) {
        if let error = error as? APIErrorResponseModel {
            resultSubj.onNext(.failure(error))
        } else {
            resultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
        }
    }
}

extension UtilHelper {
    static func getTopupBrandType(phoneNumber: String) -> TopupBrandType? {
        let prefixNumber = phoneNumber.prefix(3)
        switch (prefixNumber) {
        case "086",
             "096",
             "097",
             "098",
             "032",
             "033",
             "034",
             "035",
             "036",
             "037",
             "038",
             "039":
            return TopupBrandType.viettel
        case "088",
             "091",
             "094",
             "083",
             "084",
             "085",
             "081",
             "082":
            return TopupBrandType.vinaphone
        case "089",
             "090",
             "093",
             "070",
             "079",
             "077",
             "076",
             "078":
            return TopupBrandType.mobifone
        case "092",
             "056",
             "058":
            return TopupBrandType.vnmobile
        case "099",
             "059":
            return TopupBrandType.beeline
        case "055":
            return TopupBrandType.reddi

        default:
            return nil;
        }
    }

    static func getTopupBrandType(brandName: String) -> TopupBrandType? {
        let _brandName = brandName.lowercased()
        if (_brandName.contains("viettel")) {
            return TopupBrandType.viettel
        }
        if (_brandName.contains("vinaphone")) {
            return TopupBrandType.vinaphone
        }
        if (_brandName.contains("mobifone")) {
            return TopupBrandType.mobifone
        }
        if (_brandName.contains("vietnamobile")) {
            return TopupBrandType.vnmobile
        }
        if (_brandName.contains("beeline") || _brandName.contains("gmobile")) {
            return TopupBrandType.beeline;
        }
        if (_brandName.contains("reddi")) {
            return TopupBrandType.reddi;
        }

        return nil
    }
}

extension UtilHelper {

    static func validatePhone(_ phone: String?) -> String? {
        if (phone ?? "").trim().isEmpty {
            return "Số điện thoại không được bỏ trống"
        } else if (!isValidPhoneNumber(phone ?? "")) {
            return "Số điện thoại không đúng định dạng"
        } else {
            return nil
        }
    }

    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^((^(\\+84|\\+840|840|0084|84|0){1})(3|5|7|8|9))+([0-9]{8})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}
