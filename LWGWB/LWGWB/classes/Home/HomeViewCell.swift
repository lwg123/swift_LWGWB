//
//  HomeViewCell.swift
//  LWGWB
//
//  Created by weiguang on 2017/4/11.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verfiview: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var vipImg: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // 约束的属性
    @IBOutlet weak var contentWidthConstraints: NSLayoutConstraint!
    
    // 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else{
                return
            }
            
            // 设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            // 设置认证图标
            verfiview.image = viewModel.verfiedImage
            // 设置VIP图标
            vipImg.image = viewModel.vipImage
            screenName.text = viewModel.status?.user?.screen_name
            timeLabel.text = viewModel.createAtText
            sourceLabel.text = viewModel.sourceText
            contentLabel.text = viewModel.status?.text
            
            // 设置昵称文字颜色
            screenName.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文宽度 约束
        contentWidthConstraints.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }

   
}
