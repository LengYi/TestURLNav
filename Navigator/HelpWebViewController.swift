//
//  HelpWebViewController.swift
//  TestURLNav
//
//  Created by zj-db1140 on 2018/10/30.
//  Copyright © 2018年 zj-db1140. All rights reserved.
//

import UIKit
class HelpWebViewController: WebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
        self.title = "帮助"
        print("本地帮助H5")
    }
}
