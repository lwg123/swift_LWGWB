//
//  FindEmotion.swift
//  正则表达式
//
//  Created by weiguang on 2017/5/9.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class FindEmotion: NSObject {
    lazy var manager: EmotionManager = EmotionManager()
    
    // 设计单例模式
    static let shareInstance: FindEmotion = FindEmotion()
    
    // 查找属性字符串的方法
    func findAttributeString(statusText: String, font: UIFont) -> NSMutableAttributedString? {
        
        let pattern = "\\[.*?\\]" // 匹配表情
        // 2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        // 3.匹配字符串中内容
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        // 4. 遍历数组，获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        
        // 此处要用反向遍历
        for (_,result) in results.enumerated().reversed() {
            
            // 4.1 获取chs
            let chs = ((statusText as NSString).substring(with: result.range))
            
            // 4.2 根据chs，获取图片路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            
            // 4.3 创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            // 4.4 字符串替换
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }

        
        return attrMStr
    }
    
    fileprivate func findPngPath(chs: String) -> String? {
        for package in manager.packages {
            for emotion in package.emotions {
                if emotion.chs == chs {
                    return emotion.pngPath
                }
            }
        }
        return nil
    }
}
