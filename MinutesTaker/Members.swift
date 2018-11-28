//
//  Members.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/26/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import Foundation

class Members:NSObject  {
    static let shared = Members()
    var list:[Member] = []
    override init() {
        
        let chairman = Member(ID: 0, name: "سعيد سلطان السويدي", member: .Chairman,designation:"رئيس مجلس الإدارة")
        let generalManager = Member(ID: 1, name: "ماجد سالم الجنيد", member: .GeneralManager,designation:"المدير العام")
        
        let boardOfMemberFirst = Member(ID: 2, name: "وليد علي الفلاح", member: .BoardOfDirector,designation:"نائب رئيس مجلس الإدارة")
        let boardOfMemberSecond = Member(ID: 3, name: "محمد أحمد أمين", member: .BoardOfDirector,designation:"أمين السر")
        let boardOfMemberThird = Member(ID: 4, name: "صالح محمد القابض", member: .BoardOfDirector,designation:"أمين الصندوق")
        let boardOfMemberFourth = Member(ID: 5, name: "ناصر مسعود الباروت", member: .BoardOfDirector,designation:"عضو مجلس الإدارة")

        list.append(chairman)
        list.append(generalManager)
        list.append(boardOfMemberFirst)
        list.append(boardOfMemberSecond)
        list.append(boardOfMemberThird)
        list.append(boardOfMemberFourth)
        
    }
    
    
    
    func getMember(from memberID:Int16)->Member?{
        for member in list {
            if member.ID == memberID {
                return member
            }
        }
        return nil
    }
    
    
    func getAllBoardOfDirectors()->[Member]{
        var BOD:[Member] = []
        
        for member in list {
            if member.member == .BoardOfDirector {
            BOD.append(member)
            }
        }
        
        return BOD
        
    }
    
    func getChairman()->Member{
        
        
        for member in list {
            if member.member == .Chairman {
                return member
            }
        }
        
        return list[0] // this case will never occur
        
    }
    
    func getGeneralManager()->Member{
        
        
        for member in list {
            if member.member == .GeneralManager {
                return member
            }
        }
        
        return list[1] // this case will never occur
        
    }
}
