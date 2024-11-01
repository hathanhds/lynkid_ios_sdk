//
//  UIImage+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//

import UIKit
import SVGKit

extension UIImage {
    // MARK: - Placeholder
    static let imgLinkIDPlaceholder = UIImage(imageName: "img_placeholder")
    static let imgAvatarDefault = UIImage(imageName: "img_mascot_avatar_default")

    // MARK: - Common
    static let imgEmptyGift = UIImage(imageName: "img_empty_gifts")
    static let icBackBtn = UIImage(imageName: "ic_back")
    static let iconCheckCircleWhite = UIImage(imageName: "ic_check_circle_white")
    static let iconWarning = UIImage(imageName: "ic_warning")
    static let imageMascotError = UIImage(imageName: "img_mascot_error")
    static let imageMascotSmallDefault = UIImage(imageName: "img_mascot_small_default")
    static let imageMascotOTP = UIImage(imageName: "img_mascot_otp")
    static let iconAppPlaceholder = UIImage(imageName: "ic_app_placeholder")

    static let imageCopyWhite = UIImage(imageName: "ic_copy_white")
    static let imageCopyGray = UIImage(imageName: "ic_copy_gray")
    static let imageLocationWhite = UIImage(imageName: "ic_location_white")
    static let imageLocationGray = UIImage(imageName: "ic_location_gray")

    // MARK: - Gift
    static let icGiftSortAsc = UIImage(imageName: "ic_sort_asc")
    static let icGiftSortDesc = UIImage(imageName: "ic_sort_desc")
    static let icGiftCheckBoxOutline = UIImage(imageName: "ic_check_box_outline")
    static let icGiftCheckedBox = UIImage(imageName: "ic_checked_box")
    static let icSearchGift = UIImage(imageName: "ic_search")
    static let imgGiftMap = UIImage(imageName: "img_map")
    static let icGiftCheckCircleWhite = UIImage(imageName: "ic_check_circle_white")
    static let iconArrowToSwipe = UIImage(imageName: "ic_arrow_to_swipe")

    // MARK: Auth
    static let imageMerchantDefault = UIImage(imageName: "img_merchant_default")

    // MARK: - Diamond
    static let icBackDiamondBtn = UIImage(imageName: "ic_back_diamond")
    static let icSearchDiamondBtn = UIImage(imageName: "ic_search_diamond")
    static let icDiamondOptionSelectedBtn = UIImage(imageName: "ic_diamond_option_selected")
    static let icDiamondOptionUnselectedBtn = UIImage(imageName: "ic_diamond_option_unselected")
    static let imageBgHeaderDiamond = UIImage(imageName: "bg_header_diamond")
    
    // MARK: - Mascot
    static let imageIntsallAppDiamond = UIImage(imageName: "img_mastcot_install_app_diamond")
    static let imageIntsallAppNormal = UIImage(imageName: "img_mascot_iphone")

}

extension UIImage {
    // MARK: -Tabbar
    static let iconTabHomeActive = SVGKit.loadImage(with: "ic_tab_home_active")
    static let iconTabHomeInactive = SVGKit.loadImage(with: "ic_tab_home_inactive")
    static let iconTabRewardActive = SVGKit.loadImage(with: "ic_tab_reward_active")
    static let iconTabRewardInactive = SVGKit.loadImage(with: "ic_tab_reward_inactive")
    static let iconTabTransactionActive = SVGKit.loadImage(with: "ic_tab_transaction_active")
    static let iconTabTransactionInactive = SVGKit.loadImage(with: "ic_tab_transaction_inactive")
    static let iconTabAccountInactive = SVGKit.loadImage(with: "ic_tab_account_inactive")
    static let iconTabAccountActive = SVGKit.loadImage(with: "ic_tab_account_active")

    // MARK: -Common
    static let iconClose = SVGKit.loadImage(with: "ic_close")
    static let iconCloseYellow = SVGKit.loadImage(with: "ic_close", fillColor: .diamondColor)
    static let iconCloseGray = SVGKit.loadImage(with: "ic_close", fillColor: .c242424)
    static let bgHeader = SVGKit.loadImage(with: "bg_header")
    static let iconSearchWhite = SVGKit.loadImage(with: "ic_search")
    static let iconSearchBlack = SVGKit.loadImage(with: "ic_search", fillColor: .black)
    static let iconSearchGray = SVGKit.loadImage(with: "ic_search", fillColor: .cA7A7B3)
    static let iconAvatarDefault = SVGKit.loadImage(with: "ic_avatar_default")
    static let iconLogoDefault = SVGKit.loadImage(with: "ic_logo_default")
    static let iconPhoneSupport = SVGKit.loadImage(with: "ic_phone_support")
    static let iconBack = SVGKit.loadImage(with: "ic_back")
    static let iconBackYellow = SVGKit.loadImage(with: "ic_back", fillColor: .diamondColor)
    static let iconCopyWhite = SVGKit.loadImage(with: "ic_copy", fillColor: .white)
    static let iconCopyGray = SVGKit.loadImage(with: "ic_copy")
    static let bgTabHeader = SVGKit.loadImage(with: "bg_tab_header")
    static let imageExchangeGiftSuccess = SVGKit.loadImage(with: "img_exchange_gift_success")

    // MARK: -Auth
    static let imageFirstConnection = SVGKit.loadImage(with: "img_first_connection")
    static let iconAuthCheckBox = SVGKit.loadImage(with: "ic_auth_check_box")

    // MARK: -Home
    static let iconHomePhone = SVGKit.loadImage(with: "ic_home_phone")
    static let iconHomeData = SVGKit.loadImage(with: "ic_home_data")
    static let iconEyeOpenGray = SVGKit.loadImage(with: "ic_eye_open")
    static let iconEyeSplashGray = SVGKit.loadImage(with: "ic_eye_slash")
    static let iconEyeOpenWhite = SVGKit.loadImage(with: "ic_eye_open", fillColor: .white)
    static let iconEyeSplashWhite = SVGKit.loadImage(with: "ic_eye_slash", fillColor: .white)
    static let imageLogoHeaderWhite = SVGKit.loadImage(with: "img_logo_header_white", fillColor: .white)
    static let iconArrowUp = SVGKit.loadImage(with: "ic_arrow_up")

    // MARK: -Gift
    static let iconCateAll = SVGKit.loadImage(with: "ic_cate_all")
    static let iconCateAllDiamond = SVGKit.loadImage(with: "ic_cate_all", fillColor: .white)
    static let iconCheckBoxFilter = SVGKit.loadImage(with: "ic_check_box_filter")
    static let iconFilter = SVGKit.loadImage(with: "ic_filter")
    static let iconSortAsc = SVGKit.loadImage(with: "ic_sort_asc")
    static let iconSortDesc = SVGKit.loadImage(with: "ic_sort_desc")
    static let iconTickCircle = SVGKit.loadImage(with: "ic_tick_circle")
    static let iconCheckBox = SVGKit.loadImage(with: "ic_check_box")
    static let iconUncheckBox = SVGKit.loadImage(with: "ic_uncheck_box")
    static let iconBellWarning = SVGKit.loadImage(with: "ic_bell_warning")
    static let iconPhoneInstall = SVGKit.loadImage(with: "ic_phone_install")
    static let iconGiftPhoneGray = SVGKit.loadImage(with: "ic_gift_phone")
    static let iconGiftPhoneWhite = SVGKit.loadImage(with: "ic_gift_phone", fillColor: .white)
    static let iconGiftLocationGray = SVGKit.loadImage(with: "ic_gift_location", fillColor: .cA7A7B3)
    static let iconGiftLocationWhite = SVGKit.loadImage(with: "ic_gift_location", fillColor: .white)
    static let iconGiftNoteGray = SVGKit.loadImage(with: "ic_gift_note")
    static let iconGiftNoteWhite = SVGKit.loadImage(with: "ic_gift_note", fillColor: .white)

    //MARK: -Diamond
    static let iconArrowRightYellow = SVGKit.loadImage(with: "ic_arrow_right")
    static let iconSupportYellow = SVGKit.loadImage(with: "ic_support")
    static let iconDiamondClearTF = SVGKit.loadImage(with: "ic_diamond_clear_tf")
    static let iconHomeWhite = SVGKit.loadImage(with: "ic_tab_home_inactive", fillColor: .white)
}

extension UIImage {
    convenience init?(imageName: String) {
        let bundle = Bundle(for: LaunchScreenViewController.self)
        self.init(named: imageName, in: bundle, compatibleWith: nil)
    }
}


extension UIImage {
    func blendWithColor(color: UIColor = .gray, blendMode: CGBlendMode = .saturation) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: self.size)

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        // Fill the context with the background color
        context.setFillColor(color.cgColor)
        context.fill(rect)

        // Draw the original image with the specified blend mode
        self.draw(in: rect, blendMode: blendMode, alpha: 1.0)

        // Get the blended image
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage
    }

    func applyColorFilter(color: UIColor = .gray) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgImage)

        guard let filter = CIFilter(name: "CIColorMonochrome") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor(color: color), forKey: kCIInputColorKey)
        filter.setValue(1.0, forKey: kCIInputIntensityKey)

        guard let outputImage = filter.outputImage else { return nil }

        let context = CIContext(options: nil)
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: outputCGImage)
    }

}
