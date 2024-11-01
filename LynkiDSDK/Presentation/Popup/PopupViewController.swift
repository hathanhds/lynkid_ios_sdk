//
//  PopupWithTwoOptionsViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/05/2024.
//

import UIKit

class PopupViewController: BaseViewController {
    var viewModel: PopupViewModel!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmOneOptionButton: UIButton!
    @IBOutlet weak var confirmTwoOptionButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var twoOptionStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!

    class func create(with navigator: Navigator, viewModel: PopupViewModel) -> PopupViewController {
        let vc = UIStoryboard.popup.instantiateViewController(ofType: PopupViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (viewModel.output.isDiamond) {
            confirmOneOptionButton.setDiamondButtonGradient()
            confirmTwoOptionButton.setDiamondButtonGradient()
        } else {
            confirmOneOptionButton.setCommonGradient()
            confirmTwoOptionButton.setCommonGradient()
        }

    }

    override func initView() {
        if (viewModel.output.isDiamond) {
            containerView.backgroundColor = .diamondBgColor
            cancelButton.borderColor = .diamondColor
            cancelButton.backgroundColor = .clear
            titleLabel.textColor = .white
            messageLabel.textColor = .cA7A7B3
            cancelButton.setTitleColor(.diamondColor, for: .normal)
        }

    }

    override func bindToView() {
        titleLabel.text = viewModel.output.title
        messageLabel.text = viewModel.output.message
        imageView.image = viewModel.output.image
        confirmOneOptionButton.setTitle(viewModel.output.confirmButtonTitle, for: .normal)
        confirmTwoOptionButton.setTitle(viewModel.output.confirmButtonTitle, for: .normal)
        cancelButton.setTitle(viewModel.output.cancelButtonTitle, for: .normal)

        switch viewModel.output.type {
        case .noOption:
            buttonsStackView.isHidden = true
            break
        case .oneOption:
            buttonsStackView.isHidden = false
            twoOptionStackView.isHidden = true
            confirmOneOptionButton.isHidden = false
            break
        case .twoOption:
            buttonsStackView.isHidden = false
            twoOptionStackView.isHidden = false
            confirmOneOptionButton.isHidden = true
            break
        }

        if let _ = viewModel.output.dismissable {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            bgView.addGestureRecognizer(tap)
        }
    }


    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @IBAction func cancelAction(_ sender: Any) {
        viewModel.input.cancelAction.onNext(())
        self.dismiss(animated: true)
    }

    @IBAction func confirmAction(_ sender: Any) {
        viewModel.input.confirmAction.onNext(())
        self.dismiss(animated: true)
    }

}


