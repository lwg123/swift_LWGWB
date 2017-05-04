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
    
    @IBOutlet weak var textView: ComposeTextView!
    
    // MARK：-toolBar的底部约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var pickerViewH: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func pickerBtnClick(_ sender: UIButton) {
        textView.resignFirstResponder()
        // 执行动画
        pickerViewH.constant = SCREEN_HEIGHT * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
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
    
    @objc fileprivate func keyboardWillChangeFrame(note: Notification) {
        // 获取键盘弹出的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 获取键盘最终y值坐标
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        // 计算工具栏距离底部间距
        let margin = SCREEN_HEIGHT - y
        
        // 执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    

}

// MARK：-UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}




