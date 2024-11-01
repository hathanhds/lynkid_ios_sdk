//
//  UIFont+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//

import UIKit

class FontName {
    static let regular = "BeVietnamPro-Regular"
    static let medium = "BeVietnamPro-Medium"
    static let semiBold = "BeVietnamPro-SemiBold"
}

extension UIFont {
    private static func registerFont(withName name: String, fileExtension: String) {
        let bundle = Bundle(for: LaunchScreenViewController.self)
        let pathForResourceString = bundle.path(forResource: name, ofType: fileExtension)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            print("Error registering font")
        }
    }

    public static func loadFonts() {
        registerFont(withName: FontName.regular, fileExtension: "ttf")
        registerFont(withName: FontName.medium, fileExtension: "ttf")
        registerFont(withName: FontName.semiBold, fileExtension: "ttf")
    }
}

extension UIFont {
    // MARK: - regular
    static let f12r = UIFont(name: FontName.regular, size: 12)
    static let f12s = UIFont(name: FontName.semiBold, size: 12)
    
    static let f14r = UIFont(name: FontName.regular, size: 14)
    static let f14s = UIFont(name: FontName.semiBold, size: 14)
    
    static let f18s = UIFont(name: FontName.semiBold, size: 18)
    
    static let f20s = UIFont(name: FontName.semiBold, size: 20)
}

