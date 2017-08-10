//
//  WBDiscoverViewController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/10.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBDiscoverViewController: WBBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //
        WBNetworkManager.shared.userAccount.access_token = nil
        print("修改了  token")
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        
    }
}
