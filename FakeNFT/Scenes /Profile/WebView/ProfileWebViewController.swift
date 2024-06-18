//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 09/05/24.
//

import UIKit
import WebKit

final class ProfileWebViewViewController: UIViewController, WKUIDelegate, ErrorView {

    let userWebsiteAbsoluteString: String?

    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        return webView
    }()

    init(userWebsiteAbsoluteString: String?) {
        self.userWebsiteAbsoluteString = userWebsiteAbsoluteString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let userWebsiteAbsoluteString else { return }
        guard let url = URL(string: userWebsiteAbsoluteString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
