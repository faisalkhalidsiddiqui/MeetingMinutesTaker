//
//  PastMeetingsViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 03/04/2017.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class PendingMeetingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var meetings:[MTMeeting]?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetings = PersistentManager.shared.getAllPendingMeetings()

    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let meeting = PersistentManager.shared.getMeeting(from: (meetings?[indexPath.row].id)!) {
            
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "meetingcontroller") as! MeetingCreatorViewController
            
            controller.currentMeeting = PersistentManager.shared.meetingToMTMeeting(meeting: meeting)
            DispatchQueue.main.async {
                
                self.present(controller, animated: false, completion: nil)
            }
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let meetings = meetings {
            return meetings.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pendingmeetingcell", for: indexPath) as! PendingMeetingCell
        
        cell.title.text = meetings?[indexPath.row].title
        
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 15
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_AE")
        
        formatter.dateFormat = "dd/MM/yy"
        cell.date.text = formatter.string(from: meetings?[indexPath.row].date as! Date)
        //  print(self.date)
        
        formatter.dateFormat = "hh:mm a"
        cell.time.text = formatter.string(from: meetings?[indexPath.row].date as! Date)
        
        
        return cell
    }
    

}
