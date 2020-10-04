//
//  FetchService.swift
//  FetchRewards
//
//  Created by Royce Reynolds on 10/3/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

class FetchService: NSObject{
    
    let session = URLSession.shared
        
        
    func getDataMethod(completionHandlerforGET: @escaping (_ result: [Int:[ListId]], _ error: Error?)  -> Void) -> URLSessionDataTask{
            
            //let apiParameters = parameters
        let emptyResult = [Int:[ListId]]()
            
            let request = URLRequest(url: URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json")!)
            
            //Get data from URL
            let task = session.dataTask(with: request) { (data, response, error) in
                guard (error == nil) else{
                    completionHandlerforGET(emptyResult, error)
                    return
                }
                
                //Check for return code
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else{
                    completionHandlerforGET(emptyResult, error)
                    return
                }
                
                //Unwrap data
                guard let data = data else{
                    completionHandlerforGET(emptyResult, error)
                    return
                }
                
                //Convert Data to JSON and parse
                self.convertDataWithCompletionHandler(data) { (result, error) in
                    if let error = error{
                        completionHandlerforGET(emptyResult, error)
                    }else{
                        guard let result = result else {return}
                        completionHandlerforGET(ListId.parseListIdJSON(result), nil)
                    }
                }
                
            }
            
            task.resume()
            
            return task
            
        }
        
        // given raw JSON, return a usable Foundation object
        private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: Error?)  -> Void) {
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandlerForConvertData(nil, error)
            }
            completionHandlerForConvertData(parsedResult, nil)
        }
        
    //Singleton for Network calls
        class func sharedInstance() -> FetchService {
            struct Singleton {
                static var sharedInstance = FetchService()
            }
            return Singleton.sharedInstance
        }
}
