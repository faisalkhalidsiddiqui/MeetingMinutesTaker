//
//  MeetingTaker.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/21/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

struct MTAgenda {
    let id:String?
    var title:String
    var participants:String?
    
}

struct MTActionItem {
    let id:String?
    var title:String
}


struct MTAttendance {
    let memberID:Int16
    let isPresent: Bool
    var reason:String?
}

struct MTSignature {
    var signature:NSData
    let memberID:Int16

}


struct MTMeeting {

    let id:String
    var date:NSDate
    var title:String
    var introductoryText:String?
    var actionItemTitle:String?
    var isMeetingEnded:Bool = false
    var agenda:[MTAgenda]?
    var signature:[MTSignature]?
    var attendance:[MTAttendance]?
    var actionitem:[MTActionItem]?
    
    
    func getSignature(for memberID:Int16)->MTSignature?{
        if let signature = signature {
            for signatureItem in signature {
                
                if signatureItem.memberID == memberID {
                    return signatureItem
                }
            }
            return nil
        }
        else {
            return nil
        }
    }

        


    func getAttendance(for memberID:Int16)->MTAttendance?{
        if let attendance = attendance {
            for attendanceItem in attendance {
            
                if attendanceItem.memberID == memberID {
                return attendanceItem
                }
            }
            return nil
        }
        else {
        return nil
        }
    }

}


enum MemberType {
case BoardOfDirector,Chairman,GeneralManager
}

struct Member {
    let ID:Int16
    let name:String
    let member:MemberType
    let designation:String

}
