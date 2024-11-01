//
//  PopupDiamondFilterViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 27/06/2024.
//

import UIKit

class PopupDiamondFilterViewController: BaseViewController {
    
    var viewModel: PopupDiamondFilterViewModel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var mostPopularOptionImageView: UIImageView!
    @IBOutlet weak var cheapestOptionImageView: UIImageView!
    
    class func create(with navigator: Navigator, viewModel: PopupDiamondFilterViewModel) -> PopupDiamondFilterViewController {
        let vc = UIStoryboard.popup.instantiateViewController(ofType: PopupDiamondFilterViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func initView() {
        
        if(viewModel.output.selectedOption.value == .popular){
            mostPopularOptionImageView.image = .icDiamondOptionSelectedBtn
            cheapestOptionImageView.image = .icDiamondOptionUnselectedBtn
        } else {
            mostPopularOptionImageView.image = .icDiamondOptionUnselectedBtn
            cheapestOptionImageView.image = .icDiamondOptionSelectedBtn
        }
        
        if let _ = viewModel.output.dismissable {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            bgView.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.alpha = 0.7
        
        mainView.layer.masksToBounds = false
        mainView.layer.cornerRadius = 16
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        applyButton.setGradient(colors: [.c92653E!, .cD4A666!, .c92653E!], direction: .right)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onTapMostPopular(_ sender: Any) {
        viewModel.input.selectMostPopularOptionAction.onNext(())
        mostPopularOptionImageView.image = .icDiamondOptionSelectedBtn
        cheapestOptionImageView.image = .icDiamondOptionUnselectedBtn
        
    }
    
    @IBAction func onTapCheapest(_ sender: Any) {
        viewModel.input.selectCheapestOptionAction.onNext(())
        mostPopularOptionImageView.image = .icDiamondOptionUnselectedBtn
        cheapestOptionImageView.image = .icDiamondOptionSelectedBtn
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        viewModel.input.closeAction.onNext(())
        self.dismiss(animated: true)
    }
    
    @IBAction func onApplyTap(_ sender: Any) {
        viewModel.input.applyAction.onNext(())
        self.dismiss(animated: true)
    }
}
