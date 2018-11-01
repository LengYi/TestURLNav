//
//  WebViewController.swift
//  TestURLNav
//
//  Created by zj-db1140 on 2018/10/30.
//  Copyright © 2018年 zj-db1140. All rights reserved.
//

import UIKit

enum H5Type {
    case help
    case agree
}

class WebViewController: UIViewController {
    var type: H5Type = H5Type.help
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showWebView()
    }
    
    func showWebView() {
        var resourceName = ""
        switch self.type {
        case .help:
            resourceName = "help"
        case .agree:
            resourceName = "agree"
        }
        
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "html") else {
            return
        }
        
        guard let str = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue), let url = URL(string: path) else {
            return
        }
        
        let webView = UIWebView()
        webView.frame = self.view.frame
        webView.loadHTMLString(str as String, baseURL: url)
        self.view.addSubview(webView)
    }
}
