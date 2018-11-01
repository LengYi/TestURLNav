//
//  TestViewController.swift
//  TestURLNav
//
//  Created by zj-db1140 on 2018/10/30.
//  Copyright © 2018年 zj-db1140. All rights reserved.
//

import UIKit
class TestViewController: UIViewController {
    var msg: String = ""
    var code: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        let label = UILabel.init(frame: CGRect(x: 20, y: 100, width: 300, height: 30))
        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.text = "msg: \(String(describing: self.msg)) code: \(String(describing: self.code))"
        label.center = self.view.center
        self.view.addSubview(label)
    }
}
