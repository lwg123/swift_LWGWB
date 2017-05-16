//
//  ComposeTextView.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/3.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {

    lazy var placeHolderLabel: UILabel = UILabel()
    
    // 自定义控件，如果需要添加子控件，一般在这个方法中进行
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // 如果需要初始化子控件，或者对子控件进行布局在此方法中进行
    override func awakeFromNib() {
        
    }

}

extension ComposeTextView {
    fileprivate func setupUI() {
        addSubview(placeHolderLabel)
        placeHolderLabel.snp_makeConstraints { (make) in
            _ = make.top.equalTo(8)
            _ = make.left.equalTo(10)
            
            placeHolderLabel.textColor = UIColor.lightGray
            placeHolderLabel.font = font
            placeHolderLabel.text = "分享新鲜事..."
            textContainerInset = UIEdgeInsetsMake(8, 7, 0, 7)
        }
    }
}
