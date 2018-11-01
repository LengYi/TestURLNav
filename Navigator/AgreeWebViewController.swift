//
//  AgreeWebViewController.swift
//  TestURLNav
//
//  Created by zj-db1140 on 2018/10/30.
//  Copyright © 2018年 zj-db1140. All rights reserved.
//

import UIKit
class AgreeWebViewController: WebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        self.title = "同意协议"
        print("本地同意协议H5")
    }
}
