//
//  PicCollectionView.swift
//  LWGWB
//
//  Created by weiguang on 2017/4/13.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

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
    }

}

extension PicCollectionView : UICollectionViewDataSource {
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
















