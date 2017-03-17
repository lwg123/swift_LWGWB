//
//  BaseViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/11.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    // MARK：- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    // MARK: - 定义变量
    var isLogin : Bool = false
    
    
    // MARK:- 系统回调函数
    override func loadView() {
        
        //1.从沙盒中读取归档的信息
        var  path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path = (path as NSString).strings(byAppendingPaths: ["account.plist"])[0] as String
        // 2 如果能读取到用户信息，并且日期不过期则直接登录，否则显示访客视图
        let account = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? UserAccount
        if let account = account {
            // 取出过期日期
            if let expiresDate = account.expires_date {
                isLogin = expiresDate.compare(Date()) == ComparisonResult.orderedDescending
            }
        }
        
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }

}

// MARK:- 设置UI界面
extension BaseViewController {
    fileprivate func setupVisitorView() {
        view = visitorView
        
        // 监听访客视图中`注册`和`登录`按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
    
    /// 设置导航栏左右的Item
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
    
    
}

// MARK:- 事件监听
extension BaseViewController {
    @objc fileprivate func registerBtnClick(){
         print("registerBtnClick")
    }
    
    @objc fileprivate func loginBtnClick(){
        let oauthVC = OAuthViewController()
        
        // 包装导航控制器
        let oathNav = UINavigationController(rootViewController: oauthVC)
        // 弹出控制器
        present(oathNav, animated: true, completion: nil)
        
    }
}






