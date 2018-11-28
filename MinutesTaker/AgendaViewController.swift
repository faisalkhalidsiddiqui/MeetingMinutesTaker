//
//  AgendalViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 4/2/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit
import CoreGraphics
class AgendaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var participants: UITextField!
    @IBOutlet weak var agendaTextBoxView: UIView!
    @IBOutlet weak var agendaTextView: UITextView!
    

    
    var currentMeeting:MTMeeting?
    var agendaList:[MTAgenda] = []
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            
            
            addAgenda(textView)
            return false;
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\t" {
            
            
            textView.resignFirstResponder()
            participants.becomeFirstResponder()
            return false;
        }
        
        if text == "\n" {
            
            
            addAgenda(textView)
            return false;
        }
        
        
        
        
        
        return true
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        agendaTextBoxView.clipsToBounds = true
        agendaTextBoxView.layer.borderColor = UIColor.black.cgColor
        agendaTextBoxView.layer.borderWidth = 1;
          agendaTextView.layer.borderColor = UIColor.black.cgColor
        agendaTextView.layer.borderWidth = 1;
        tableview.layer.borderColor = UIColor.black.cgColor
        tableview.layer.borderWidth = 1;
        */
              tableview.tableFooterView = UIView()
        fetchAgendaFromPersistent()
        
        
        }

    func fetchAgendaFromPersistent(){
    
        if let currentMeeeting = currentMeeting {
            let agendaPersistentList:[MTAgenda]? =  PersistentManager.shared.getAllAgenda(meetingID: currentMeeeting.id)
            
            if let agendaPersistentList = agendaPersistentList {
            agendaList = agendaPersistentList
            
            }
        }
    }
    
    @IBAction func addAgenda(_ sender: Any) {
        
        if agendaTextView.text.characters.count > 0 {
        
            agendaList.append(MTAgenda(id:"",title: agendaTextView.text, participants: participants.text))
         
            if let currentMeeting = currentMeeting {
                PersistentManager.shared.addAgenda(meeting: currentMeeting.id, title: agendaTextView.text, participants: participants.text!){ error,agenda in
                    
                    if error == nil {
                    print(agenda)
                    }
                
                }
                
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            self.agendaTextView.text = ""
            self.participants.text = ""
                
            }
        }
        
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return agendaList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "agendacell") as! AgendaCell
        cell.agendaTitle.text = agendaList[indexPath.row].title
        cell.participants.text = agendaList[indexPath.row].participants
        cell.editAgendaTitle.text = agendaList[indexPath.row].title
        cell.editParticipants.text = agendaList[indexPath.row].participants
        cell.edit.tag = indexPath.row
        cell.saveEditedItem.tag = indexPath.row
        
        //style
        
        cell.selectionStyle = .none
        
                return cell
        
    }
    



    
    
    
    @IBAction func showAttendanceView(_ sender: Any) {
        currentMeeting?.agenda = agendaList

        let controller = storyboard?.instantiateViewController(withIdentifier: "attendancecontroller") as! AttendanceViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }

    
    
    @IBAction func showSignatureView(_ sender: Any) {
        currentMeeting?.agenda = agendaList

        let controller = storyboard?.instantiateViewController(withIdentifier: "signaturecontroller") as! SignatueViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
    
    
    @IBAction func showMeetingView(_ sender: Any) {
        currentMeeting?.agenda = agendaList

        let controller = storyboard?.instantiateViewController(withIdentifier: "meetingcontroller") as! MeetingCreatorViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
    @IBAction func showReviewView(_ sender: Any) {
        currentMeeting?.agenda = agendaList

        let controller = storyboard?.instantiateViewController(withIdentifier: "reviewcontroller") as! ReviewViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func showActionItemView(_ sender: Any) {
        currentMeeting?.agenda = agendaList

        let controller = storyboard?.instantiateViewController(withIdentifier: "actionitemcontroller") as! ActionItemViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if let currentMeeting = currentMeeting {
            if let id = agendaList[indexPath.row].id {
                if let error = PersistentManager.shared.deleteAgenda(meetingID: currentMeeting.id, agendaID: id){
                
                    
                
                }
                else {
                print("item removed from persistent")
                }
            }
                
            }
         agendaList.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    
    @IBAction func saveEditedAgenda(_ sender: UIButton) {
        
        let indexPath =  IndexPath(row: sender.tag, section: 0)
        let cell = tableview.cellForRow(at: indexPath) as! AgendaCell
        
        agendaList[sender.tag].participants = cell.editParticipants.text!
        agendaList[sender.tag].title = cell.editAgendaTitle.text!
        
        
        if let currentMeeting = currentMeeting {
            if let id = agendaList[sender.tag].id {
                if let error = PersistentManager.shared.updateAgenda(meetingID: id, agenda: agendaList[sender.tag]){
                
                }
                else {
                print("record updated!")
                }
            }
        }
        DispatchQueue.main.async {
            cell.editAgendaTitle.isHidden = true
            cell.editParticipants.isHidden = true
            cell.saveEditedItem.isHidden = true
            
            cell.agendaTitle.isHidden = false
            cell.participants.isHidden = false
            cell.edit.isHidden = false
            self.tableview.reloadData()
            
        }
        
        
        
        
    }
    
    
    @IBAction func showPreviewView(_ sender: Any) {
      
        currentMeeting?.agenda = agendaList

        let controller = storyboard?.instantiateViewController(withIdentifier: "previewcontroller") as! PreviewViewController
        controller.currentMeeting = currentMeeting
        
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    @IBAction func editAgenda(_ sender: UIButton) {
        let indexPath =  IndexPath(row: sender.tag, section: 0)
        let cell = tableview.cellForRow(at: indexPath) as! AgendaCell
        DispatchQueue.main.async {
            cell.editAgendaTitle.isHidden = false
            cell.editParticipants.isHidden = false
            cell.saveEditedItem.isHidden = false
            
            cell.agendaTitle.isHidden = true
            cell.participants.isHidden = true
            cell.edit.isHidden = true
        }
        
    }
    
}
