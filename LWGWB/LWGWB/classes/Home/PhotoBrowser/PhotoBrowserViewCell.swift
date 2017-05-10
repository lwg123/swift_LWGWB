//
//  PhotoBrowserViewCell.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/10.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserViewCell: UICollectionViewCell {
    // MARK: - 定义属性
    var picURL: URL? {
        
        didSet {
            guard let picURL = picURL else {
                return
            }
            // 取出image对象
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)!
            
            // 计算imageView的frame
            let width = SCREEN_WIDTH
            let height = width / image.size.width * image.size.height
            var y: CGFloat = 0
            if height > SCREEN_HEIGHT {
                y = 0
            } else {
                y = (SCREEN_HEIGHT - height) * 0.5
            }
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            
            imageView.image = image
        }
    }
    
    // MARK: - 懒加载属性
     lazy var scrollView: UIScrollView = UIScrollView()
     lazy var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PhotoBrowserViewCell {
    //
    fileprivate func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
        
    }
}




