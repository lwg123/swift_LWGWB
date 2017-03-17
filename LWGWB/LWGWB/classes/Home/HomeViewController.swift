//
//  HomeViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { (presented) -> () in
        self.titleBtn.isSelected = presented
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        
        //2.设置导航栏的内容
        setupNavigationBar()
    }

   
}

extension HomeViewController {
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        // 1.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //设置titleView
        titleBtn.setTitle("coderwhy", for: UIControlState())
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
}

// MARK:- 事件监听的函数
extension HomeViewController {
    @objc fileprivate func titleBtnClick(_ titleBtn : TitleButton) {
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 2.设置控制器的modal样式,否则后面的view会隐藏掉
        popoverVc.modalPresentationStyle = .custom
        
        // 3.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 80, width: 180, height: 250)
        
        // 4.弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}






