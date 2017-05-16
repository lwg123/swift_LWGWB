//
//  PhotoBrowserController.swift
//  LWGWB
//
//  Created by weiguang on 2017/5/10.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

let PhotoBrowsercell = "PhotoBrowsercell"

class PhotoBrowserController: UIViewController {
    var indexPath: IndexPath
    var picURLs: [URL]
    
    
    lazy var colloctionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    
    var closeBtn = UIButton(bgColor: UIColor.lightGray, font: 14, title: "关 闭")
    var saveBtn = UIButton(bgColor: UIColor.lightGray, font: 14, title: "保 存")
    
    // 自定义构造函数
    init(indexPath: IndexPath, picURLs: [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 系统回调函数
//    override func loadView() {
    // 不能在此处更改view的bounds，此时获取的frame为0
//        view.bounds.size.width += 20
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame.size.width += 20  // 此处更改view的frame
        // 设置UI界面
        setupUI()
        
        // 滚动到对应的图片
        colloctionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }

    
}

extension PhotoBrowserController {
    // 1.设置UI
    fileprivate func setupUI() {
        view.addSubview(colloctionView)
       
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 设置button的约束
        colloctionView.frame = view.bounds
        closeBtn.snp_makeConstraints { (make) in
            _ = make.left.equalTo(20)
            _ = make.bottom.equalTo(-20)
            _ = make.size.equalTo(CGSize(width: 90, height: 32))
        }
        
        saveBtn.snp_makeConstraints { (make) in
            _ = make.right.equalTo(-40)
            _ = make.bottom.equalTo(closeBtn.snp_bottom)
            _ = make.size.equalTo(closeBtn.snp_size)
        }
        
        colloctionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowsercell)
        colloctionView.dataSource = self
        
        // 监听按钮的点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), for: .touchUpInside)
    }

}

// MARK： - 时间监听
extension PhotoBrowserController {
    @objc fileprivate func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClick() {
        // 1.获取当前正在显示的image
        let cell = colloctionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        // 2.将image对象保存在相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.savedPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    // 必须要实现上面这个函数的回调
    @objc fileprivate func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
    
}

extension PhotoBrowserController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colloctionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowsercell, for: indexPath) as! PhotoBrowserViewCell
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    

}

//PhotoBrowserViewCell代理方法
extension PhotoBrowserController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

// MARK: - 遵守AnimatorDismissDelegate
extension PhotoBrowserController : AnimatorDismissedDelegate {
    
    func indexPathForDismissView() -> IndexPath {
        let cell = colloctionView.visibleCells.first!
        return colloctionView.indexPath(for: cell)!
    }
    
    func imageViewForDismissView() -> UIImageView {
        let imageView = UIImageView()
        
        let cell = colloctionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
}



