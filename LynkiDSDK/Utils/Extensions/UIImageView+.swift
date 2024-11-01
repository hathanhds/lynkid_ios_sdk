//
//  UIImageView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/01/2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setSDImage(with urlString: String? = nil, placeholderImage: UIImage? = nil, scaleMode: ContentMode? = nil) {
        let url = URL(string: urlString ?? "")
        self.contentMode = scaleMode ?? .scaleAspectFill
        self.clipsToBounds = true
        self.sd_setImage(with: url, placeholderImage: placeholderImage ?? .imgLinkIDPlaceholder)
    }

    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
