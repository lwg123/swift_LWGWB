//
//  Status.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/29.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    var created_at: String?      // 微博创建时间
    var source: String?          // 微博来源
    var text: String?             // 微博的正文
    var mid: Int = 0             // 微博的ID
    
    // MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
