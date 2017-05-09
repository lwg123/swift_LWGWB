//
//  EmotionController.swift
//  表情键盘
//
//  Created by weiguang on 2017/5/5.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit

let EmotionCell = "EmotionCell"

class EmotionController: UIViewController {
    
    var emotionCallback: (_ emotion: Emotion) -> ()

    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: EmotionCollectionLayout())
    lazy var toolBar: UIToolbar = UIToolbar()
    lazy var manager = EmotionManager()
    
    init(emotionCallback: @escaping (_ emotion: Emotion) -> ()) {
        
        self.emotionCallback = emotionCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }

}

// 设置UI界面
extension EmotionController {
    fileprivate func setupUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purple
        toolBar.backgroundColor = UIColor.gray
        
        // 设置子控件的frame，利用VFL创建约束,必须先关闭AutoresizingMask属性
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        // 对应的views
        let views = ["tbar" : toolBar, "cView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tbar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tbar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        // 准备CollectionView
        prepareForCollectionView()
        //准备ToolBar
        prepareForToolBar()
    }
    
    fileprivate func prepareForCollectionView() {
        // 1.注册cell和设置数据源
        collectionView.register(EmotionViewCell.self, forCellWithReuseIdentifier: EmotionCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func prepareForToolBar() {
        // 1.定义 titles
        let titles = ["最近","默认","emoji","浪小花"]
        
        // 2.遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for itemTiele in titles {
            let item = UIBarButtonItem(title: itemTiele, style: .plain, target: self, action: #selector(EmotionController.itemClick(item:)))
            item.tag = index
            index = index + 1
            
            tempItems.append(item)
            // 添加弹簧，增加间距
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 3.设置tooBar的items
        tempItems.removeLast()  // 删除最后一个弹簧
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
    @objc func itemClick(item: UIBarButtonItem) {
        let tag = item.tag
        
        // 根据tag获取到当前组
        let indexPath = IndexPath(item: 0, section: tag)
        
        // 滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
}

extension EmotionController : UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        
        return package.emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell, for: indexPath) as! EmotionViewCell
    
        // 2.给cell设置数据
        let package = manager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
        cell.emotion = emotion
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.取出点击的cell
        let package = manager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
        
        // 2.将点击的表情插入最近分组中
        insertRecetlyEmotion(emotion: emotion)
        
        // 3.将表情回调出去
        emotionCallback(emotion)
    }
    
    func insertRecetlyEmotion(emotion: Emotion) {
        // 1.如果是删除标签和空白表情不需要插入
        if emotion.isEmpty || emotion.isRemove {
            return
        }
        
        // 2.删除一个表情
        if manager.packages.first!.emotions.contains(emotion) { // 包含该表情
           let index = (manager.packages.first?.emotions.index(of: emotion))!
            manager.packages.first?.emotions.remove(at: index)
        } else { // 不包含
            manager.packages.first!.emotions.remove(at: 19)
        }
        
        // 3.将emotion插入最近分组中
        manager.packages.first?.emotions.insert(emotion, at: 0)
    }
}

// 自定义layout
class EmotionCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        // 计算itemH
        let itemH = UIScreen.main.bounds.width / 7
        
        // 设置layout的属性
        itemSize = CGSize(width: itemH, height: itemH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        // 设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        let insertMargin = (collectionView!.bounds.height - 3 * itemH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insertMargin, left: 0, bottom: insertMargin, right: 0)
    }
}








