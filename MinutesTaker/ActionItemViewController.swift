//
//  ActionItemViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 4/2/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit
import CoreGraphics
class ActionItemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var actionItemTextBoxView: UIView!
    @IBOutlet weak var actionItemTextView: UITextView!
    
    
    
    var currentMeeting:MTMeeting?
    var actionItemList:[MTActionItem] = []
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
   
        if text == "\n" {
            
            
            addActionItem(textView)
            return false;
        }
        
        
        
        
        
        return true
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        /*
        actionItemTextBoxView.clipsToBounds = true
        actionItemTextBoxView.layer.borderColor = UIColor.black.cgColor
        actionItemTextBoxView.layer.borderWidth = 1;
        actionItemTextView.layer.borderColor = UIColor.black.cgColor
        actionItemTextView.layer.borderWidth = 1;
        tableview.layer.borderColor = UIColor.black.cgColor
        tableview.layer.borderWidth = 1;
        */
        
        tableview.tableFooterView = UIView()

        fetchActionItemFromPersistent()
        
        
    }
    
    @IBAction func showPreviewView(_ sender: Any) {
      
        currentMeeting?.actionitem = actionItemList

        let controller = storyboard?.instantiateViewController(withIdentifier: "previewcontroller") as! PreviewViewController
        controller.currentMeeting = currentMeeting
        
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    func fetchActionItemFromPersistent(){
        
        if let currentMeeeting = currentMeeting {
            let actionItemPersistentList:[MTActionItem]? =  PersistentManager.shared.getAllActionItem(meetingID: currentMeeeting.id)
            
            if let actionItemPersistentList = actionItemPersistentList {
                actionItemList = actionItemPersistentList
                for actionItem in actionItemList {
                print(actionItem)
                }
                
                
            }
        }
    }
    
    @IBAction func addActionItem(_ sender: Any) {
        
        if actionItemTextView.text.characters.count > 0 {
            
            actionItemList.append(MTActionItem(id:"",title: actionItemTextView.text))
            
            if let currentMeeting = currentMeeting {
                PersistentManager.shared.addActionItem(meeting: currentMeeting.id, title: actionItemTextView.text){ error,actionItem in
                    
                    if error == nil {
                        print(actionItem)
                    }
                    
                }
                
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.actionItemTextView.text = ""
                
            }
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "actionitemcell") as! ActionItemCell
        cell.actionItemTitle.text = actionItemList[indexPath.section].title
        cell.editActionItemTitle.text = actionItemList[indexPath.section].title
        cell.edit.tag = indexPath.section
        cell.saveEditedItem.tag = indexPath.section
        
        //style
        
        cell.selectionStyle = .none
        
        return cell
        
    }

    
    
    

    
    
    
    
    @IBAction func showAttendanceView(_ sender: Any) {
        currentMeeting?.actionitem = actionItemList

        let controller = storyboard?.instantiateViewController(withIdentifier: "attendancecontroller") as! AttendanceViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func showAgendaView(_ sender: Any) {
        currentMeeting?.actionitem = actionItemList

        let controller = storyboard?.instantiateViewController(withIdentifier: "agendacontroller") as! AgendaViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    @IBAction func showSignatureView(_ sender: Any) {
        currentMeeting?.actionitem = actionItemList

        let controller = storyboard?.instantiateViewController(withIdentifier: "signaturecontroller") as! SignatueViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
    
    
    @IBAction func showMeetingView(_ sender: Any) {
        currentMeeting?.actionitem = actionItemList

        let controller = storyboard?.instantiateViewController(withIdentifier: "meetingcontroller") as! MeetingCreatorViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
    @IBAction func showReviewView(_ sender: Any) {
        currentMeeting?.actionitem = actionItemList

        let controller = storyboard?.instantiateViewController(withIdentifier: "reviewcontroller") as! ReviewViewController
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
                if let id = actionItemList[indexPath.section].id {
                    if let error = PersistentManager.shared.deleteActionItem(meetingID: currentMeeting.id, actionID: id){
                        
                        
                        
                    }
                    else {
                        print("item removed from persistent")
                    }
                }
                
            }
            actionItemList.remove(at: indexPath.section)
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50; // space b/w cells
    }

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    @IBAction func saveEditedActionItem(_ sender: UIButton) {
        
        let indexPath =  IndexPath(row: 0, section: sender.tag)
        let cell = tableview.cellForRow(at: indexPath) as! ActionItemCell
        
        
        actionItemList[sender.tag].title = cell.editActionItemTitle.text!
        
        
        if let currentMeeting = currentMeeting {
            if let id = actionItemList[sender.tag].id {
                if let error = PersistentManager.shared.updateActionItem(meetingID: id, actionItem: actionItemList[sender.tag]){
                    
                }
                else {
                    print("record updated!")
                }
            }
        }
        DispatchQueue.main.async {
            cell.editActionItemTitle.isHidden = true
            cell.saveEditedItem.isHidden = true
            
            cell.actionItemTitle.isHidden = false
            cell.edit.isHidden = false
            self.tableview.reloadData()
            
        }
        
        
        
        
    }
    @IBAction func editActionItem(_ sender: UIButton) {
        let indexPath =  IndexPath(row: 0, section: sender.tag)
        let cell = tableview.cellForRow(at: indexPath) as! ActionItemCell
        DispatchQueue.main.async {
            cell.editActionItemTitle.isHidden = false
            cell.saveEditedItem.isHidden = false
            
            cell.actionItemTitle.isHidden = true
            cell.edit.isHidden = true
        }
        
    }
    
}
