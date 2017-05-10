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
          setupURL(picURL: picURL)
            
        }
    }
    
    // MARK: - 懒加载属性
     lazy var scrollView: UIScrollView = UIScrollView()
     lazy var imageView: UIImageView = UIImageView()
     lazy var progressView: ProgressView = ProgressView()
    
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
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        // 设置子控件frame
        scrollView.frame = contentView.bounds
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: SCREEN_HEIGHT * 0.5)
        
        // 设置控件属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.red
    }
}

extension PhotoBrowserViewCell {
    fileprivate func setupURL(picURL: URL?) {
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
        
        // 设置大图
        imageView.sd_setImage(with: getBigURL(smallURL: picURL), placeholderImage: image, options: [], progress: { (current, total) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    fileprivate func getBigURL(smallURL: URL) -> URL {
        let smallURLString = smallURL.absoluteString
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigURLString)!
    }
}




