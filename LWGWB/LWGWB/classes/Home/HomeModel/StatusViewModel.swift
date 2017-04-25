//
//  StatusViewModel.swift
//  LWGWB
//
//  Created by weiguang on 2017/4/11.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    // MARK： - 定义属性
    var status : Status?
    
    // MARK： - 对数据处理属性
    var sourceText: String?         // 处理来源
    var createAtText: String?       // 处理创建时间
    var verfiedImage : UIImage?     // 处理用户认证图标
    var vipImage : UIImage?         // 处理用户会员等级
    var profileURL : URL?           // 处理用户头像的地址
    var picURLs : [URL] = [URL]()   // 处理微博配图的数据
    
    
    // MARK： - 自定义构造函数
    init(status: Status) {
        self.status = status
        
        // 1.对微博来源处理
        if let source = status.source, source != "" {
            // 1.1.获取起始位置和截取的长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            // 1.2.截取字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        // 2. 处理时间
        if let created_at = status.created_at {
            //对时间处理
            createAtText = Date.createDateString(createAtStr: created_at)
        }
        
        // 3.处理认证
        let verified_type = status.user?.verified_type ?? -1
        
        switch verified_type {
        case 0:
            verfiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verfiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verfiedImage = UIImage(named: "avatar_grassroot")
        default:
            verfiedImage = nil
        }
        
        // 4. 处理会员等级
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 5.处理头像url
        let profileURLStr = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLStr)
        
        // 6. 处理微博图片
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts{
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
    
}
