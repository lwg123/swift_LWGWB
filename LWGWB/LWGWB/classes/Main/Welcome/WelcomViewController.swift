//
//  WelcomViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/29.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomViewController: UIViewController {
    
    // MARK:- 拖线的属性
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 设置头像
        let profileURLString = UserAccountViewModel.shareInstance.account?.avatar_large
        let url = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        // 1.改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 250
        // 2.执行动画
        // Damping : 阻力系数,阻力系数越大,弹动的效果越不明显 0~1
        // initialSpringVelocity : 初始化速度
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        
    }


}
