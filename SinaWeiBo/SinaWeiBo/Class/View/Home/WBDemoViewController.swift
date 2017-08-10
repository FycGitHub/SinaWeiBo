//
//  WBDemoViewController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/11.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置标题
        title  = "第\(navigationController?.childViewControllers.count ?? 0 )个"
    }
    
    func showNext() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBDemoViewController {
    
    override func setUpTableView() {
        super.setUpTableView()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", fontSize: 16, target: self, action: #selector(showNext), isBack: false)
    }
}
