//
//  UserAccountTool.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/14.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class UserAccountViewModel {

    // 将类设计成单例
    static let shareInstance: UserAccountViewModel = UserAccountViewModel()
    
    // 定义属性
    var account: UserAccount?
    
    // MARK: - 计算属性获取路径
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).strings(byAppendingPaths: ["/account.plist"]).first!
    }
    
    var isLogin: Bool {
        if account == nil {
            return false
        }
        
        guard (account?.expires_date) != nil else {
            return false
        }
        
        return account?.expires_date!.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    init() {
        // 1.从沙盒中读取中归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
