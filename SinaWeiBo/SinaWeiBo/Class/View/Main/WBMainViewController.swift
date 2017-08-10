//
//  WBMainViewController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/10.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainViewController: UITabBarController {
    
    var jsonPath =  ""
    // 定时器
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        setupComposeButton()
        setupTimer()
        //设置新特性
        setupNewfeatureViews()
        
        // 设置代理
        delegate = self
        //注册通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userLogin),
            name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
            object: nil)
    }
    deinit {//销毁
        timer?.invalidate()
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
     portrait  :   竖屏
     landscape :   横屏
     
     - 使用代码控制方向，好处：可以在需要的时候控制屏幕横屏
     - 设置支持的方向之后,当前的控制器以及子控制器都会遵守这个方向
     - 如果播放视频，通常是通过model展现的
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - 监听方法
    func userLogin(n: Notification)  {
        print("用户登录通知")
        
        var when = DispatchTime.now()
        
        // 判断n.object 是否有值，如果有值，提示用户重新登录
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            
            //修改延迟时间
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //+号按钮
    func composeStatus() {
        print("点击事件")
        // 测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.cz_random()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 私有控件
    /// 撰写按钮
    lazy var composeButton: UIButton = UIButton.cz_imageButton(
        "tabbar_compose_icon_add",
        backgroundImageName: "tabbar_compose_button")
    
}
//extention 类似于oc的分类，在swift中还可以用来切分代码块
//可以把相近的功能的函数，房子啊一个etension中
//便于代码维护
//MARK: - 设置界面
extension WBMainViewController {
    
    //设置所有子控制器
    func setupChildControllers() {
        
        // 0: 获取沙盒json内容
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json");
        
        // 加载 data
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断 data 是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil {
            // 从 Bundle 加载 data
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        // data 一定会有一个内容，反序列化
        // 反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
            else {
                return
        }
        
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict as [String : AnyObject]))
        }
        viewControllers  = arrayM
    }
    //撰写按钮
    func setupComposeButton() {
        tabBar.addSubview(composeButton)
        //计算按钮的宽度
        let  count = CGFloat(childViewControllers.count)
        //将向内缩进的宽度
        let w = tabBar.bounds.width/count
        //CGRectInset 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        print("撰写按钮宽度 \(composeButton.bounds.width)")
        //监听事件
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    
    func controller(dict: [String: AnyObject]) -> UIViewController {
        
        //1.取出字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String: String]
            else {
                return UIViewController()
        }
        //2.创建视图控制器
        let vc = cls.init() as! WBBaseViewController
        vc.title = title
        // 设置控制器的访客信息
        vc.visitorInfoDictionary = visitorDict
        // 3. 设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        // 4.设置 tabbar 的字体颜色
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14)], for: UIControlState(rawValue: 0))
        
        let nav = WBNavigationController(rootViewController: vc);
        return nav
    }
}

//MARk: - UITabBarControllerDelegate
extension WBMainViewController: UITabBarControllerDelegate {
    /// 将要选择 TabBarItem
    ///
    /// - parameter tabBarController: tabBarController
    /// - parameter viewController:   目标控制器
    ///
    /// - returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //  1> 获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        //  2> 判断当前索引是首页，同时 idx 也是首页，重复点击首页的按钮
        if selectedIndex == 0 && idx == selectedIndex {
            print("点击首页")
            // 3> 让表格滚回到顶部
            // a) 获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            // b) 滚回顶部
            vc.tableview?.setContentOffset(CGPoint(x: 0, y:-64), animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
            // 5> 清除tabItem的badgeNumber
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        print("将要切换到\(viewController)")
        return !viewController.isMember(of: UIViewController.self)
    }
}
// MARK: - 新特性视图处理
extension WBMainViewController {
    // 设置新特性视图
    func setupNewfeatureViews() {
        // 0. 判断是否登录
        if !WBNetworkManager.shared.userLogon {
            return
        }
        // 1. 如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? WBNewFeatureView.featureView() : WBWelcomeView.welcomeView()
        // 2. 添加视图
        view.addSubview(v)
    }
    // extensions  中可以有计算型属性，不会占用存储空间
    // 构造函数： 给属性分配空间
    /**
     版本号
     -  在 AppStore 每次升级应用程序，版本号都需要增加，不能递减
     -  组成 主版本号，次版本号，修订版本号
     -  主版本号： 意味着大的修改，使用者也需要做大的适应
     -  次版本号： 意味着小的修改，某些函数和方法的使用或者参数的变化
     -  修订版本号： 框架/程序内部 bug 修订，不会对使用者造成任何的影响
     */
    private var isNewVersion: Bool {
        // 1. 取出当前的版本号 1.0.2
        // print(Bundle.main().infoDictionary)
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print("当前版本：" + currentVersion)
        
        // 2.取保存在’Document(iTunes备份)[最理想的用户偏好]‘ 目录中的之前的版本号 1.0.2
        let path:String = ("version" as NSString).cz_appendTempDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        print("沙盒版本" + sandboxVersion)
        
        // 3.将当前版本号保存在沙盒 1.0.2
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        // 4.返回两个版本号是否一致  not new
        // 小范测试
        //        return currentVersion == sandboxVersion
        return currentVersion != sandboxVersion
    }
}

//MARK: - 时钟相关方法
extension WBMainViewController {
    //定义时钟
    func setupTimer() {
        // 时间间隔建议时间长一些
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    //时钟触发方法
    func updateTime() {
        
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            print("监测到\(count)条新微博")
            // 设置首页taBarItem 的 badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count+1)":nil
            // 设置 App 的 badgeNumber，从 iOS 8.0 之后，要用户授权之后才能够显示
            UIApplication.shared.applicationIconBadgeNumber = count+4
        }
    }
}

