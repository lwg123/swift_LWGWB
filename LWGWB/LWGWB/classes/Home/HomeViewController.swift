//
//  HomeViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh


class HomeViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    // 刷新提示label
    fileprivate lazy var tipLabel : UILabel = UILabel()
    
    fileprivate lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    var isNewData : Bool = false
    
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { (presented) -> () in
        self.titleBtn.isSelected = presented
    }
    
    lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        
        //2.设置导航栏的内容
        setupNavigationBar()
        
        
        // 3.添加下面属性，可以自己估算高度，自适应内容，需要在cell中的label中设置高度约束
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // 4.刷新控件header
        setupHeaderView()
        setupFooterView()
        
        setupTipLabel()
        
        setupNotifications()
    }

   
}

extension HomeViewController {
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        // 1.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //设置titleView
        titleBtn.setTitle("coderwhy", for: UIControlState())
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IBARevealRequestStop"), object: nil)
    }
    
    fileprivate func setupHeaderView() {
        // 1.创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        
        // 2.设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        
        // 3.设置tableView的header
        tableView.mj_header = header
        
        // 4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
    }
    
    fileprivate func setupTipLabel() {
        tipLabel = UILabel(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 32))
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.alpha = 0.0
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}

// MARK:- 事件监听的函数
extension HomeViewController {
    @objc fileprivate func titleBtnClick(_ titleBtn : TitleButton) {
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 2.设置控制器的modal样式,否则后面的view会隐藏掉
        popoverVc.modalPresentationStyle = .custom
        
        // 3.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 80, width: 180, height: 250)
        
        // 4.弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
    
    @objc fileprivate func showPhotoBrowser(note: Notification) {
        // 1.取出数据
        let indexPath = note.userInfo?[ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = note.userInfo?[ShowPhotoBrowserUrlsKey] as! [URL]
        let object = note.object as! PicCollectionView
        
        let photoBrowserVC = PhotoBrowserController(indexPath: indexPath, picURLs: picURLs)
        // 设置modal样式，否则后面的view会隐藏掉
        photoBrowserVC.modalPresentationStyle = .custom
        // 设置转场代理
        photoBrowserVC.transitioningDelegate = photoBrowserAnimator
        
        // 设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVC
        
        present(photoBrowserVC, animated: true, completion: nil)
    }
}

// MARK:- 请求数据
extension HomeViewController {
    /// 加载最新数据
    @objc fileprivate func loadNewStatuses() {
        
        loadStatuses(isNewDate: true)
    }
    
    /// 加载更多数据
    @objc fileprivate func loadMoreStatuses() {
        
        loadStatuses(isNewDate: false)
    
    }
    
    
    func loadStatuses(isNewDate: Bool) {
        
        // 1.获取since_id/max_id
        var since_id = 0
        var max_id = 0
        if isNewDate {
            since_id = viewModels.first?.status?.mid ?? 0
        }else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result: [[String : AnyObject]]?, error: Error?) in
            
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            // 3.遍历微博对应的字典
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            
            // 4.将数据放入成员变量的数组中
            if isNewDate {
                self.viewModels = tempViewModel + self.viewModels
            } else {
                self.viewModels += tempViewModel
            }
            self.isNewData = isNewDate
            
            // 5.缓存图片
            self.cacheImages(viewModels: tempViewModel)
        }
    }
    
    private func cacheImages(viewModels: [StatusViewModel]) {
        
        // 异步全部执行完之后再执行刷新表格的方法(这个方法要记录下来)
        // 创建group
        let  group = DispatchGroup.init()
        
        // 1.缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                
                group.enter() // 进入group
                
                SDWebImageManager.shared().downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                   // print("下载了一张图片")
                    
                    group.leave() //离开group
                })
            }
        }
        
        // 2.刷新表格，利用group.notify来刷新表格
        group.notify(queue: DispatchQueue.main) { 
            self.tableView.reloadData()
           
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 显示提示的label
            if self.isNewData {
                self.showTipLabel(count: viewModels.count)
            }
            
        }
        
    }
    
    /// 显示提示的label
    private func showTipLabel(count: Int) {

        self.tipLabel.alpha = 1.0
       tipLabel.text = count == 0 ? "没有新微博" : "更新\(count)条新微博"
       
        UIView.animate(withDuration: 1.0, animations: { 
             self.tipLabel.frame.origin.y = 44
            
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 10
                self.tipLabel.alpha = 0.0
            }, completion: { (_) in
                
            })
        }
    }
    
}

// MARK:- tableView的数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        
        // 给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
}









