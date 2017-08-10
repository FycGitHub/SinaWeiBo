//
//  WeiBoCommon.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/26.
//  Copyright © 2017年 Frank. All rights reserved.
//

import Foundation

// MARK: - 应用程序信息
// 应用程序 ID
let WBAppKey = "2437820114"
// 应用程加密信息（开发者可以申请修改）
let WBAppSecret = "f69dfd485bfb6f272a92d63ef533f4c5"
// 回调地址 - 登录完成跳转的 URL 参数以 get 形式拼接
let WBRedirectURL = "https://www.baidu.com"

// MARK: - 全局通知定义
/// 用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
/// 用户登录成功通知
let WBUserLoginSuccessedNotification = "WBUserLoginSuccessedNotification"

// MARK: - 微博配图视图
//  1. 计算配图视图的宽度
let WBStatusPictureViewOutterMargin = CGFloat(12)
//  配图视图内部视图间距
let WBStatusPictureViewInnerMargin = CGFloat(3)
//  屏幕的宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * WBStatusPictureViewOutterMargin
//  每个Item 默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3
//  计算高度

