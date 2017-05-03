//
//  ComposeViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    lazy var titleView: ComposeTitleView = ComposeTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigation()
    }

   
}

extension ComposeViewController {
    fileprivate func setupNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}

// 事件监听
extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClick() {
        print("发送")
    }

}






