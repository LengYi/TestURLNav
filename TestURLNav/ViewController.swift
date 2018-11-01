//
//  ViewController.swift
//  TestURLNav
//
//  Created by zj-db1140 on 2018/10/30.
//  Copyright © 2018年 zj-db1140. All rights reserved.
//

import UIKit
import URLNavigator

struct Info {
    var name: String
    var urlString: String
}

class ViewController: UIViewController {

    var tableListView: UITableView?
    //var navigator: NavigatorType?
    
    let datas = [
        Info(name: "baidu", urlString: "http://www.baidu.com"),
        Info(name: "github", urlString: "https://github.com"),
        Info(name: "localH5/help", urlString: "navigator://localH5/help"),
        Info(name: "localH5/agree", urlString: "navigator://localH5/agree"),
        Info(name: "testViewController", urlString: "navigator://test?msg=好消息&code=10086"),
        Info(name: "alert", urlString: "navigator://alert?title=Hello&message=World"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableListView = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
        tableListView?.delegate = self
        tableListView?.dataSource = self
        tableListView?.register(UITableViewCell.self, forCellReuseIdentifier: "user")
        self.view.addSubview(tableListView!)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        let user = self.datas[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.urlString
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let user = self.datas[indexPath.row]
        let isPushed = navigator.push(user.urlString) != nil
        if isPushed {
            print("[Navigator] push: \(user.urlString)")
        } else {
            print("[Navigator] open: \(user.urlString)")
            navigator.open(user.urlString)
        }
    }
}

