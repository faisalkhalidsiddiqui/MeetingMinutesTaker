//
//  PastMeetingsViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 03/04/2017.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class PastMeetingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var meetings:[MTMeeting]?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetings = PersistentManager.shared.getAllCompletedMeetings()

    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "pdfloader") as! PDFViewLoaderController
        let i = indexPath.row
        
        controller.meeting = meetings![i]
        DispatchQueue.main.async {
            
            self.present(controller, animated: false, completion: nil)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let meetings = meetings {
            return meetings.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pastmeetingcell", for: indexPath) as! PastMeetingCell
        
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
