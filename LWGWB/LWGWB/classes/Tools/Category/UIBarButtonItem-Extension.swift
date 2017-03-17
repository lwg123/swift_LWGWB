//
//  UIBarButtonItem-Extension.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/12.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName : String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
}
