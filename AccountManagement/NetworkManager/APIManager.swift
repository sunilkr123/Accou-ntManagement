//
//  APIManager.swift
//  NetworkManagerDemo
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import Foundation
import Alamofire
import SVProgressHUD

protocol APIManager: NetworkHttpClient {
    func performGetOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)
    
    func performPostOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)
    
    func performPutOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)
    
    func performDeleteOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)
    
    func getAllRunningTasksEndPoints(completionHandler: @escaping ([String]) -> Void)
    
    func cancelTask(with key: String, completion: @escaping () -> Void)
}

extension APIManager {
    
    func performGetOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.shared.isReachable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        guard let url = URL(string: endPoint) else {
            completionHandler(.failure(APIError(type: .invalidURL)))
            return
        }
        displayLoader(showHUD, show: true)
        printLog("endPoint -> \(endPoint)", "parameters -> \(parameters)", "headers -> \(headers)")
        callRestAPIWith(url, httpMethod: .get, parameters: parameters, headers: headers) { (response) in
            self.displayLoader(showHUD, show: false)
            self.parseResponse(response, completionHandler: completionHandler)
        }
    }
    
    func performPostOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.shared.isReachable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        guard let url = URL(string: endPoint) else {
            completionHandler(.failure(APIError(type: .invalidURL)))
            return
        }
        displayLoader(showHUD, show: true)
        printLog("endPoint -> \(endPoint)", "parameters -> \(parameters)", "headers -> \(headers)")
        callRestAPIWith(url, httpMethod: .post, parameters: parameters, headers: headers) { (response) in
            self.displayLoader(showHUD, show: false)
            self.parseResponse(response, completionHandler: completionHandler)
        }
    }
    
    func performPutOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.shared.isReachable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        guard let url = URL(string: endPoint) else {
            completionHandler(.failure(APIError(type: .invalidURL)))
            return
        }
        displayLoader(showHUD, show: true)
        printLog("endPoint -> \(endPoint)", "parameters -> \(parameters)", "headers -> \(headers)")
        callRestAPIWith(url, httpMethod: .put, parameters: parameters, headers: headers) { (response) in
            self.displayLoader(showHUD, show: false)
            self.parseResponse(response, completionHandler: completionHandler)
        }
    }
    
    func performDeleteOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.shared.isReachable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        guard let url = URL(string: endPoint) else {
            completionHandler(.failure(APIError(type: .invalidURL)))
            return
        }
        displayLoader(showHUD, show: true)
        printLog("endPoint -> \(endPoint)", "parameters -> \(parameters)", "headers -> \(headers)")
        callRestAPIWith(url, httpMethod: .delete, parameters: parameters, headers: headers) { (response) in
            self.displayLoader(showHUD, show: false)
            self.parseResponse(response, completionHandler: completionHandler)
        }
    }
    
    // MARK: - End Point Operations
    
    func getAllRunningTasksEndPoints(completionHandler: @escaping ([String]) -> Void) {
        getAllRunningTasks { (tasks) in
            let taskEndPoints = tasks.compactMap({ $0.originalRequest?.url?.absoluteString })
            completionHandler(taskEndPoints)
        }
    }
    
    func cancelTask(with key: String, completion: @escaping () -> Void) {
        getAllRunningTasks { (tasks) in
            for task in tasks {
                if let url = task.originalRequest?.url?.absoluteString {
                    if url.contains(key) {
                        task.cancel()
                        completion()
                        return
                    }
                }
            }
            completion()
        }
    }
    // MARK: - Parsing
    func parseResponse(_ response: HttpClientResponse, completionHandler: @escaping APIResponseBlock) {
        if let data = response.data, data.count > 0 {
            if let dictResponse = data.dictionary {
                printLog("response -> \(dictResponse)", "url -> \(String(describing: response.url))", "statusCode -> \(response.statusCode)")
                if 200...299 ~= response.statusCode {
                    let successResponse = APISuccess(json: dictResponse, headers: response.headers, url: response.url)
                    completionHandler(.success(successResponse))
                } else {
                    let error = APIError(with: nil, statusCode: response.statusCode, info: dictResponse)
                    completionHandler(.failure(error))
                }
            }  else {
                printLog("response -> invalidJSON", "url -> \(String(describing: response.url))", "statusCode -> \(response.statusCode)")
                completionHandler(.failure(APIError(type: .invalidJSON)))
            }
        } else if let error = response.error {
            var apiError = APIError(with: error, statusCode: response.statusCode)
            let nsError = error as NSError
            if nsError.code == NSURLErrorCancelled {
                printLog("api cancelled")
                apiError.message = ""
            }
            printLog("error -> \(apiError.message)", "url -> \(String(describing: response.url))", "statusCode -> \(response.statusCode)")
            completionHandler(.failure(apiError))
        } else if response.data == nil {
            printLog("error -> noData", "url -> \(String(describing: response.url))", "statusCode -> \(response.statusCode)")
            completionHandler(.failure(APIError(type: .noData)))
        } else if let data = response.data, let stringData = String(data: data, encoding: .utf8), stringData.count > 0 {
            printLog("response -> \(stringData)", "url -> \(String(describing: response.url))", "statusCode -> \(response.statusCode)")
            let apiError = APIError(message: stringData, type: APIErrorType.customAPIError, statusCode: response.statusCode)
            completionHandler(.failure(apiError))
        } else {
            printLog("error -> invalidResponse", "url -> \(String(describing: response.url))", "statusCode -> \(response.statusCode)")
            completionHandler(.failure(APIError(type: .invalidResponse)))
        }
    }
    // MARK: - Loading-
    func displayLoader(_ shouldDisplay: Bool, show: Bool) {
        if shouldDisplay {
            if show {
                // display loader
                presentIndicator()
            } else {
                // hide loader
                dismissIndicator()
            }
        }
    }
    // MARK: - Logs-
    func printLog(_ values: Any...) {
        if Constant.isDebugingEnabled {
            _ = values.map({ print($0) })
        }
    }
    //MARK:-Loader Function
    func dismissIndicator() {
        DispatchQueue.main.async {
            // wasProgresss
            AppDelegate.appDelegate().window?.isUserInteractionEnabled = true
            // KRProgressHUD.dismiss()
            SVProgressHUD.dismiss()
        }
    }
    //Present Loader
    func presentIndicator() {
        DispatchQueue.main.async {
            AppDelegate.appDelegate().window?.isUserInteractionEnabled = false
            //  HUDCustomized = true
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.setBackgroundLayerColor(UIColor(white: 0, alpha: 0.5))
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.setBackgroundColor(.clear)
            SVProgressHUD.show()
            //KRProgressHUD.show()
        }
    }
    
}

//Alamofire
class APIManagerWithImage{
    
    static public func uploadImage(strUrl:String,para:[String:Any],image:UIImage,imageName:String, showIndicator:Bool,succes:@escaping (Bool,String)->Void,Failler:@escaping(_ error:Error)->Void) {
        let completeURl = strUrl
          SVProgressHUD.show()
        print(para)
        print(completeURl)
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            if let imagedata = UIImageJPEGRepresentation(image, 0.5){
                let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
                let someInt:Int = Int(randomNum)
                MultipartFormData.append(imagedata, withName: imageName,fileName: "\(someInt)"+".png", mimeType: "image/png")
            }
            // import parameters
            for (key, value) in para {
                let stringValue = value as! String
                MultipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
            }
        }, usingThreshold:.max, to:completeURl, method: .post, headers: nil){ encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
          
                 SVProgressHUD.dismiss()
                upload.responseJSON
                    {
                        response in
                   
                        switch response.result
                        {
                        case .success:
                     
                            do {
                                let dictionary = try JSONSerialization.jsonObject(with:response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                var errorCode = 0
                                var message = ""
                                if let error_Code = dictionary["error_code"] as? Int{
                                    errorCode = error_Code
                                }
                                if let messages = dictionary["message"] as? String{
                                    message = messages
                                }
                                // Session Expire
                                if errorCode == 100 || errorCode == 101{
                             
                                    succes(true,message)
                                }else{
                                    succes(false,message)
                                }
                            
                            }catch{
                                let error : Error = response.result.error!
                                let str = String(decoding: response.data!, as: UTF8.self)
                                print("PHP ERROR : \(str)")
                                Failler(error)
                              
                            }
                        case .failure(let error):
                            let responseString:String = String(data: response.data!, encoding: String.Encoding.utf8)!
                            print(responseString)
                            Failler(error)
                             SVProgressHUD.dismiss()
                        
                        }
                }
            case .failure(let encodingError):
           
                 SVProgressHUD.dismiss()
                print(encodingError)
            }
        }
    }
}

