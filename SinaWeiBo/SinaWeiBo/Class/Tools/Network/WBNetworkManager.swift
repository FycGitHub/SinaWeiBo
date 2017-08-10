//
//  WBNetworkManager.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/20.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit
import AFNetworking

// swift 的枚举支持任意类型
// swift / enum 在OC中只是支持整数
enum WBHTTPMethod {
    case  GET
    case  POST
}
/**
 - 如果日常开发中，发现网络请求返回的状态码是 405，不支持的网络请求方法
 - 首先应该查找网路请求方法是否正确
 */

class WBNetworkManager: AFHTTPSessionManager {
   
    //静态区 / 常量 /闭包
    // 在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared: WBNetworkManager = {
        // 实例化对象
        let instance = WBNetworkManager()
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        // 返回对象
        return instance
    }()
    // 访问令牌，所有网络请求，都基于此令牌
    
    // 用户账户的懒加载属性
    lazy var userAccount  = WBUserAccount()
    
    // 用户登录标记【计算型属性】
    var userLogon: Bool {
       return userAccount.access_token != nil
    }
    
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completed: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        // 处理 token
        // 0>  判断token是否为nil  为nil直接返回 直接返回，程序执行中一般不会为nil
        guard userAccount.access_token != nil else {
            print("没有登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            completed(nil, false)
            return
        }
        // 1> 判断字典是否存在，如果为nil 应该创建一个子弹
        var parameters = parameters
        if parameters == nil {
            //实例化字典
            parameters = [String: AnyObject]()
        }
        // 2>设置参数字典，代码在此处字典一定有值
        parameters?["access_token"] = userAccount.access_token as AnyObject
        
        request(URLString: URLString, parameters: parameters, completed: completed)
    }
    
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completed: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        /// 定义成功回调闭包
        let success = { (task: URLSessionDataTask,json: Any?)->() in
            completed(json as AnyObject?,true)
        }
        
        /// 定义失败回调闭包
        let failure = {(task: URLSessionDataTask?, error: Error)->() in
            
            if(task?.response as? HTTPURLResponse)?.statusCode == 403 {
              print("token 过期了")
               // FIXME: 发送通知，提示用户再次登录（本方法不知道被调用，谁接受通知，谁处理）
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "bad token")
            }
            completed(nil,false)
        }
        
        /// 通过请求方法,执行不同的请求
        // 如果是 GET 请求
        if method == .GET { // GET
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else { // POST
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
