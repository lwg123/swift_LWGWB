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
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verfiview: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var vipImg: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picCollectionView: PicCollectionView!
    
    // 约束的属性
    @IBOutlet weak var contentWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedCons: NSLayoutConstraint!
    
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
    
            contentLabel.text = viewModel.status?.text
            
            // 设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自" + sourceText
            } else{
                sourceLabel.text = nil
            }
            
            
            // 设置昵称文字颜色
            screenName.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            // 计算picView的宽度和高度
            let picViewSize = calculatePicViewSize(viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            // picView的picURL传过去
            picCollectionView.picURLs = viewModel.picURLs
            
            // 设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.user?.screen_name,let retweetedText = viewModel.status?.retweeted_status?.text {
                    
                    retweetedContentLabel.text = "@" + "\(screenName)" + retweetedText
                    
                    // 设置转发正文距离顶部的约束
                    retweetedCons.constant = 15
                }
                // 设置背景显示
                bgView.isHidden = false
                
            } else {
                retweetedContentLabel.text = nil
                
                // 设置背景显示
                bgView.isHidden = true
                
                // 设置转发正文距离顶部的约束
                retweetedCons.constant = 0
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文宽度 约束
        contentWidthConstraints.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    
    }

}

// MARK: - 计算方法
extension HomeViewCell {
     func calculatePicViewSize(_ count: Int) -> CGSize {
        // 1. 没有配图
        if count == 0 {
            // 无配图，该约束为0
           picViewBottomCons.constant = 0
           return CGSize(width: 0.0, height: 0.0)
        }
        // 有配图，有约束
        picViewBottomCons.constant = 10
        // 取出picView对应的layout
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 单张配图
        if count == 1 {
            // 1.取出图片
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: viewModel?.picURLs.last?.absoluteString)
    
            // 设置一张图片的layout
            layout.itemSize = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
            return CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
        }
        
        // 设置其他张图片的layout
        let imageViewH = (SCREEN_WIDTH - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewH, height: imageViewH)
        
        // 2. 计算出来一张图片的长宽，并且长宽是相等的 imageViewWH
        let imageViewWH = (SCREEN_WIDTH - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 3. 四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 4. 其他张配图
        // 4.1 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 4.2 计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 4.3 计算picView的宽度
        let picViewW = SCREEN_WIDTH - 2 * edgeMargin
        
        return CGSize(width: picViewH, height: picViewW)
    }
}








