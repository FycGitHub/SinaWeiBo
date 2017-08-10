//
//  WBBaseViewController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/10.
//  Copyright © 2017年 Frank. All rights reserved.
//  微博基类

import UIKit

//面试题： oc 中支持多继承吗？如果不支持，如何代替？使用协议代替
//swift: 的写法更类似于多继承！
//class WBBaseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

// 注意
// 1. extension  中不能有属性
// 2. extension  中不能重写父类方法！
class WBBaseViewController: UIViewController {
    // 访客视图信息字典
    var visitorInfoDictionary: [String: String]?
    //表格视图，如果没有登录就不创建
    var tableview: UITableView?
    // 刷新控件
    var refreshControl: UIRefreshControl?
    // 上拉加载
    var isPullup = false
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    //自定义导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
    }
    override var title: String? {
        didSet {
          navItem.title = title
          //注销通知
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    //请求数据，由子类完成
    func loadData()  {
        refreshControl?.endRefreshing()
    }
}


// MARK: -  访客视图监听方法
extension WBBaseViewController {
    
    //登录成功处理
    @objc func loginSuccess(n: Notification) {
        
        // 登录前左边是注册，右边是登录
       navItem.leftBarButtonItem = nil
       navItem.rightBarButtonItem = nil
        
       print("登录成功\(n)")
        //更新UI =》 将访客视图替换为表格视图
        // 需要跟新设置 view  viewDidLoad 会重新走一遍
        view = nil
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func login() {
        print("用户登录")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    @objc func register() {
        print("注册按钮")
    }
}

extension WBBaseViewController {
   func setupUI() {
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进20个点
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        setupNavigationBar()
    
        WBNetworkManager.shared.userLogon ? setUpTableView() : setVisitorView()
    }
    //设置表格视图
    func setUpTableView() {
        tableview = UITableView(frame: view.bounds, style: .plain)
        //将tableview  放到navigationBar下面
        tableview?.delegate = self
        tableview?.dataSource = self
        view.insertSubview(tableview!, belowSubview: navigationBar)
        //设置内容缩进
        tableview?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height,
                                               left: 0,
                                               bottom: tabBarController?.tabBar.bounds.height ?? 49,
                                               right: 0)
        // 设置刷新控件
        // 1> 实例化控件
        refreshControl = UIRefreshControl()
        // 2> 添加到表格视图
        tableview?.addSubview(refreshControl!)
        // 3> 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    //设置访客视图
    func setVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        //1. 设置访客信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        //天机访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        //3. 设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        // 添加导航条
        view.addSubview(navigationBar)
        // 将 item 设置给 bar
        navigationBar.items = [navItem]
        // 1> 设置 navBar 整个背景的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        // 2> 设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        // 3> 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
}

// MARK: - UITableViewDelegate
extension WBBaseViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1. 判断indexPath 是否是最后一行
        // (indexPath.section最大) / indexPath.row(最后一行)
        // 1> row
        let row = indexPath.row
        // 2> section
        let section = (tableview?.numberOfSections)! - 1
        
        if row < 0 || section < 0 {
            return
        }
        // 3> 行数
        let count = tableview?.numberOfRows(inSection: section)
        //如果是最后一行，同时没有开始上啦刷新
        if  row == (count! - 1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            //开始刷新
            loadData()
        }
    }
}
