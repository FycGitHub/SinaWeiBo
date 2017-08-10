//
//  WBStatusListViewModel.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/23.
//  Copyright © 2017年 Frank. All rights reserved.
//

import Foundation

//  微博数据列表模型

/*
 - 如果累需要使用‘KVC’ 或者字典转模型框架设置对象值，类就需要继承自NSObject
 - 如果累只是包装一些代码逻辑（写了一些函数），可以不用任何父类  好处：更加轻量级
 - 提示：如果用 oc 写，一律都继承NSObject即可
 
 使命: 负责微博的数据处理
 1: 字典转模型
 2: 下拉/上拉刷新数据处理
 */

///设置上拉的最大次数
let maxPullupTryTimes  = 3

class WBStatusListViewModel {
    // 微博模型数组懒加载
    lazy var statusList = [WBStatusViewModel]()
    // 上拉刷新错误次数
    var pullupErrors = 0
    
    /// - parameter pullup:     是否上拉刷新标记
    // - parameter completion: 完成回调（网络请求回调）
    func loadStatus(pullup: Bool, completion: @escaping (Bool,_ shouldRefresh:Bool) -> ()) {
        
        // 判断是否上拉刷新,同时检查刷新错误
        if pullup && pullupErrors > maxPullupTryTimes {
            completion(true, false)
        }
        
        // since_id 取出数组中第一条数据的id
        // since_id 取出数组中第一条微博的 id
        let since_id = pullup ? 0 : (self.statusList.first?.status.id ?? 0)
        // 上拉刷新，取出数组的最后一条微博的 id
        let max_id = !pullup ? 0 : (self.statusList.last?.status.id ?? 0)
        
        // 让数据访问层加载数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 0. 如果网络请求失败，直接执行完成回调
            if !isSuccess {
                completion(false, false)
                return
            }
            // 1. 遍历字典数组，字典转 模型 => 视图模型，将视图模型添加到数组
            var  array = [WBStatusViewModel]()
            
            for dict in list ?? [] {
               // 1>  创建微博模型
               let  status = WBStatus()
               // 2>  使用字典设置模型数值
               status.yy_modelSet(with: dict)
               // 3>  使用 ‘微博’ 模型创建  ‘微博视图’ 模型
               let viewModel = WBStatusViewModel(model: status)
               // 4> 添加到数组
               array.append(viewModel)
            }
            
            // 视图模型创建完成
            print("刷新到\(array.count) 条数据 \(array)")
            // 2. 拼接资源
            if pullup {
               // 上拉刷新结束后，将结果拼接在数组的末尾
                self.statusList += array
            } else {
               // 下拉刷新，应该将结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            // 3.判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrors += 1
                
                completion(isSuccess, false)
            } else {
                completion(isSuccess, true)
            }
          
        }
    }
}
