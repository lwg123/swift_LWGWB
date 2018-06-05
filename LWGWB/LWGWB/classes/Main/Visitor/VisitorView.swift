//
//  VisitorView.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/11.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit


class VisitorView: UIView {

    //MARK：- 提供快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)!.first as! VisitorView
    }
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK - 自定义函数
    func setupVisitorViewInfo(_ iconName: String, title: String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    func addRotationAnim() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false   //否则退出之后再进来就会停止转动
        
        // 3.将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
    
    
}
