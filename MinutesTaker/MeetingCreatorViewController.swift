//
//  MeetingCreatorViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/22/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class MeetingCreatorViewController: UIViewController,UIWebViewDelegate,UITextFieldDelegate{
var currentMeeting:MTMeeting?
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var titleDescription: UITextField! //meeting creation
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var introductoryText: UITextField!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var actionText: UITextField!
    @IBOutlet weak var createMeetingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        actionText.addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)
        titleText.addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)

        
        introductoryText.addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)
        updateUI()
        
    
    }
    @IBAction func onDateChanged(_ sender: Any) {
        if let currentMeeting = currentMeeting {
            print("changed")
            self.currentMeeting?.title = titleText.text!
            self.currentMeeting?.date = date.date as NSDate
            self.currentMeeting?.introductoryText = introductoryText.text
            self.currentMeeting?.actionItemTitle = actionText.text
            if let error =  PersistentManager.shared.updateTemplate(meetingID: currentMeeting.id, introductoryText: introductoryText.text!, actionTitleText: actionText.text!,title:titleText.text!,date:date.date as NSDate) {
                print("error updating template")
                
                
            }
                
            else {
                
                print("successfully update template")
            }
            
        }

    }
    func textViewDidChange(_ textView: UITextView) {
        if let currentMeeting = currentMeeting {
            print("changed")
            self.currentMeeting?.title = titleText.text!
            self.currentMeeting?.date = date.date as NSDate
        self.currentMeeting?.introductoryText = introductoryText.text
        self.currentMeeting?.actionItemTitle = actionText.text
            if let error =  PersistentManager.shared.updateTemplate(meetingID: currentMeeting.id, introductoryText: introductoryText.text!, actionTitleText: actionText.text!,title:titleText.text!,date:date.date as NSDate) {
                print("error updating template")

            
            } 
            
            else {
            
                print("successfully update template")
            }
            
        }
        print("1")
    }
    
    
    
    
    func updateUI(){
        if let currentMeeting = currentMeeting {
            
            DispatchQueue.main.async {
                self.titleDescription.isHidden = true
                self.titleText.text = currentMeeting.title
                self.introductoryText.text = currentMeeting.introductoryText
                self.actionText.text = currentMeeting.actionItemTitle
              //  self.date.isEnabled = false
                self.date.date = currentMeeting.date as Date
                self.menu.isHidden = false
                self.createMeetingButton.isHidden = true
                  self.titleText.isHidden = false
            }
            
        }
        else {
            
            DispatchQueue.main.async {
                self.menu.isHidden = true
                self.titleText.isHidden = true
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func createMeeting(_ sender: Any) {
        
        if (titleDescription.text?.characters.count)! > 0 {
            
        PersistentManager.shared.createMeeting(title: titleDescription.text!, date: date.date as NSDate, introductoryText: introductoryText.text, actionItemTitle: actionText.text, agendaList: nil){ error, meeting in
            if error == nil {
                self.currentMeeting = meeting
                self.updateUI()
                
            
            }
            else {
            print("error creating meeting")
            }
        }
        }
        else {
        
            let alert = UIAlertController(title: "Validation Failed!", message: "Please enter title of the meeting", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            DispatchQueue.main.async {
                self.present(alert, animated: false, completion: nil)
            }
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
    
    
    
    
    
    @IBAction func showPreviewView(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "previewcontroller") as! PreviewViewController
        controller.currentMeeting = currentMeeting
        
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }

    @IBAction func showReviewView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "reviewcontroller") as! ReviewViewController
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
