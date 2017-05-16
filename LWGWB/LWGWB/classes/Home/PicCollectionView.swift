//
//  PicCollectionView.swift
//  LWGWB
//
//  Created by weiguang on 2017/4/13.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    // 定义属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    // 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }

}

extension PicCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        // 2. 给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picURLs] as [String : Any]
        
        // 2.发送通知,把object发送出去，成为代理
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}

extension PicCollectionView : AnimatorPresentedDelegate {
    func startRect(indexPath: IndexPath) -> CGRect {
        // 1.获取cell
        let cell = self.cellForItem(at: indexPath)!
        
        // 2.获取cell的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        // 1.获取该位置的image
        let picURL = picURLs[indexPath.item]
        
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)!
        
        // 计算结束后的frame
        let w = SCREEN_WIDTH
        let h = w / image.size.width * image.size.height
        var y : CGFloat = 0
        if h > SCREEN_HEIGHT {
            y = 0
        } else {
            y = (SCREEN_HEIGHT - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        
        // 2.获取该位置的image
        let picURL = picURLs[indexPath.item]
        
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)!
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    // mark: - 定义模型属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    // 控件属性
    @IBOutlet weak var iconView: UIImageView!
    
}
















