//
//  UITextField+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 04/06/2024.
//

import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UITextField {
    func setClearButtonWithImage(image: UIImage?) {
        guard let image = image else { return }
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }

    @objc func clear(sender: AnyObject) {
        self.text = ""
    }
}
