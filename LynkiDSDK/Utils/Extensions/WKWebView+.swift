//
//  WKWebView+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import WebKit

enum WebViewType {
    case webViewDetail
    case webViewDiamond
    case webViewPolicy
    case webViewFAQ
}

extension WKWebView {
    //// - Parameters:
    ///   - content: HTML content which we need to load in the webview.
    ///   - baseURL: Content base url. It is optional.
    func loadHTMLStringWith(content: String, baseURL: URL?) {
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }

    func injectJavascript(superView: UIView, webViewHeightConstraint: NSLayoutConstraint) {
        self.frame.size.height = 1
        self.frame.size = self.sizeThatFits(.zero)
        self.scrollView.isScrollEnabled = false;
        self.evaluateJavaScript("document.documentElement.scrollHeight") { [weak self] (height, error) in
            guard let height = height as? CGFloat, let _ = self else { return }
            webViewHeightConstraint.constant = height
            superView.updateConstraints()
            superView.updateConstraintsIfNeeded()
        }
    }

    func getWebView(withHTMLContent content: String, withStyle type: WebViewType) {

        //clear background of uiwwebview and use color of html instead
        self.configuration.preferences.javaScriptEnabled = true
        self.isOpaque = false
        self.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear

        let screenWidth = UIScreen.main.bounds.width
        var style = ""

        switch type {
        case .webViewDetail:
            style = """
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
                <style>
                    * {
                        margin: 0px !important;
                        padding: 0px !important;
                        line-height: 1.6 !important;
                        background-color: white !important;
                        font-family: 'Roboto' !important;
                        color: #242424;
                        font-size: \(14)px !important;
                    }
                    p {
                        font-size: \(14)px !important;
                        font-family: 'Roboto' !important;
                    }
                    img {
                        width: \(screenWidth - 32)px;
                    }
                </style>
                """
        case .webViewDiamond:
            style = """
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
                <style>
                    * {
                      margin: 0px !important;
                      padding: 0px !important;
                      line-height: 1.6 !important;
                      background-color: transparent !important;
                      font-family: 'Roboto' !important;
                      color: white;
                      font-size: \(14)px !important;
                    }
                    span {
                        font-size: \(14)px !important;
                        font-family: 'Roboto' !important;
                    }
                    p {
                      font-size: \(14)px !important;
                      font-family: 'Roboto' !important;
                    }

                    img{
                      width: \(screenWidth - 32)px;
                    }
               </style>
            """
        case .webViewPolicy:
            style = """
                <style>
                    @font-face {
                        font-family: 'BeVietnamPro-Regular';
                        font-weight: 400;
                        src: url('BeVietnamPro-Regular.ttf');
                    }
                
                    @font-face {
                        font-family: 'BeVietnamPro-Medium';
                        font-weight: 500;
                        src: url('BeVietnamPro-Medium.ttf');
                    }
                
                    @font-face {
                        font-family: 'BeVietnamPro-SemiBold';
                        font-weight: 600;
                        src: url('BeVietnamPro-SemiBold.ttf');
                    }
                    * {
                      all: revert !important;
                      margin: 0px !important;
                      text-align: justify !important;
                      line-height: 1.6 !important;
                      background-color: white !important;
                      font-family: 'BeVietnamPro-Regular', !important;
                      background-color: white !important;
                      font-size: \(14)px !important;
                    }
                    p {
                      font-size: \(14)px !important;
                      font-family: 'BeVietnamPro-Regular' !important;
                    }
                </style>
                """
        case .webViewFAQ:
            style = """
                <style>
                    @font-face {
                        font-family: 'BeVietnamPro-Regular';
                        font-weight: 400;
                        src: url('BeVietnamPro-Regular.ttf');
                    }
                
                    @font-face {
                        font-family: 'BeVietnamPro-Medium';
                        font-weight: 500;
                        src: url('BeVietnamPro-Medium.ttf');
                    }
                
                    @font-face {
                        font-family: 'BeVietnamPro-SemiBold';
                        font-weight: 600;
                        src: url('BeVietnamPro-SemiBold.ttf');
                    }
                    * {
                      all: revert !important;
                      margin: 0px !important;
                      text-align: justify !important;
                      line-height: 1.6 !important;
                      background-color: white !important;
                      font-family: 'BeVietnamPro-Regular' !important;
                      background-color: white !important;
                      font-size: \(14)px !important;
                    }
                    body {
                      max-width: 100% !important;
                      width: \(screenWidth - 40)px !important
                    }

                    img{
                      width: 100%
                      max-width:\(screenWidth - 32)px !important;
                      height: 50px
                    }
                    p {
                      font-size: \(14)px !important;
                      font-family: 'BeVietnamPro-Regular' !important;
                    }
                    li, ol, ul {
                      list-style-type: none !important;
                      margin: 0 !important;
                      list-style-type: square !important;
                    }
                    img {
                      width: auto;
                      max-width: 80%;
                      margin-top: \(14)px !important;
                      margin-left: auto !important;
                      margin-right: auto !important;
                      display:block !important;
                    }
                    a {
                      text-decoration-line: underline !important;
                      color: blue !important;
                    }
                </style>
                """
        }

        if let htmlPath = UtilHelper.bundle.path(forResource: "html_template", ofType: "html"),
            let htmlString = try? String(contentsOfFile: htmlPath, encoding: .utf8) {
            let finalHtmlString = htmlString.replacingOccurrences(of: "{0}", with: style).replacingOccurrences(of: "{1}", with: content)
            self.loadHTMLString(finalHtmlString, baseURL: Bundle.main.bundleURL)
        }
    }
}
