//
//  NetworkTools.swift
//  AFNetworking封装
//
//  Created by weiguang on 2017/3/5.
//  Copyright © 2017年 weiguang. All rights reserved.
//

import AFNetworking

// 定义枚举类型 
// 可以使用String类型也可以用Int
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    //let 是线程安全的,创建单例
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

// MARK:- 封装请求方法
extension NetworkTools {
    func request(_ methodType: RequestType, urlString: String, parameters: [String : Any], finshed: @escaping (_ reslut: Any?, _ error: Error?) -> ()) {
        
        // 1.定义成功的闭包
        let successCallBack = { (task: URLSessionDataTask, result: Any?) in
            finshed(result, nil)
        }
        
        // 2.定义失败的闭包
        let failureCallBack = { (task:URLSessionDataTask?, error: Error) in
            finshed(nil, error)
        }
        
        // 3.发送网络请求
        if methodType == .GET {
            get(urlString, parameters: parameters, progress: nil, success:successCallBack, failure: failureCallBack)
        } else {
            post(urlString, parameters: parameters, progress: nil, success:successCallBack,failure: failureCallBack)
        }
    }
}

// MARK: - 请求AcessToken
extension NetworkTools {
    func loadAccessToken(_ code: String, finshed: @escaping (_ result: [String : Any]?, _ error: NSError?) -> ()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_uri]
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) in
            finshed(result as! [String : Any?],error as NSError?)
        }
    }

}

// MARK: - 请求用户信息
extension NetworkTools {
    func loadUserInfo(_ access_koen: String, uid: String, finshed: @escaping (_ result: [String : Any]?, _ error: Error?) -> ()) {
        // 1.获取请求URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        // 2. 获取请求参数,原文档缺少source
        let parameters = ["access_koen":access_koen, "uid":uid, "source":app_key]
        // 3. 发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) in
            finshed(result as! [String : Any]?, error)
        }
    }
}

// MARK: - 请求首页数据
extension NetworkTools {
    func loadStatuses(since_id: Int, max_id: Int, _ finished: @escaping (_ result: [[String : AnyObject]]?, _ error: Error?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        // 3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            // 1.获取字典的数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            
            // 2.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as! [[String : AnyObject]]?, error)
        }
        
    }
}

// MARK: - 发送微博
extension NetworkTools {
    func sendStatus(statusText: String, isSuccess: @escaping (_ isSucess: Bool) -> ()) {
        // 1.获取请求urlString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        // 2.获取参数列表
        let parameters = ["access_token" : UserAccountViewModel.shareInstance.account?.access_token, "status" : statusText]
        // 3.发送请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
        
    }
}

// MARK: - 发送带图片的微博
extension NetworkTools {
    func sendStatus(statusText: String, image: UIImage, isSuccess: @escaping (_ isSucess: Bool) -> ()) {
        // 1.获取请求urlString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        // 2.获取参数列表
        let parameters = ["access_token" : UserAccountViewModel.shareInstance.account?.access_token, "status" : statusText]
        
        // 3.发送请求
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (_, _) in
            isSuccess(true)
        }) { (_, error) in
            print(error)
        }
    }
}




