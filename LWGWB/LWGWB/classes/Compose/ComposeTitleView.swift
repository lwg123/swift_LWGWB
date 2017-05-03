//
//  ComposeTitleView.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    lazy var titleLabel: UILabel = UILabel()
    lazy var screenNameLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ComposeTitleView {
    fileprivate func setupUI(){
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //设置frame
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
    
}





