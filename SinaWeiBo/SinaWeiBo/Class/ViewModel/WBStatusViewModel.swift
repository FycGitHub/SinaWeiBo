//
//  WBStatusViewModel.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/8/4.
//  Copyright © 2017年 Frank. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
/**
   如果没有任何父类，如果在开发的时候调试，输出信息，需要
   1. 遵守 CustomStringConvertible
   2. 实现 description 计算型属性
 
   关于表格的性能优化
   
   -  尽量少计算，所有需要的素材提前计算好！
   -  控件上不要设置圆角半径，所有的图像渲染的属性，都要注意！
   -  不要动态创建控件，所有需要的控件，都要提前创建好，在显示的时候，根据数据隐蔽/显示！
   -  Cell  中控件的层次越少越好，数量越少越好！
   -  要测量，不要猜测！
 */

class WBStatusViewModel: CustomStringConvertible {
    
    // 微博模型
    var status: WBStatus
    
    /// 会员图标 - 存储型属性(用内存换 CPU)
    var memberIcon: UIImage?
    /// 认证类型 -1:没有认证，0:认证用户  2,3,4: 企业认证  220:达人
    var vipIcon: UIImage?
    /// 转发文字
    var retweetedStr: String?
    /// 评论文字
    var commentStr: String?
    /// 点赞文字
    var likeStr: String?
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    //如果是被转发的微博，原创微博一定没有图
//    var picURLs: [WBStatusPicture]? {
         // 如果有被转发的微博，返回被转发微博的配图
         // 如果没有被转发的微博，返回原创微博的配图
         // 如果都没有，返回 nil
//        return status.retweeted_status?.pic_urls ?? status.pic_urls
//    }
    
    
    init(model: WBStatus) {
        self.status = model
        
        // 直接结算处会员图标/会员等级 0 - 6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        // 认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        // 设置底部计数字符串
        // 测试超过一万的数字
        // model.reposts_count = Int(arc4random_uniform(100000))
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        pictureViewSize = calcPictureViewSize(count: model.pic_urls?.count)
    }
    
    func calcPictureViewSize(count: Int?) -> CGSize {
        if count == 0 || count == nil {
            return CGSize(width: WBStatusPictureViewWidth, height: 1)
        }
        //  1> 根据count 知道行数 1 ~ 9
        let row  = (count! - 1) / 3 + 1
        //  2> 根据行数算高度
        var height  =  WBStatusPictureViewOutterMargin
            height +=  CGFloat(row) * WBStatusPictureItemWidth
            height +=  CGFloat(row - 1) * WBStatusPictureViewInnerMargin
    
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    
    /// 给定义一个数字，返回对应的描述结果
    ///
    /// - parameter count:      数字
    /// - parameter defaultStr: 默认字符串，转发／评论／赞
    ///
    /// - returns: 描述结果
    /**
     如果数量 == 0，显示默认标题
     如果数量超过 10000，显示 x.xx 万
     如果数量 < 10000，显示实际数字
     */
    func countString(count: Int,defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    var description: String {
        return status.description
    }
    
}








