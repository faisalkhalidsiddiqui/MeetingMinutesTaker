//
//  NetworkReachability.swift
//  GoogleCloudPrint
//
//  Created by faisal khalid on 4/4/17.
//  Copyright © 2017 faisal khalid. All rights reserved.
//

import UIKit

class NetworkReachability: NSObject {

    static func isNetworkConnected(completionHandler:@escaping (_ error:Error?,_ data:Data?)->Void){
        
        
        var request = URLRequest(url: URL(string: "https://www.facebook.com")!)
        let task = URLSession.shared.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
            print(error)
            }
          completionHandler(error, data)
        }
        task.resume()
    }
    
    
    
}
