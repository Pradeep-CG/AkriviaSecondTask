//
//  HttpUtility.swift
//  AkriviaSecondTask
//
//  Created by Pradeep on 17/07/20.
//  Copyright © 2020 Pradeep. All rights reserved.
//

import Foundation

struct HttpUtility{
    
    func getApiData<T:Decodable>(requestUrl:String,resultType: T.Type, completionHandler:@escaping(_ result:T) -> Void) {
        
        
        if Common.verifyUrl(urlString: requestUrl) {
            
            let requestApiUrl = URL(string: requestUrl)!
            URLSession.shared.dataTask(with: requestApiUrl) { (responseData, httpUrlResponse, error) in
                
                if(error == nil && httpUrlResponse != nil && responseData?.count != 0){
                    
                    let response = String(data: responseData!, encoding: .utf8)
                    debugPrint("response = \(response!)")
                    
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(T.self, from: responseData!)
                        _=completionHandler(result)
                        
                    } catch let error {
                        debugPrint("error occured while decoding = \(error.localizedDescription)")
                    }
                }
            }
            .resume()
        }
    }
}
