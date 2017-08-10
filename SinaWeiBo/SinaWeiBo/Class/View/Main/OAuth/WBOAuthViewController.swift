//
//  WBOAuthViewController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/26.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过 webView 加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {
    
    lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        
        // 取消滚动视图 - 新浪微博的服务器，返回的授权页面默认就是手机全屏
        webView.scrollView.isScrollEnabled = false
        
        // 设置代理
        webView.delegate = self as? UIWebViewDelegate
        
        //设置导航栏
        title = "登录新浪微博"
        //导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURL)"
        
        // 1> URL 确定要访问的资源
        guard let url = URL(string: urlString) else {
            return
        }
        // 2> 建立请求
        let request = URLRequest(url: url)
        
        // 3> 加载请求
        webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - 监听方法
    /// 关闭控制器
    func close() {
        
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    //  自动填充 - WebView 的注入，直接通过js 修改本地浏览器中 缓存的页面内容
    //  点击登录按钮，执行 submit（） 将本地数据提交给服务器！
    func autoFill() {
        
        // 准备js
        let js = "document.getElementById('userId').value = '1614413846@qq.com'; " +
        "document.getElementById('passwd').value = '*chaoFyc1943ren*';"
        
        //让 webView 执行 js
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension WBOAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 确认思路：
        // 1. 如果请求地址包含 http://baidu.com 不加载页面 ／ 否则加载页面
        // request.url?.absoluteString?.hasPrefix(WBRedirectURI) 返回的是可选项 true/false/nil
        if request.url?.absoluteString.hasPrefix(WBRedirectURL) == false {
            return true
        }
        
        // print("加载请求 --- \(request.url?.absoluteString)")
        // query 就是 URL 中 `?` 后面的所有部分
        // print("加载请求 --- \(request.url?.query)")
        // 2. 从 http://baidu.com 回调地址的`查询字符串`中查找 `code=`
        //    如果有，授权成功，否则，授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        // 3. 从 query 字符串中取出 授权码
        // 代码走到此处，url 中一定有 查询字符串，并且 包含 `code=`
        // code=15be12d79321e474c599210ef637c978
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("授权码 - \(code)")
        // 4. 使用授权码获取[换区] AccessToken
        WBNetworkManager.shared.loadaAccessToken(code: code) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                // 下一步做什么？跳转`界面` 通过通知发送登录成功消息
                // 1> 发送通知 - 不关心有没有监听者
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
                
                // 2> 关闭窗口
                self.close()
            }
        }
        print("加载请求 --- \(String(describing: request.url?.absoluteString))")
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

