//
//  WBTitleButton.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/8/2.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    
    /// 重载构造函数
    /// - title 如果是 nil，就显示`首页`
    /// - 如果不为 nil，显示 title 和 箭头图像
    init(title: String?){
        super.init(frame: CGRect())
        
        // 1> 判断title是否为nil
        if title == nil {
            setTitle("首页", for: [])
        } else {
            setTitle(title! + "  ", for: [])
            // 设置图像
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        }
        // 2> 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        
        // 3> 设置大小
        sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLable = titleLabel,let imageView = imageView else {
            return
        }
        print("\(titleLabel) \(imageView)")
        
        // 将 label 的 x 向左移动 imageView 的宽度
        // OC 中不允许直接修改`结构体内部的值`
        // Swift 中可以直接修改
        titleLabel?.frame.origin.x = 0
        
        // 将imageVie的x向右移动label的宽度
        imageView.frame.origin.x = (titleLabel?.bounds.width)!
    }
}


