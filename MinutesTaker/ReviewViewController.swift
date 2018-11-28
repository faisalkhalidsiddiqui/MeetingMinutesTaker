//
//  ReviewViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 4/3/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    var currentMeeting:MTMeeting?
     @IBOutlet weak var pdfWebView: UIWebView!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
        if let currentMeeting = currentMeeting {
            
            let report = Report(meetingRecord: currentMeeting)
           pdfWebView.loadHTMLString(report.generateHTML(), baseURL: nil)
            pdfWebView.layer.borderColor = UIColor.black.cgColor
            pdfWebView.layer.masksToBounds = true
            pdfWebView.layer.borderWidth = 1.0
            pdfWebView.scrollView.showsVerticalScrollIndicator = true
            pdfWebView.scrollView.flashScrollIndicators()
            
            
            self.pdfWebView.scrollView.isPagingEnabled = true
            
            self.pdfWebView.paginationMode = .topToBottom
            self.pdfWebView.paginationBreakingMode = .page
            
            
        
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func showPreviewView(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "previewcontroller") as! PreviewViewController
        controller.currentMeeting = currentMeeting
        
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayError(){
        
        let alertController = UIAlertController(title: "", message: "Please take signatures from all presented members", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(ok)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: false, completion: nil)
        }
    }


    @IBAction func endMeeting(_ sender: Any) {
        print("end meeting")
        if let signatures = currentMeeting?.signature {
            
            
            if signatures.count < 2 {
                  displayError()
            
            }
            for signature in signatures {
                if signature.signature == NSData() {
               displayError()
            }
                    
            }
        }
            
         else {
            displayError()
     
            
            
        }
        
        print("done")
        
        let alertController = UIAlertController(title: "", message: "You cannot edit meeting once ended. Do you still want to end this meeting", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default){action in
        print("yes func called")
            if let error = PersistentManager.shared.completeMeeting(meetingID: self.currentMeeting!.id){
            print("error occured")
            }
            else {
            
                print("Meeting Ended")
                
                /*let controller = self.storyboard?.instantiateViewController(withIdentifier: "mainviewcontroller")
            
                
                DispatchQueue.main.async {
                    
                    self.present(controller!, animated: false, completion: nil)
                }
                
 */
                
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "pdfloader") as! PDFViewLoaderController
                
                controller.meeting = self.currentMeeting
                DispatchQueue.main.async {
                    
                    self.present(controller, animated: false, completion: nil)
                }

                
                
                
            }
        
        }
        alertController.addAction(yes)
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(no)
        DispatchQueue.main.async {
            self.present(alertController, animated: false, completion: nil)
        }
    
        
    }
    
    

    
    
    @IBAction func showAttendanceView(_ sender: Any) {

        let controller = storyboard?.instantiateViewController(withIdentifier: "attendancecontroller") as! AttendanceViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func showAgendaView(_ sender: Any) {
    
        let controller = storyboard?.instantiateViewController(withIdentifier: "agendacontroller") as! AgendaViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    @IBAction func showSignatureView(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "signaturecontroller") as! SignatueViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
 
    
    
    @IBAction func showMeetingView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "meetingcontroller") as! MeetingCreatorViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    

    
    @IBAction func showActionItemView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "actionitemcontroller") as! ActionItemViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
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
