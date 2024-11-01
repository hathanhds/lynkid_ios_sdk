//
//  OTPView.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/06/2024.
//

import Foundation
import UIKit

protocol OTPDelegate: AnyObject {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
}

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    override public func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}

class OTPStackView: UIStackView {

    //Customise the OTPField here
    let numberOfFields = 6
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false

    //Colors
    var warningColor: UIColor = .cF5574E!
    var inactiveFieldBorderColor: UIColor = .cD8D6DD!
    var tfBackgroundColor: UIColor = .white
    var textColor: UIColor = .c242424!
    var activeFieldBorderColor: UIColor = .mainColor!
    var remainingStrStack: [String] = []
    var isDiamond: Bool = false {
        didSet {
            if (isDiamond) {
                inactiveFieldBorderColor = .c6D6B7A!
                tfBackgroundColor = .clear
                activeFieldBorderColor = .diamondColor!
                textColor = .white
                self.removeAllSubView()
                textFieldsCollection = []
                addOTPFields()
            }
        }
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        addOTPFields()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }

    //Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 8
    }

    //Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<numberOfFields {
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index - 1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index - 1].nextTextField = field) : ()
        }
    }

    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField) {

        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = .f20s
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
        textField.textColor = textColor
        textField.backgroundColor = tfBackgroundColor
        textField.tintColor = activeFieldBorderColor
        textField.keyboardAppearance = isDiamond ? .dark : .light
    }

    //checks if all the OTPfields are filled
    private final func checkForValidity() {
        for fields in textFieldsCollection {
            if (fields.text == "") {
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }

    //gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection {
            OTP += textField.text ?? ""
        }
        return OTP
    }

    //set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor) {
        for textField in textFieldsCollection {
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }

    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap { String($0) }
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }

}

//MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setAllFieldColor(isWarningColor: false, color: inactiveFieldBorderColor)
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        if showsWarningColor {
            setAllFieldColor(isWarningColor: true, color: warningColor)
            showsWarningColor = false
        }
    }

    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0) {
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                } else {
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }

}
