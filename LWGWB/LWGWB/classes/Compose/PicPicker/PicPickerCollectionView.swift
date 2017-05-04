//
//  PicPickerCollectionView.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/4.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"

private let margin: CGFloat = 15

class PicPickerCollectionView: UICollectionView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemH = (SCREEN_WIDTH - 4 * margin) / 3
        layout.itemSize = CGSize(width: itemH, height: itemH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        register(UINib.init(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        
        dataSource = self
        
        // 设置内边距
        contentInset = UIEdgeInsetsMake(margin, margin, 0, margin)
        
    }
}


extension PicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath)
        
        cell.backgroundColor = UIColor.red
        
        return cell
    }
}
