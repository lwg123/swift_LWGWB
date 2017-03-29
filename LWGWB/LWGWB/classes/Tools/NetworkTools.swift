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
    func request(methodType: RequestType, urlString: String, parameters: [String : Any], finshed: @escaping (_ reslut: Any?, _ error: Error?) -> ()) {
        
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
    func loadAccessToken(code: String, finshed: @escaping (_ result: [String : Any]?, _ error: NSError?) -> ()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_uri]
        request(methodType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            finshed(result as! [String : Any?],error as NSError?)
        }
    }

}

// MARK: - 请求用户信息
extension NetworkTools {
    func loadUserInfo(access_koen: String, uid: String, finshed: @escaping (_ result: [String : Any]?, _ error: Error?) -> ()) {
        // 1.获取请求URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        // 2. 获取请求参数,原文档缺少source
        let parameters = ["access_koen":access_koen, "uid":uid, "source":app_key]
        // 3. 发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            finshed(result as! [String : Any]?, error)
        }
    }
}





