//
//  AppDelegate.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultViewController: UIViewController? {
       let islogin = UserAccountViewModel.shareInstance.isLogin
        return islogin ? WelcomViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        // 创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

