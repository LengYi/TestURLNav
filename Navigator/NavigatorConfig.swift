//
//  NavigatorConfig.swift
//  TestURLNav
//
//  Created by zj-db1140 on 2018/10/30.
//  Copyright © 2018年 zj-db1140. All rights reserved.
//

import SafariServices
import UIKit
import URLNavigator

// 定义全局变量
let navigator = NavigatorConfig()

class NavigatorConfig: Navigator {
    static func initialize() {
        // 打开网址
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        // 打开本地H5
        navigator.register("navigator://localH5/<target>", self.localH5Factory)
        
        // 打开本地模块
        navigator.register("navigator://test") { (url, values, content) -> UIViewController? in
            guard let msg = url.queryParameters["msg"] else {
                return nil
            }
            guard let code = url.queryParameters["code"] else {
                return nil
            }
            
            let modelVC = TestViewController()
            modelVC.msg = msg
            modelVC.code = code
            return modelVC
        }
        
        navigator.handle("navigator://alert") { (url, values, content) -> Bool in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
    
    private static func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private static func localH5Factory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let target = values["target"] as? String else { return nil }
        var h5VC: WebViewController?
        switch target {
        case "help":
            h5VC = HelpWebViewController()
            h5VC?.type = H5Type.help
        case "agree":
            h5VC = AgreeWebViewController()
            h5VC?.type = H5Type.agree
        default:
            break
        }
        return h5VC
    }
}
