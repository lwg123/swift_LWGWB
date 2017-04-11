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
    // 微博创建时间
    var created_at: String? {
        didSet {
            guard let created_at = created_at else {
                return
            }
            //对时间处理
            createAtText = Date.createDateString(createAtStr: created_at)
        }
    }
    // 微博来源
    var source: String? {
        didSet {
            // 1. nil值校验
            guard let source = source, source != "" else {
                return
            }
            
            // 2. 对来源的字符串进行处理
            // 2.1.获取起始位置和截取的长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            // 2.2.截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
    }
    var text: String?             // 微博的正文
    var mid: Int = 0             // 微博的ID
    var user : User?
    
    // MARK:- 对数据处理的属性
    var sourceText: String?
    var createAtText: String?
    
    // MARK:- 自定义构造函数
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
        // 1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
