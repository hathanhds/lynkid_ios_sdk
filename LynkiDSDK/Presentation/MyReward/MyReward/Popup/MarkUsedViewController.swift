//
//  MarkUsedViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import UIKit

class MarkUsedViewController: BaseViewController, ViewControllerType, SlideToActionButtonDelegate {

    typealias ViewModel = MarkUsedViewModel
    static func create(with navigator: Navigator, viewModel: MarkUsedViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: MarkUsedViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }


    // Outlets
    @IBOutlet weak var slideView: SlideToActionButton!
    // Variables
    var viewModel: MarkUsedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.slideView.setCommonGradient()
    }

    override func initView() {
        slideView.titleLabel.text = "Trượt để xác nhận sử dụng"
        slideView.delegate = self
    }

    func didFinish() {
        self.dismiss(animated: true)
        viewModel.input.didFinish.onNext(())
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
