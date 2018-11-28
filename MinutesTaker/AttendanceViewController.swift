//
//  AttendanceViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/29/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var attendanceTableView: UITableView!
    var currentMeeting:MTMeeting?
    @IBAction func absentReasonChanged(_ sender: UITextView) {
        updateAttendance(i: sender.tag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceTableView.separatorStyle = .none
        
        if let meeting = currentMeeting {
       //     print(meeting)
        }

        // Do any additional setup after loading the view.
    }

    
    
    func updateAttendance (i:Int){
        let index = IndexPath(row: i, section: 0)
        var cell = self.attendanceTableView.cellForRow(at: index) as! AttendanceCell
        let attendance = (currentMeeting?.attendance!)![index.row]
        let attend = MTAttendance(memberID: attendance.memberID, isPresent: cell.attendanceMarker.isOn, reason: cell.reason.text)
        if attend.isPresent {
            currentMeeting?.attendance![i].reason = ""
            cell.reason.text = ""
        }
        
        if attend.isPresent != attendance.isPresent || attend.reason != attendance.reason {
            print("values changed")
            PersistentManager.shared.updateAttendance(meetingID: currentMeeting!.id, Attendance: attend)
            currentMeeting?.attendance![i] = attend
            
            
            if let signature = PersistentManager.shared.getSignature(meetingID: currentMeeting!.id, memberID: attend.memberID){
            
                if let deleteError =  PersistentManager.shared.deleteSignature(meetingID: currentMeeting!.id, memberID: attend.memberID) {
                print("error when deleting signature")
                }
                else {
                    print("deleted signature")
                    
                    var i = 0
                    for signature in currentMeeting!.signature! {
                    
                        if signature.memberID == attend.memberID {
                        currentMeeting!.signature!.remove(at: i)
                        }
                        
                        i = i + 1
                    }
                    
                    }
                
            
            }
            
            
        }
        
        
    }
   
    @IBAction func attendanceChanged(_ sender: UISwitch) {
        updateAttendance(i: sender.tag)
        print(sender.tag)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "attendancecell") as! AttendanceCell
        cell.selectionStyle = .none
        
        cell.attendanceMarker.tag = indexPath.row
        cell.reason.tag = indexPath.row
        cell.name.text = ""
        cell.reason.text = ""
        if let meeting = currentMeeting {
          
      let attendance = meeting.attendance![indexPath.row]
            print( Members.shared.getMember(from: attendance.memberID)!.name)
                cell.attendanceMarker.setOn(attendance.isPresent, animated: false)
                cell.name.text = Members.shared.getMember(from: attendance.memberID)!.name
                cell.reason.text = attendance.reason
                cell.reason.isHidden = attendance.isPresent
            
        }
        
        return cell
        
    
    }
    
    @IBAction func attendanceMarkerChanged(_ sender: UISwitch) {
        
        DispatchQueue.main.async {
            
            let index = IndexPath(row: sender.tag, section: 0)
            var cell = self.attendanceTableView.cellForRow(at: index) as! AttendanceCell
            cell.reason.isHidden = cell.attendanceMarker.isOn
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let meeting = currentMeeting {
           return meeting.attendance!.count
        }
        else {
        return 0
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
    
    
    
    @IBAction func showReviewView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "reviewcontroller") as! ReviewViewController
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
