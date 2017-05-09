//
//  Emotion.swift
//  表情键盘
//
//  Created by weiguang on 2017/5/8.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class Emotion: NSObject {
    // 定义属性
    // emoji的code,转换为表情格式
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            
            // 1.创建扫描器
            let scanner = Scanner(string: code)
            // 2.调用方法，扫描出code的值
            var value: UInt32 = 0
            scanner.scanHexInt32(&value)
            // 3.将value转换为字符
            let c = Character(UnicodeScalar(value)!)
            // 4.将字符转成字符串
            emojiCode = String(c)
            
        }
    }
    // 普通表情
    var png: String? {
        didSet {
            guard let png = png else {
                return
            }
            // 拼接图片路径才能用
         pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
            
        }
    }
    var chs: String?
    
    var pngPath: String?
    
    var emojiCode: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    init(dict: [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    init(isRemove: Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 打印出表情
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath", "chs"]).description
    }
}
