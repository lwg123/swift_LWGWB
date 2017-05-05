//
//  PicPickerViewCell.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/4.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addPhoneBtn: UIButton!
    @IBOutlet weak var removePhoneBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // 监听外界传过来的image值
    var image: UIImage? {
        didSet {
            if image != nil {
                // 直接在cell的image上设置图片
                imageView.image = image
                // 展示图片时，不让button点击
                addPhoneBtn.isUserInteractionEnabled = false
                // 展示删除按钮
                removePhoneBtn.isHidden = false
            }else {
                // 防止循环利用
                imageView.image = nil
                addPhoneBtn.isUserInteractionEnabled = true
                removePhoneBtn.isHidden = true
            }
        }
    }
    
   
    @IBAction func addPictureClick() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: addPicNotification), object: nil)
    }
    
    @IBAction func removePictureClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: removePicNotification), object: imageView.image)
    }

}
