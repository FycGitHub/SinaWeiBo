//
//  WBHomeViewController.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/7/10.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

//定义全局常量，尽量使用private
private let cellId = "cellId"

class WBHomeViewController: WBBaseViewController {
    
    // 列表视图模型
    lazy var listViewModel = WBStatusListViewModel()
    //加载数据
    override func loadData() {
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess,shouldRefresh) in
            //结束刷新控件
            self.refreshControl?.endRefreshing()
            //恢复上拉加载
            self.isPullup = false
            if shouldRefresh {
                //刷新表格
                self.tableview?.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func showFriend() {
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 表格数据方法
extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.取cell
        let cell = tableview?.dequeueReusableCell(withIdentifier: cellId) as! WBStatusCell
        //2.设置cell
        let vm = listViewModel.statusList[indexPath.row]
        
        cell.viewModel = vm
    
        
        //3.返回cell
        return cell;
    }
}
extension WBHomeViewController {
    
    override func setUpTableView() {
        super.setUpTableView()
        //设置导航栏
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFriend), isBack: false)
        
        // 注册原型cell
        tableview?.register(UINib.init(nibName: "WBStatusNormalCell", bundle: nil) , forCellReuseIdentifier: cellId)

        // 设置行高
        tableview?.rowHeight = UITableViewAutomaticDimension
        tableview?.estimatedRowHeight = 300
        
        // 取消分割线
        tableview?.separatorStyle = .none
        
        // 设置导航栏标题
        setupNavTitle()
    }
    
    //设置导航栏标题
    private func setupNavTitle() {
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(onclickTitleButton(btn:)), for: .touchUpInside)
    }
    
    @objc func onclickTitleButton(btn: UIButton) {
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
}

