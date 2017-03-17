//
//  UserAccount.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/10.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

// UserAccount要实现归档，必须实现NSCoding协议，并实现下面的两个方法
class UserAccount: NSObject ,NSCoding{
    // 属性
    var access_token: String?
    // 过期时间：秒
    var expires_in: TimeInterval = 0 {
        // 属性监听器,把秒转换为日期
        didSet{
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    // 用户id
    var uid: String?
    // 过期日期
    var expires_date: Date?
    
    // 昵称
    var screen_name: String?
    // 头像
    var avatar_large: String?
    
    // 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    // 重写此方法可以使 不需要转模型的key去掉
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","screen_name","avatar_large"]).description
    }
    
    // MARK: - 归档&解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}









