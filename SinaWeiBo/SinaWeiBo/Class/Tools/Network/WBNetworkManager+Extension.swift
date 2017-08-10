//
//  WBNetworkManager+Extension.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/20.
//  Copyright © 2017年 Frank. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension WBNetworkManager{
    
    /// 加载微博数据字典数组
    /// - parameter since_id:   返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    /// - parameter max_id:     返回ID小于或等于max_id的微博，默认为0
    /// - parameter completion: 完成回调[list: 微博字典数组/是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, complete: @escaping (_ list: [[String: AnyObject]]?,_ isSUccess: Bool)->()){
        // 用网络工具，加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        // Swift 中 Int 可以转换成 AnyObject/ 但是 Int64 不行
        let params = ["since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        WBNetworkManager.shared.tokenRequest(URLString: urlString, parameters: params as [String : AnyObject] ) { (json, isSuccess) in
           // 从json中获取 statuses 字典数组
           // 如果 as？失败,result = nil
           // 提示： 服务器返回的字典数组，就是按照时间倒叙排序的
            let result = json?["statuses"] as? [[String: AnyObject]]
            complete(result, isSuccess)
       }
    }
    
    // 返回微博的未读数量 - 定时刷新，不需要提示是否失败
    func unreadCount(completion: @escaping (_ count: Int) -> ()) {
        guard let uid = userAccount.uid else {
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid": uid]
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
}
// MARK: - 用户信息
extension WBNetworkManager {
   //加载当前用户信息 - 用户登录后立即执行
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject]) -> ()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parms = ["uid": uid]
        
        //发起网络请求
        tokenRequest(URLString: urlString, parameters: parms as [String : AnyObject]) { (json, isSuccess) in
            //完成回调
            completion(json as? [String: AnyObject] ?? [:])
        }
    }
}

// MARK: - OAuth相关方法
extension WBNetworkManager {
   
    func loadaAccessToken(code: String, completion:@escaping ( _ isSuccess: Bool)->()){
        let urlString = "https://api.weibo.com/oauth2/access_token"

        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURL]
        //发起网络请求
        request(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            // 如果请求失败，对用户账户数据不会有任何影响
            // 直接用字典设置 userAccount 的属性
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
            // 加载当前用户信息
            self.loadUserInfo(completion: { (dict) in
            // 使用用户信息字典设置用户账户信息（昵称和头像地址）
                self.userAccount.yy_modelSet(with: dict)
                // 保存模型
                self.userAccount.savaAccount()
                
                completion(true)
            })
        }
    }
}

