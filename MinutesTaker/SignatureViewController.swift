//
//  ViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/20/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit
import EPSignature
import CoreData
class SignatueViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,EPSignatureViewDelegate {
    @IBOutlet weak var signatureGroup: UIView! // all signature components
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signatureViewGroup: UIView! // without image
    @IBOutlet weak var signatureImage: UIImageView!  // signature image
    @IBOutlet weak var signature: EPSignatureView! // sigature pad
    
    var signatureList:[MTSignature] = []
    var currentIndexPath:IndexPath?
    var currentMeeting:MTMeeting?
    @IBAction func reset(_ sender: Any) {
        if let index = currentIndexPath {
       
            
         let signatureVal = MTSignature(signature: NSData(), memberID: signatureList[index.row].memberID)
         signatureList[index.row] = signatureVal
         PersistentManager.shared.saveSignature(meetingID: currentMeeting!.id, signature: signatureList[index.row])
            
            DispatchQueue.main.async {
                self.signatureViewGroup.isHidden = false
                self.signatureImage.isHidden = true
                self.signature.clear()
            }

            
        }
        
    }
    
    func touchBegan() {
        print("touch began")
    }
    func touchEnded() {
        
        
        if signature.isSigned {
            
            if let index = currentIndexPath{
                let image:UIImage =  signature.getSignatureAsImage()!
                var imageData:NSData = UIImagePNGRepresentation(image)! as NSData
                signatureList[index.row].signature = imageData
                PersistentManager.shared.saveSignature(meetingID: currentMeeting!.id, signature: signatureList[index.row])

        print("save signature for \(signatureList[index.row].memberID)")
                
            }
        }
        else {
        print("dont save")
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signature.strokeColor = UIColor.blue
        signature.delegate = self
        //in viewDidLoad
        //presentCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        

        if let meeting = currentMeeting {
          
            
            if let attendanceList = meeting.attendance {
            for attendance in attendanceList {
                
                if attendance.isPresent {
                    
                let data = NSData()
                    
                let signature = MTSignature(signature: data, memberID: attendance.memberID)
                    
                //add signature
                let persistantSignature = PersistentManager.shared.getSignature(meetingID: meeting.id, memberID: attendance.memberID)
                    
                 //end
                    
                    if let persistantSignature = persistantSignature {
                    signatureList.append(persistantSignature)
                        
                    }
                    else {
                    
                    
                signatureList.append(signature)
                        
                    }
                    
                }
                
            }
            }
            
            
            // retrive gm signature persistent
            let data = NSData()

           let generalManager = Members.shared.getGeneralManager()
           let persistantSignature = PersistentManager.shared.getSignature(meetingID: meeting.id, memberID: generalManager.ID)
           if let persistantSignature = persistantSignature {
            
                 signatureList.append(persistantSignature)

            }
            else {
            
            signatureList.append(MTSignature(signature: data, memberID: generalManager.ID))
            }
            // end of retriving gm signature persistent

                   // retrive chairman signature persistent
            let chairman = Members.shared.getChairman()
            let chairmanSignaturePersistantSignature = PersistentManager.shared.getSignature(meetingID: meeting.id, memberID: chairman.ID)

            if let chairmanSignaturePersistantSignature = chairmanSignaturePersistantSignature {
                
                signatureList.append(chairmanSignaturePersistantSignature)
                
            }
            else {
                
                signatureList.append(MTSignature(signature: data, memberID: chairman.ID))
            }
            
            
            // ending chairman signature persistent

            
            
        }
    
        

    }
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return signatureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presentcell", for: indexPath) as! PresentCell
        
     
        
        cell.name.text = Members.shared.getMember(from: signatureList[indexPath.row].memberID)?.name
        cell.name.tag = indexPath.row

        //in cellForItemAtIndexPath
        //cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselects")
        var cell = collectionView.cellForItem(at: indexPath) as! PresentCell
        
        
        DispatchQueue.main.async {
            cell.backgroundColor = UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        }
        if signature.isSigned {

        let image:UIImage =  signature.getSignatureAsImage()!
        var imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        
            signatureList[indexPath.row].signature = imageData
            
        }
        
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       currentIndexPath = indexPath
        var cell = collectionView.cellForItem(at: indexPath) as! PresentCell
        DispatchQueue.main.async {
            self.signatureGroup.isHidden = false
            cell.backgroundColor = UIColor.green
            
        }
        if  NSData() != signatureList[indexPath.row].signature {
            DispatchQueue.main.async {
                self.signatureViewGroup.isHidden = true
                self.signatureImage.isHidden = false
           
                self.signatureImage.image = UIImage(data: self.signatureList[indexPath.row].signature  as Data)
                  self.signature.clear()
         
            }
        
        }
        else {
          
            
            self.signatureViewGroup.isHidden = false
            self.signatureImage.isHidden = true
        self.signature.clear()
        }
    }
    

    


    


    
    
    
    
    
    
    @IBAction func showAttendanceView(_ sender: Any) {
        currentMeeting?.signature = signatureList
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "attendancecontroller") as! AttendanceViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func showAgendaView(_ sender: Any) {
        currentMeeting?.signature = signatureList
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "agendacontroller") as! AgendaViewController
        
        controller.currentMeeting = currentMeeting
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
       
    
    
    
    @IBAction func showMeetingView(_ sender: Any) {
        currentMeeting?.signature = signatureList
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "meetingcontroller") as! MeetingCreatorViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    @IBAction func showPreviewView(_ sender: Any) {
        currentMeeting?.signature = signatureList
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "previewcontroller") as! PreviewViewController
        controller.currentMeeting = currentMeeting
        
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func showReviewView(_ sender: Any) {
        currentMeeting?.signature = signatureList
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "reviewcontroller") as! ReviewViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func showActionItemView(_ sender: Any) {
        currentMeeting?.signature = signatureList
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "actionitemcontroller") as! ActionItemViewController
        controller.currentMeeting = currentMeeting

        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
    }
