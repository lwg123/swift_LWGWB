//
//  NSDate-Extension.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/30.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import Foundation

extension Date {
    static func createDateString(_ createAtStr: String) -> String {
        // 1.创建时间格式化对象
        let fmt = DateFormatter()
        // 时间格式：星期：EEE 月份：MM 天：dd 时分秒：HH：mm：ss 时区：Z 年份：yyyy
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        // 2.将字符串时间，转成NSDate类型
        guard let createDate = fmt.date(from: createAtStr) else {
            return ""
        }
        // 3.创建当前时间
        let nowDate = Date()
        // 4.计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        // 5.对时间间隔处理
        // 5.1 显示刚刚
        if interval < 60 {
            return "刚刚"
        }
        
        // 5.2 59分钟前
        if interval < 60 * 60 {
            return "\(interval/60)分钟前"
        }
        
        // 5.3 11小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        // 5.4 创建日历对象
        let calender = Calendar.current
        
        // 5.5 处理昨天数据： 昨天 12：23
        if calender.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        // 5.6 处理一年之内： 02-22 12：22
        let cmps = calender.dateComponents([.year], from: createDate, to: nowDate)
        // 拆分date取出年
//        let dateComponents = calender.dateComponents([.year,.month, .day, .hour,.minute,.second], from: createDate, to: nowDate)
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        // 5.7 超过一年：2014-02-12 13：22
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
        
        
    }
}
