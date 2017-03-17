//
//  UserAccountTool.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/14.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class UserAccountTool {

    // MARK: - 计算属性获取路径
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).strings(byAppendingPaths: ["/account.plist"]).first!
    }
    
    init() {
        
    }
}
