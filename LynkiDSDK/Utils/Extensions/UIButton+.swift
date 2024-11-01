//
//  UIButton+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/03/2024.
//

import UIKit

extension UIButton {
    func enable() {
        self.isEnabled = true
        self.alpha = 1
    }

    func disable(withAlpha alpha: CGFloat = 0.5) {
        self.isEnabled = false
        self.alpha = alpha
    }
    
    func setImage(with image: UIImage?) {
        self.imageEdgeInsets = .zero
        self.setImage(image, for: .normal)
    }
}
