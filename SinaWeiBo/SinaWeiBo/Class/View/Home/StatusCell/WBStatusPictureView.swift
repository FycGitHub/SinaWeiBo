//
//  WBStatusPictureView.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/8/9.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    var viewModel: WBStatusViewModel? {
        didSet {
            calcViewSize()
            //设置urls
            urls = viewModel?.status.pic_urls
            print("urls ===== \(urls)")
        }
    }
    
    
    ///  根据视图模型的配图视图大小，调整显示内容
    func calcViewSize() {
        // 修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    ///  配置视图的数组
    var urls: [WBStatusPicture]? {
        didSet {
            // 1.隐藏所有的 imageView
            for v in subviews {
               v.isHidden = true
            }
            // 2.遍历 urls 数组，顺序设置图像
            var index = 0
            if urls?.count == 0 {
                return
            }
            for url in urls ?? [] {
              // 获的对应索引的 iamgeView
                let iv = subviews[index] as! UIImageView
                
                //4 张图处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                // 设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
                //判断是否是gif ，根据扩展名
//                iv.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif")
                // 显示图像
                iv.isHidden = false
                
                index += 1
            }
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!

    override func awakeFromNib() {
         setupUI()
    }
    // MARK: - 监听方法
    /// @param selectedIndex    选中照片索引
    /// @param urls             浏览照片 URL 字符串数组
    /// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
    func tapImageView(tap: UITapGestureRecognizer) {
        print("点击海报")
    }
}

// MARK: - 设置界面
extension WBStatusPictureView {
    // 1. Cell 中所有的空间都是提前准备好的
    // 2. 设置的时候，根据数据决定是否显示
    // 2. 不用动态的创建控件
    
    func setupUI()  {
        //  设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        //  超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0,
                          y: WBStatusPictureViewInnerMargin,
                          width: WBStatusPictureItemWidth,
                          height: WBStatusPictureItemWidth)
        
        //  循环创建9个imageView
        for i in 0..<count * count {
            let iv = UIImageView()
            
            // 设置 contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            // 行 -> Y
            let row = CGFloat(i / count)
            // 列 -> X
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            
            // 让 imageView 能够接收用户交互
            iv.isUserInteractionEnabled = true
            // 添加手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            iv.addGestureRecognizer(tap)
            
            // 设置 iamgeView 的 tag
            iv.tag = i
            
            addSubview(iv)
        }
    }
}





