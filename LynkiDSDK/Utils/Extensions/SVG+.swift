//
//  SVG+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/07/2024.
//

import Foundation
import SVGKit

extension SVGKit {
    static let bundle = Bundle(for: LaunchScreenViewController.self)
    static func loadImage(with named: String,
        fontSize size: CGSize? = nil,
        fillColor color: UIColor? = nil,
        opacity: Float = 1.0
    ) -> UIImage? {
        guard let svgURL = bundle.url(forResource: named, withExtension: "svg") else {
            print("SVG file not found")
            return nil
        }
        guard let svgImage = SVGKImage(contentsOf: svgURL) else {
            print("Failed to load SVG image")
            return nil
        }
        if let size = size {
            svgImage.size = size
        }


        if let color = color {
            svgImage.setTintColor(color: color)

        }
        var uiImage = svgImage.uiImage
        return uiImage
    }
}

extension SVGKImage {

    func setTintColor(color: UIColor) {
        if self.caLayerTree != nil {
            changeFillColorRecursively(sublayers: self.caLayerTree.sublayers, color: color)
        }
    }

    private func changeFillColorRecursively(sublayers: [AnyObject]?, color: UIColor) {
        if let sublayers = sublayers {
            for layer in sublayers {
                if let l = layer as? CAShapeLayer {
                    if l.strokeColor != nil {
                        l.strokeColor = color.cgColor
                    }
                    if l.fillColor != nil {
                        l.fillColor = color.cgColor
                    }
                }
                if let l = layer as? CALayer, let sub = l.sublayers {
                    changeFillColorRecursively(sublayers: sub, color: color)
                }
            }
        }
    }
}
