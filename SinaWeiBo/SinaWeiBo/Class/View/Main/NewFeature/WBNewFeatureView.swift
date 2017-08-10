//
//  WBNewFeatureView.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/8/2.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    //进入微博
    @IBAction func enterStatus(_ sender: Any) {
        removeFromSuperview()
    }
    
    class func featureView()-> WBNewFeatureView {
        let nib  = UINib(nibName: "WBNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        //从XIB加载的视图，默认图片是600*600
        v.frame = UIScreen.main.bounds
        return v
    }
    //从XIB加载完成调用
    override func awakeFromNib() {
        // 如果使用自动布局设置的东西，从XIB假爱默认是 600 * 600
        // 添加4个视图
        let count = 4
        let  rect = UIScreen.main.bounds
    
        for i in 0..<count {
            let imageName = "new_feature_\(i + 1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
        }
        
        //指定scrollView的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = self as! UIScrollViewDelegate
        
        //隐藏按钮
        enterButton.isHidden = true
    }
    
}

extension WBNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 1. 滚动到最后一屏，让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        // 2. 判断是否最后一页
        if page == scrollView.subviews.count {
            print("欢迎欢迎，热泪欢迎！！！")
            removeFromSuperview()
        }
        
        // 3. 如果是倒数第2页，显示按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0 一旦滚动隐藏按钮
        enterButton.isHidden = true
        
        //1.计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        //2.设置分页控件
        pageControl.currentPage = page
        
        //3. 分页控件的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }

}



