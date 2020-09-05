//
//  WebViewController.swift
//  NY Times
//
//  Created by David Kababyan on 05/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    //MARK: - Vars
    var webLink: String!
    var webKitView: WKWebView!

    //MARK: - Init
    init(webLink: String) {
        super.init(nibName: nil, bundle: nil)
        self.webLink = webLink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize WebView
        let webConfiguration = WKWebViewConfiguration()
        
        webKitView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webKitView
        
        showWebView()
    }

    /// Shows webView with news link
    private func showWebView() {
        if let url = URL(string: webLink) {
            webKitView.load(URLRequest(url: url))
        }
    }


}
