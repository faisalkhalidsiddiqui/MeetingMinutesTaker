//
//  PDFViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/27/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class PDFViewLoaderController: UIViewController,UIWebViewDelegate {
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var printButton: UIBarButtonItem!
    @IBAction func printDoc(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.printButton.isEnabled = false
            self.activityIndicator.startAnimating()
        }
        
        NetworkReachability.isNetworkConnected(){ error,data in
            
            DispatchQueue.main.async {
                
                self.printButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
            if let error = error {
                
                let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default){ action in
                    
                    self.dismiss(animated: false, completion: nil)
                }
                controller.addAction(ok)
                DispatchQueue.main.async {
                    self.present(controller, animated: false, completion: nil)
                }
                
            }
            if let data = data {
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "printerviewcontroller") as! PrinterViewController
                controller.content = self.html.toBase64()
                self.present(controller, animated: true, completion: nil)
                
                
                
            }
            
        }

        
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   /*
        if let pathStr = pathStr {
                print(pathStr)
            var path  = URL(fileURLWithPath: pathStr)
             print(path)
            
            DispatchQueue.main.async {
              
                let printController = UIPrintInteractionController.shared
                let printInfo = UIPrintInfo(dictionary:nil)
                printInfo.outputType = UIPrintInfoOutputType.general
                printInfo.jobName = "report"
                printInfo.duplex = UIPrintInfoDuplex.none
                printInfo.orientation = UIPrintInfoOrientation.portrait
                
                //New stuff
                printController.printPageRenderer = nil
                printController.printingItems = nil
                printController.printFormatter = self.webview.viewPrintFormatter()
                //New stuff
                
                printController.printInfo = printInfo
                printController.showsPageRange = true
                printController.showsNumberOfCopies = true
                
                printController.present(animated: false, completionHandler: nil)
            }
            
        }
 

    }
  */
    @IBOutlet weak var webview: UIWebView!
    var meeting:MTMeeting?
    
    var pathStr:String?
    
var html = ""
 
    var report:Report?
    override func viewDidLoad() {
        
        webview.delegate = self
        super.viewDidLoad()
        report = Report(meetingRecord: meeting!)
        self.webview.scrollView.isPagingEnabled = true
        
        self.webview.paginationMode = .topToBottom
        self.webview.paginationBreakingMode = .page
        
        
        html = report!.generateHTML()
       
        webview.loadHTMLString(html, baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.stringByEvaluatingJavaScript(from: "document.readyState") == "complete" {
            print("readty")
            let render = UIPrintPageRenderer()
            
            render.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
            
            // 3. Assign paperRect and printableRect
            
            let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
            
            let printable = page.insetBy(dx: 0, dy: 0)
            
            
            
            render.setValue(NSValue(cgRect: page), forKey: "paperRect")
            
            render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
            
            
            
            // 4. Create PDF context and draw
            
            let pdfData = NSMutableData()
            
            UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
            
            
            
            for i in 1...render.numberOfPages {
                
                
                
                UIGraphicsBeginPDFPage();
                
                let bounds = UIGraphicsGetPDFContextBounds()
                
                render.drawPage(at: i - 1, in: bounds)
                
            }
            
            
            
            UIGraphicsEndPDFContext();
            
            
            
            // 5. Save PDF file
            
            let path = "\(NSTemporaryDirectory())file.pdf"
            print(path)
            pdfData.write(toFile: path, atomically: true)
            
            
            
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
