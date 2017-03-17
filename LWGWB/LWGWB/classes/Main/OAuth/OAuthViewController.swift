//
//  OAuthViewController.swift
//  LWGWB
//
//  Created by weiguang on 2017/3/6.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    // MARK: - 控件的属性
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.MARK: - 设置导航栏
        setupNavigationBar()
        
        // 2.MARK: - 加载网页
        loadPage()
        
    }

}

// MARK: - 设置UI界面
extension OAuthViewController {
    func setupNavigationBar() {
        //1.设置左右侧item和title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        title = "登录页面"
    }
    
    func loadPage() {
        // 获取URL地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        // 创建URL
        guard let url = NSURL(string: urlString) else {
            return
        }
        //
        let request = NSURLRequest(url: url as URL)
        webView.loadRequest(request as URLRequest)
    }
}

// MARK: - 事件监听函数
extension OAuthViewController {
    @objc func closeItemClick() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func fillItemClick() {
        // 写JS代码
        let jsCode = "document.getElementById('userId').value = '656442711@qq.com';document.getElementById('passwd').value = 'lwgWY0925';"
        // 执行js代码
        webView .stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK: - webView的delegate
extension OAuthViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1.获取加载网页的url
        guard let url = request.url else {
            return true
        }
        // 2.获取URL中的字符串
        let urlStr = url.absoluteString
        //print(urlStr)
        // 3.判断该字符串中是否包含code
        guard urlStr.contains("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlStr.components(separatedBy: "code=").last!
        
       // print(code)
        loadAcessToken(code: code)
        
        return false
    }
}

// MARK: - 请求参数
extension OAuthViewController {
    //请求acesstoken
    func loadAcessToken(code: String) {
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            if error != nil {
                print(error!)
                return
            }
            // 字典转模型
            let account = UserAccount(dict: result)
            
            // 请求用户信息
            self.loadUserInfo(account: account)
            
        }
    }
    
    // 用户请求信息
    func loadUserInfo(account: UserAccount) {
        // 获取access_koen
        guard let access_koen = account.access_token else {
            return
        }
        // 获取uid
        guard let uid = account.uid else {
            return
        }
        
        NetworkTools.shareInstance.loadUserInfo(access_koen: access_koen, uid: uid) { (result, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let infoDict = result else {
                return
            }
            account.avatar_large = infoDict["avatar_large"] as? String
            account.screen_name = infoDict["screen_name"] as? String
            
            // 获取路径
            var  path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            path = (path as NSString).strings(byAppendingPaths: ["account.plist"])[0] as String
            
            // 保存account对象
            NSKeyedArchiver.archiveRootObject(account, toFile: path)
        }
    }

}









