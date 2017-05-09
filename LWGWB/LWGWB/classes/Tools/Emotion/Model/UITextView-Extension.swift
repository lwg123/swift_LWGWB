//
//  UITextView-Extension.swift
//  表情键盘
//
//  Created by weiguang on 2017/5/8.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

extension UITextView {
    
    // 获取TextView属性字符串，对应的表情字符串
    func getEmotionString() -> String {
        // 获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        // 遍历属性字符串
        let range = NSRange(location: 0, length: attrMStr.length)
        
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        // 获取字符串
        return attrMStr.string
    }
    
    // 给TextView插入表情
    func insertEmotion(emotion: Emotion) {
        // 1.空白表情
        if emotion.isEmpty {
            return
        }
        
        // 2.删除表情
        if emotion.isRemove {
            deleteBackward()
            return
        }
        
        // 3.emoji表情
        if emotion.emojiCode != nil {
            // 获取光标所在的位置
            let textRange = selectedTextRange!
            
            // 替换emoji表情
            replace(textRange, withText: emotion.emojiCode!)
            return
        }
        
        // 4.普通表情,图文混排
        // 4.1 根据图片路径创建属性字符串
        let attchment = EmotionAttachment()
        attchment.chs = emotion.chs
        attchment.image = UIImage(contentsOfFile: emotion.pngPath!)
        // 修改图片大小与行高一致
        let font = self.font!
        attchment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attchment)
        
        // 4.2 创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 4.3 将图片替换到适当位置
        // 获取光标位置
        let range = selectedRange
        
        // 替换属性字符串
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        // 显示属性字符串
        attributedText = attrMStr
        
        // 将文字大小设为原值，否则会变小(注意坑)
        self.font = font
        
        // 将光标设置为原来位置 + 1，否则会跳到文字最后 (注意坑)
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
