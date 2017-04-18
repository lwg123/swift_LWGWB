//
//  HomeViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/1/2.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    
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
        
        // 3.请求数据
        loadStatuses()
        
        // 添加下面属性，可以自己估算高度，自适应内容，需要在cell中的label中设置高度约束
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
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
}

// MARK:- 请求数据
extension HomeViewController {
    func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            // 错误校验
            if error != nil {
                print(error!)
                return
            }
            // 获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            // 遍历微博对应的字典
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
            }
            
            // 缓存图片
            self.cacheImages(viewModels: self.viewModels)
            
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
           // print("刷新表格")
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









