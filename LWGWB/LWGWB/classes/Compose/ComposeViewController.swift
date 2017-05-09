//
//  ComposeViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    lazy var titleView: ComposeTitleView = ComposeTitleView()
    
    var images: [UIImage] = [UIImage]()
    
    @IBOutlet weak var textView: ComposeTextView!
    
    // MARK：-toolBar的底部约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var pickerViewH: NSLayoutConstraint!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    lazy var emotonVC: EmotionController = EmotionController {[weak self] (emotion) in
        self!.textView.insertEmotion(emotion: emotion)
        // 只插入表情时不会主动触发textViewDidChange这个代理方法，需要自己手动调用一下
        self?.textViewDidChange(self!.textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPictureClick), name: NSNotification.Name(rawValue: addPicNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.removePictureClick(note:)), name: NSNotification.Name(rawValue: removePicNotification), object: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if picPickerView.dataImages.count == 0 {
             textView.becomeFirstResponder()
        }
       
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
    
    @IBAction func emotionBtnClick() {
        // 1.退出键盘
        textView.resignFirstResponder()
        // 2.切换键盘
        textView.inputView = textView.inputView != nil ? nil : emotonVC.view
        // 3.弹出键盘
        textView.becomeFirstResponder()
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
        
        textView.resignFirstResponder()
        // 获取微博正文
        let statusText = textView.getEmotionString()
        
        //调用接口发送微博
        NetworkTools.shareInstance.sendStatus(statusText: statusText) { (isSucess) in
            if !isSucess {
                SVProgressHUD.showError(withStatus: "发送微博失败！")
            }
            
            SVProgressHUD.showSuccess(withStatus: "发送微博成功！")
            self.dismiss(animated: true, completion: nil)
        }
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

extension ComposeViewController {

    // 添加照片
    @objc fileprivate func addPictureClick() {
        // 1.判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        // 2.创建照片选择器
        let ipc = UIImagePickerController()
        // 3.设置照片源
        ipc.sourceType = .photoLibrary
        // 4.设置代理
        ipc.delegate = self
        
        ipc.allowsEditing = true
        // 5.弹出控制器
        present(ipc, animated: true, completion: nil)
        
    }
    
    // 删除照片
    @objc fileprivate func removePictureClick(note: Notification) {
        // 1.获取image对象
        guard let image = note.object as? UIImage  else {
            return
        }
        // 2.获取image对象所在的下标
        guard let index = images.index(of: image) else {
            return
        }
        // 3.将图片从数组中删除
        images.remove(at: index)
        // 4.重新赋值
        picPickerView.dataImages = images
    }

}

// MARK:UIImagePickerController代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        images.append(image)
        // 将数组赋给collectionView自己去展示数据
        picPickerView.dataImages = images
        
        // 退出选中照片控制器
        picker.dismiss(animated: true, completion: nil)
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




