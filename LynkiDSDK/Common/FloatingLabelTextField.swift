//
//  FloatingLabelTextField.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/06/2024.
//

import UIKit

class FloatingLabelTextField: UITextField {

    private let floatingLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 18, width: 200, height: 18))
    private var isFloating: Bool = false

// Padding for the text field
    private let padding = UIEdgeInsets(top: 15, left: 0, bottom: 5, right: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    var floatingColor: UIColor = UIColor.c6D6B7A ?? .gray {
        didSet {
            floatingLabel.textColor = floatingColor
        }
    }

    private func setup() {
        // Configure the floating label
//        floatingLabel.textColor = floatingColor
        floatingLabel.font = .f14r
        floatingLabel.alpha = 1.0
        addSubview(floatingLabel)

        self.placeHolderColor = .clear

        // Add target for editing events
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateFloatingLabelPosition()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    private func updateFloatingLabelPosition() {
        if !isFloating && (isFirstResponder || !(text?.isEmpty ?? true)) {
            isFloating = true
            animateFloatingLabel(shouldFloat: true)
        } else if isFloating && !isFirstResponder && (text?.isEmpty ?? true) {
            isFloating = false
            animateFloatingLabel(shouldFloat: false)

        }
    }

    private func animateFloatingLabel(shouldFloat: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if shouldFloat {
                self.floatingLabel.transform = CGAffineTransform(translationX: 0, y: -16)
                self.floatingLabel.font = .f12r
                self.floatingLabel.textColor = self.floatingColor //.cA7A7B3
            } else {
                self.floatingLabel.transform = .identity
                self.floatingLabel.font = .f14r
                self.floatingLabel.textColor = self.floatingColor //.c6D6B7A
            }
        })
    }

    @objc private func textFieldDidBeginEditing() {
        updateFloatingLabelPosition()
    }

    @objc private func textFieldDidEndEditing() {
        updateFloatingLabelPosition()
    }

    @objc private func textFieldDidChange() {
        updateFloatingLabelPosition()
    }

    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
        }
    }
}
