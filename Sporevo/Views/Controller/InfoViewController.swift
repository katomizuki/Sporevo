//
//  InfoViewController.swift
//  Sporevo
//
//  Created by ミズキ on 2022/02/16.
//

import UIKit
import WebKit

final class InfoViewController: UIViewController {
    
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       bottom: view.safeAreaLayoutGuide.bottomAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor)
        if let url = URL(string: "https://docs.google.com/forms/d/1Hlb0ol7A9D9QHKtPIYWCrkGgY202z3fjYLhCQ_x5UrM/edit") {
            self.webView.load(URLRequest(url: url))
        }
        
    }
}
