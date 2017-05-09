//
//  EmotionManager.swift
//  表情键盘
//
//  Created by weiguang on 2017/5/8.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class EmotionManager {
    var packages: [EmotionPackage] = [EmotionPackage]()
    
    init() {
        // 1、添加最近表情的包
        packages.append(EmotionPackage(id: ""))
        
        // 2、添加默认表情的包
        packages.append(EmotionPackage(id: "com.sina.default"))
        
        // 3、添加emoji表情的包
        packages.append(EmotionPackage(id: "com.apple.emoji"))
        
        // 4、添加浪小花表情的包
        packages.append(EmotionPackage(id: "com.sina.lxh"))
    }
}
