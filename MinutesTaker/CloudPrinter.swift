//
//  CloudPrinter.swift
//  GoogleCloudPrint
//
//  Created by faisal khalid on 31/03/2017.
//  Copyright © 2017 faisal khalid. All rights reserved.
//

import UIKit

class CloudPrinter: NSObject {
    var xsrf:String?
    init(token:String) {
        self.token = token
    }
    var token = ""
    var printers:[Printer]?
    
   
    
    func generateXSRFToken(completionHandler:(error:Error?,token:String?)) {
        var request = URLRequest(url: URL(string: "http://www.google.com/cloudprint/xsrf")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                print(jsonResponse)
                
                
                if let jsonResponse = jsonResponse {
                    let xsrf = jsonResponse["xsrf_token"] as! String
                    print(xsrf)
                }
                    
                else {
                    print("error parsong")
                }
                
            }
            catch{
                print("error json parsing")
            }
            
        }
        
        task.resume()
    }

    func submitJob(printerID:String,contentType:String, title:String, content:String,encoding:String?,completionHandler:@escaping (Error?,String?)->()){
        var request = URLRequest(url: URL(string: "https://www.google.com/cloudprint/submit?xrsf=\(xsrf!)&printerid=\(printerID)")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
      
        
        let boundary = "------CloudPrintFormBoundary7vwoha8mhgp6"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        
         var body = Data();
        
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"ticket\"\r\n\r\n".utf8))
        body.append(Data("{\"version\": \"1.0\", \"print\": {\"margins\":{\"top_microns\" : 42000, \"right_microns\" : 13000, \"left_microns\" : 13000, \"bottom_microns\" : 20000}}}\r\n".utf8))
        
        
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"contentType\"\r\n\r\n".utf8))
        body.append(Data("\(contentType)\r\n".utf8))

        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"title\"\r\n\r\n".utf8))
        body.append(Data("\(title)\r\n".utf8))
        
        
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"content\"\r\n\r\n".utf8))
        body.append(Data("\(content)\r\n".utf8))
        
        if let encoding = encoding {
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"contentTransferEncoding\"\r\n\r\n".utf8))
        body.append(Data("\(encoding)\r\n".utf8))
        }
         body.append(Data("--\(boundary)\r\n".utf8))
        
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            if let data = data {
            print(data.base64EncodedString(options: .endLineWithCarriageReturn))
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    if let message = jsonResponse["message"] as? String {
                    completionHandler(nil, message)
                        
                    }
                    
                    
                    
                    
                }
                catch {
                    completionHandler(error,nil)
                   print("error submiting job")
                }
            }
            else {
            
                completionHandler(error,nil)

                print("error submiting job")
            }
        }
        task.resume()
        
        
    
    
    }
    func getPrinters(completionHandler:@escaping (Error?,[Printer]?)->()) {
        var request = URLRequest(url: URL(string: "https://www.google.com/cloudprint/search")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            
            if error != nil {
                completionHandler(error,nil)
                
            }
            
            do{
                
                
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            
                
                if let printersInfo = jsonResponse["printers"] as? NSArray {
                var printers:[Printer] = []
                for p in printersInfo {
                
                    var p = p as! [String:Any]
                    
                    printers.append((Printer(name: p["displayName"] as! String, id: p["id"] as! String, status: p["connectionStatus"] as! String)))
                    
                    
               
                }
           
                
                self.xsrf = jsonResponse["xsrf_token"] as? String
                completionHandler(nil,printers)

                }
            }
            catch{
                print(error.localizedDescription)
                completionHandler(error,nil)

            }
            
        }
        
        task.resume()
    }

}

protocol GIDSignInFailedDelegate {
    func onSignInFailed()
}
