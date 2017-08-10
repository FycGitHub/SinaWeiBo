//
//  WBWelcomeView.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/8/2.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    // 图标的设置
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    class func welcomeView()-> WBWelcomeView {
        let nib  = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        //从XIB加载的视图，默认图片是600*600
        v.frame = UIScreen.main.bounds
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 提示： initWithCode 只是刚刚从 XIB的二进制文件将视图数据加载完成
        // 还没有和代码连线建立关系，所有开发时，千万不要在这个方法中处理UI
        print("initWithCoder + \(iconView)")
    }
    
    //从XIB加载完成调用
    override func awakeFromNib() {
        super.awakeFromNib()
        // 1. url
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString)
            else {
                return
        }
        // 2. 设置头像 - 如果网络图像没有下载完成，先显示占位图像
        // 如果不指定占位图像，之前设置的图像会被清空！
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
       
        // 3. 设置圆角（iconView 的bounds 还没有设置）
        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
        iconView.layer.masksToBounds = true
        
    }
    
    /// 自动布局系统更新完成约束后，会自动调用此方法
    /// 通常是对子视图布局进行修改
    //    override func layoutSubviews() {
    //
    //    }
    
    // 视图被添加到 window上表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        // - layoutInNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在的位置，就是XIB中布局的位置
        self.layoutIfNeeded()
        bottomCons.constant = bounds.size.height - 200
        
        // 如果空间们的frame 还没有计算好，所有约束会一起动画
        UIView.animateKeyframes(withDuration: 1.0,
                                delay: 0,
                                options: [],
                                animations: {
                                    //更新约束
                                    self.layoutIfNeeded()
                                    
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
    
}


