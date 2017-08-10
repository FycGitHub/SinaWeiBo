//
//  WBStatus.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/23.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit
import YYModel

class WBStatus: NSObject {
    // Int 类型,在64位的机器是64位，在32位机器就是32位
    // 如果不写Int64在ipad 2、iphone 5/5c/4S/4 都无法正常运行
    var id:Int64 = 0
    // 微博内容
    var text: String?
    
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 点赞数
    var attitudes_count: Int = 0
    
    //／ 微博用户
    var user: WBUser?
    
    /// 微博配图模型数组
    var pic_urls: [WBStatusPicture]?
    
    
    //微博创建时间字符串
    var created_at: String? {
        didSet {
            //  createDate = Date.cz_singDate(String: created_at ?? "")
        }
    }
    // 微博创建日期
    var createDate: Data?
    
    //重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    /// 类函数 -> 告诉第三方框架 YY_Model 如果遇到数组类型的属性，数组中存放的对象是什么类？
    /// NSArray 中保存对象的类型通常是 `id` 类型
    /// OC 中的泛型是 Swift 推出后，苹果为了兼容给 OC 增加的
    /// 从运行时角度，仍然不知道数组中应该存放什么类型的对象
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": WBStatusPicture.self]
    }
    
}
