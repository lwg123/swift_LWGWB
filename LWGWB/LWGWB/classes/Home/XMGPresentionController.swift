//
//  XMGPresentionController.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class XMGPresentionController: UIPresentationController {

    // MARK: - 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    // MARK: - 懒加载
    fileprivate lazy var coverView : UIView = UIView()
    
    //系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //1.设置弹出view的尺寸
        presentedView?.frame = presentedFrame
        
        //2.添加蒙版
        setupCoverView()
    }
    
}

// MARK:- 设置UI界面相关
extension XMGPresentionController {

    fileprivate func setupCoverView() {
        //1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        //2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        //3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(XMGPresentionController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
        
    }
}

// MARK:- 事件监听
extension XMGPresentionController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
