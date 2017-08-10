//
//  WBNavigationController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/10.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //NAV 是通过栈的形式管理
        // 如果不是底层控制器才需要隐藏,跟控制器不需要处理
        if childViewControllers.count > 0 {
            //隐藏 TabBar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型
            if let vc = viewController as? WBBaseViewController {
                var  title = "返回"
                
                //判断控制器的级数,只有一个子控制器的时候,显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    //title 显示首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                // 取出自定义的 navItem，设置左侧按钮作为返回按钮
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent), isBack: true)
            }
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
    /// POP 返回到上一级控制器
    func popToParent() {
        popViewController(animated: true)
    }


}



