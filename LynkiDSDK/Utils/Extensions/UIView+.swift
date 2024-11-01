//
//  UIView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/01/2024.
//

import UIKit
import SkeletonView

enum GradientDirection {
    case up, down, left, right

    var startPoint: CGPoint {
        switch self {
        case .up:
            return CGPoint(x: 0.5, y: 1)
        case .down:
            return CGPoint(x: 0.5, y: 0)
        case .left:
            return CGPoint(x: 1, y: 0.5)
        case .right:
            return CGPoint(x: 0, y: 0.5)
        }
    }

    var endPoint: CGPoint {
        switch self {
        case .up:
            return CGPoint(x: 0.5, y: 0)
        case .down:
            return CGPoint(x: 0.5, y: 1)
        case .left:
            return CGPoint(x: 0, y: 0.5)
        case .right:
            return CGPoint(x: 1, y: 0.5)
        }
    }
}

@IBDesignable
extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        } set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        } set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        } set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        } set {
            self.layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        } set {
            self.layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        } set {
            self.layer.shadowRadius = newValue
        }
    }

    func setGradient(colors: [UIColor], direction: GradientDirection) {
        self.removeGradient()
        self.backgroundColor = .clear

        var locations = [0.0, 1.0]
        if(colors.count == 3) {
            locations = [0.0, 0.5, 1.0]
        }
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.locations = locations.map { NSNumber(value: $0) }
        gradient.colors = colors.compactMap({ $0.cgColor })
        gradient.startPoint = direction.startPoint
        gradient.endPoint = direction.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    

    func setCommonGradient() {
        self.setGradient(colors: [.c591C90!, .c971ACC!], direction: .right)
    }
    
    func setInstallAppButtonGradient() {
        self.setGradient(colors: [.cFFD10F!, .cFE9E32!], direction: .right)
    }
    
    // Diamond
    func setDiamondBackgroundGradient() {
        self.setGradient(colors: [.c0F0F0F!, .c47372B!], direction: .down)
    }

    func setDiamondHeaderGradient() {
        self.setGradient(colors: [.c0F0F0F!, .c47372B!], direction: .right)
    }

    func setDiamondButtonGradient() {
        self.setGradient(colors: [.c92653E!, .cD4A666!, .c92653E!], direction: .right)
    }

    func removeGradient() {
        self.layer.sublayers?.forEach({ (l) in
            if l is CAGradientLayer {
                l.removeFromSuperlayer()
            }
        })
    }

    func setDefaultViewWithShadow() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }

    func setShadow(cornerRadius: CGFloat, shadowColor: UIColor = .black, shadowOpacity: Float = 0.2, shadowOffset: CGSize = .zero, shadowRadius: CGFloat = 4) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func applyCircle() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

// MARK: - init custom view
protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {

    static var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }

    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }

    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}

extension UIView {

    func showSkeletonView() {
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
        self.showAnimatedSkeleton(usingColor: .shimmerColor!, transition: .crossDissolve(0.25))
        self.isUserInteractionEnabled = false
        self.isUserInteractionDisabledWhenSkeletonIsActive = true
    }

    func showIndicator() {
        self.addIndicator()
        self.activityIndicator?.startAnimating()
    }

    func hideIndicator() {
        self.activityIndicator?.stopAnimating()
    }

    func addIndicator() {
        var activityIndicator: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = .lightGray
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        let centerOffset = self.bounds.size.width / 2.0
        activityIndicator.center = CGPoint(x: centerOffset, y: centerOffset)
        self.addSubview(activityIndicator)
    }

    var activityIndicator: UIActivityIndicatorView? {
        return self.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }

}

enum ViewBorder: String {
    case left, right, top, bottom
}

extension UIView {

    func add(border: ViewBorder, color: UIColor, width: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.name = border.rawValue
        switch border {
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(borderLayer)
    }

    func remove1(border: ViewBorder) {
        layer.sublayers?.compactMap { $0 }.filter { $0.name == border.rawValue }.forEach { $0.removeFromSuperlayer()
        }
    }

    func removeAllSubView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    func constraint(to v: UIView, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -insets.right).isActive = true
        self.topAnchor.constraint(equalTo: v.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -insets.bottom).isActive = true
    }


    func drawTicket(directionHorizontal isHorizontal: Bool,
        withCutoutRadius cutoutRadius: Double,
        andCornerRadius cornerRadius: Double,
        fillColor layerColor: UIColor?,
        withStrokeColor strokeColor: UIColor? = UIColor.cEFEFF6,
        andFrame frame: CGRect,
        andTicketPosition ticketPosition: CGPoint) {

        if let sublayers = self.layer.sublayers {
            for layer in sublayers where layer.name == "ticketShape" {
                layer.removeFromSuperlayer()
                break
            }
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "ticketShape"
        let path = UIBezierPath()
        let cornerRadius: CGFloat = cornerRadius // Adjust corner radius to your preference
        let cutoutRadius: CGFloat = cutoutRadius // Radius for the circular cutout
        let cutoutPosition: CGFloat = isHorizontal ? ticketPosition.x + 1 : ticketPosition.y + 1 //  position for the cutout

        if(isHorizontal) {
            // Start from the top left
            path.move(to: CGPoint(x: frame.minX + cornerRadius, y: frame.minY))

            // Top cutout
            path.addArc(withCenter: CGPoint(x: frame.minX + cutoutPosition, y: frame.minY), radius: cutoutRadius, startAngle: -CGFloat.pi, endAngle: 0, clockwise: false)

            // Right top corner
            path.addArc(withCenter: CGPoint(x: frame.maxX - cornerRadius, y: frame.minY + cornerRadius), radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)

            //        // Right border
            path.addLine(to: CGPoint(x: frame.maxX, y: cutoutPosition + cutoutRadius))
            //
            //        // Right bottom corner
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY - cornerRadius))
            path.addArc(withCenter: CGPoint(x: frame.maxX - cornerRadius, y: frame.maxY - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            //
            //        // Bottom cutout
            path.addArc(withCenter: CGPoint(x: frame.minX + cutoutPosition, y: frame.maxY), radius: cutoutRadius, startAngle: 0, endAngle: .pi, clockwise: false)

            //        // Left bottom corner
//            path.addLine(to: CGPoint(x: frame.minX + cornerRadius, y: frame.maxY))
            path.addArc(withCenter: CGPoint(x: frame.minX + cornerRadius, y: frame.maxY - cornerRadius), radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)

            // Left top corner
            path.addLine(to: CGPoint(x: frame.minX, y: frame.minY + cornerRadius))
            path.addArc(withCenter: CGPoint(x: frame.minX + cornerRadius, y: frame.minY + cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        } else {
            // Start from the top left
            path.move(to: CGPoint(x: frame.minX + cornerRadius, y: frame.minY))

            // Top border
            path.addLine(to: CGPoint(x: frame.maxX - cornerRadius, y: frame.minY))
            path.addArc(withCenter: CGPoint(x: frame.maxX - cornerRadius, y: frame.minY + cornerRadius), radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)

            // Right border
            path.addLine(to: CGPoint(x: frame.maxX, y: cutoutPosition - cutoutRadius))

            // Right cutout
            path.addArc(withCenter: CGPoint(x: frame.maxX, y: cutoutPosition), radius: cutoutRadius, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: false)
            path.addLine(to: CGPoint(x: frame.maxX, y: cutoutPosition + cutoutRadius))

            // Right bottom corner
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY - cornerRadius))
            path.addArc(withCenter: CGPoint(x: frame.maxX - cornerRadius, y: frame.maxY - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)

            // Bottom border
            path.addLine(to: CGPoint(x: frame.minX + cornerRadius, y: frame.maxY))
            path.addArc(withCenter: CGPoint(x: frame.minX + cornerRadius, y: frame.maxY - cornerRadius), radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)

            // Left bottom corner
            path.addLine(to: CGPoint(x: frame.minX, y: cutoutPosition + cutoutRadius))

            // Left cutout
            path.addArc(withCenter: CGPoint(x: frame.minX, y: cutoutPosition), radius: cutoutRadius, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: false)
            path.addLine(to: CGPoint(x: frame.minX, y: cutoutPosition - cutoutRadius))

            // Left top corner
            path.addLine(to: CGPoint(x: frame.minX, y: frame.minY + cornerRadius))
            path.addArc(withCenter: CGPoint(x: frame.minX + cornerRadius, y: frame.minY + cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        }


        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = strokeColor?.cgColor
        shapeLayer.fillColor = nil
        if let fillColor = layerColor {
            shapeLayer.fillColor = fillColor.cgColor;
        }

        shapeLayer.lineWidth = 1


        layer.insertSublayer(shapeLayer, at: 0)
    }
}

