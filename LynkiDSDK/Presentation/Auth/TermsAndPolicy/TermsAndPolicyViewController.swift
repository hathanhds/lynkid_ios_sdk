//
//  TermsAndPolicyViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit
import WebKit
import RxSwift


class TermsAndPolicyViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = TermsAndPolicyViewModel

    static func create(with navigator: Navigator, viewModel: TermsAndPolicyViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: TermsAndPolicyViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: TermsAndPolicyViewModel!
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.webView.navigationDelegate = self
        viewModel.getTermsOrPolicy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar()
    }

    override func initView() {
        webView.scrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        webView.scrollView.contentInsetAdjustmentBehavior = .never


    }

    override func bindToView() {
        viewModel.output.title.subscribe(
            onNext: { [weak self] title in
                guard let self = self else { return }
                self.title = title
            }).disposed(by: self.disposeBag)

        viewModel.output.htmlString.subscribe(
            onNext: { [weak self] htmlString in
                guard let self = self else { return }
                self.showLoading()
                self.webView.getWebView(withHTMLContent: htmlString, withStyle: .webViewPolicy)
                self.webView.scrollView.showsVerticalScrollIndicator = false
            }).disposed(by: self.disposeBag)
    }
}

extension TermsAndPolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoading()
    }
}
