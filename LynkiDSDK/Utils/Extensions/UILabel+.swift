//
//  UILabel+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/02/2024.
//

import UIKit

extension UILabel {
    func strikeThrough() {
        if let lblText = self.text {
            let attributeString = NSMutableAttributedString(string: lblText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    
}
