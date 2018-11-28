//
//  MainViewController.swift
//  MinutesTaker
//
//  Created by faisal khalid on 4/19/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var newMeetingView: UIView!
    @IBOutlet weak var currentMeetingView: UIView!

    @IBOutlet weak var pastMeetingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
 newMeetingView.layer.masksToBounds = true
        newMeetingView.layer.cornerRadius = 25
        
        currentMeetingView.layer.masksToBounds = true
        currentMeetingView.layer.cornerRadius = 25
        
        
        pastMeetingView.layer.masksToBounds = true
        pastMeetingView.layer.cornerRadius = 25
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
