//
//  Report.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/26/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import Foundation
import UIKit

class Report:NSObject,UIWebViewDelegate {
    
    var meeting:MTMeeting
    var day:String
    var date:String
    var time:String
    
    
    //The second Board of Directors' Meeting for 2017 was held under the chairmanship of His Excellency Saeed Sultan Al Suwaidi
    
    
    
    func generateHeader()->String{
       
        return "<html dir='rtl' lang='ar'><link rel='stylesheet' type='text/css' href='https://fonts.googleapis.com/css?family=Changa'><body width='595.2px' style='padding:20px'> <style> html { font-weight: 100; line-height:1.6; font-size:18; font-family:'Changa'; } .divTable{display: table; page-break-inside: avoid; width: 100%; table-layout: fixed;}.cellparticipants { font-size:14; border-width:1px; border:1px solid #000000;display: table-cell;padding: 3px 5px; width: 25%; vertical-align: middle; word-break: break-all; } .cellcontent { border-width:1px font-size:14; vertical-align: middle; border: 1px solid #000000;display: table-cell;padding: 3px 5px; width: 65%; word-break: break-all; } .cellnumber {font-size:14px; border-width:1px; vertical-align: middle; border: 1px solid #000000;display: table-cell;padding: 3px 5px; width: 10%; word-break: break-all; } .arabic{text-align:right}</style>"

    }
    
    func generateFooter()->String{
        return "</body></html>"
        
    }
    
    
    func generateTitle()->String{
        return "<h3 style='text-decoration:underline'><center>\(meeting.title)</center></h3>"
    
    }
    
    
    
    func generateIntroductoryText()->String{
        if let introductoryText = meeting.introductoryText {
            return "<div align='right' style = 'font-size:18;'> \(introductoryText) ، برئاسة سعادة / سعيد سلطان السويدي ، وهجضور السادة الأعضاء</div>"
            
        }
        return ""
        
    }
    
    
    func generateTimeRow()->String{
        return "<table width='100%'> <tr><td align='right'><b>اليوم : \(day) الخميس</b></td><td width='33.3%' align='center'><b> الموا فق : \(date)</b></td><td width='33.3%' align='left'><b>الساعة \(time)</b></td></tr> </table> <hr>"
        
    }
    
    func generateActionItems()->String{
        if let actionItems = meeting.actionitem {
            
          
            
            
            if actionItems.count > 0 {
                  var header = ""
            if let actionitemText = meeting.actionItemTitle {
                
                
             header = "<h3 style='text-decoration:underline; page-break-before:always;'><center>\(meeting.title)</center></h3><div align='right'><h3 style='text-decoration:underline;'> فيما يلي توصيات مجلس الإدارة في  \(actionitemText) :  </h3><br><div style='padding:15px'><table>"
            }
            else {
            
              header = "<br><br><div align='right'><h3 style='text-decoration:underline;'>  فيما يلي توصيات مجلس الإدارة في :</h3><br><div style='padding:15px'><table>"
            }
            
            var body = ""
            for item in actionItems {
            print(item.title)
            body.append("<tr><td valign='top'>&#8226;</td><td align='right'>\(item.title)</td></tr>")
            }
            
            let footer = "</table></div></div>"
            
            
            
            return "\(header) \(body) \(footer)"
            }
        }
    return ""
    }
    
    func generateSignature()->String{
        
        
        var header = ""
        var footer = ""

        var body = ""
        var i=2
        if let signatureList = meeting.signature {
            if signatureList.count > 0 {
             header = " <h3 style='text-decoration:underline; page-break-before:always;'><center>\(meeting.title)</center></h3><div ><div align='right' ><h3 style='text-decoration:underline;'>توقيح المحضر من قِبل الساده الحضور  :</h3><br><br><div width='100%'>"
            footer = "</div></div><div style='clear:both;'></div><br><br>"
                
            }
            for signature in signatureList {
                
                if signature.memberID != 0 ||  signature.memberID != 1 {
                if let attendance = meeting.getAttendance(for: signature.memberID) {
                    if attendance.isPresent {
                    
                        if let member = Members.shared.getMember(from: signature.memberID) {
                            if i%2==0 {
                            body.append("<table width='50%' style='float:right;'><tr><td align ='right'  style='padding-right:50px;'><b>\(member.name)</b></td></tr><tr><td align ='right' style='padding-right:20px;' ><img src ='data:image/false;base64,\(signature.signature.base64EncodedString(options: .endLineWithCarriageReturn))' width='§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§' height = '75px'></td></tr></table>")
                            }
                            else {
                                        body.append("<table width='50%' style='float:left;'><tr><td align ='right'  style='padding-right:50px;'><b>\(member.name)</b></td></tr><tr><td align ='right' style='padding-right:20px'><img src ='data:image/false;base64,\(signature.signature.base64EncodedString(options: .endLineWithCarriageReturn))' width='150px' height = '75px'></td></tr></table>")
                            
                            }
                            
                            i = i + 1
                        
                        }
                    }
                }
                
            }
        
            }
        }
        
       // gm signature
        
        
        if let signature = meeting.getSignature(for: 1) {
         
            if i%2==0 {
                
            body.append("<table width='50%' style='float:right;'><tr><td align ='right'  style='padding-right:50px;'><b>\(Members.shared.getMember(from: 1)!.name)</b></td></tr><tr><td align ='right' ><img src ='data:image/false;base64,\(signature.signature.base64EncodedString(options: .endLineWithCarriageReturn))' width='200px' height = '125px'></td></tr></table>")
            }
            else {
             body.append("<table width='50%' style='float:left;'><tr><td align ='right'  style='padding-right:50px;'><b>\(Members.shared.getMember(from: 1)!.name)</b></td></tr><tr><td align ='right' ><img src ='data:image/false;base64,\(signature.signature.base64EncodedString(options: .endLineWithCarriageReturn))' width='200px' height = '125px'></td></tr></table>")
            }
        }
        
        
        
        
        
       // let body = "<table width='50%' style='float:right;'><tr><td align ='right'  style='padding-right:50px;'><b>وليد علي الفلاح</b></td></tr><tr><td align ='right' ><img src ='http://10.1.1.147:99/MobileAppServices/ShareholderTokenSystem/Signatures/g10.png' width='200px' height = '125px'></td></tr></table><table width='50%' style='float:left;'><tr><td align ='right' style='padding-right:50px;'><b>محمد أحمد أمين</b></td></tr><tr><td align ='right'><img src ='http://10.1.1.147:99/MobileAppServices/ShareholderTokenSystem/Signatures/g10.png' width='200px' height = '125px'></td></tr></table>"
        
        
        
        if let chairmanSign = meeting.getSignature(for: 0) {
            footer.append("<div align='right' style='margin:0px' ><div width ='100%' style=' padding-right:180px;' ><table><tr><td><center><b>رئيس مجلس الإدارة</b></center></td></tr><tr><td><center><b>سعادة/ سعيد سلطان السويدي</b></center></td></tr><tr><td><center><img src = 'data:image/false;base64,\(chairmanSign.signature.base64EncodedString(options: .endLineWithCarriageReturn))' width='200px' height='125px' /></center></td></tr></table></div></div>")
        }
        
    
           return "\(header) \(body) \(footer) </div>"
        
    }
    
    func generateAttendance()->String{
       let header =  " <div id='names'><table width='100%' style='font-size:18;'>"
        
        
        var body = ""
        let bracketStart = " ( "
        let bracketEnd = " ) "
        
        for BOD in Members.shared.getAllBoardOfDirectors() {
        
            var reason = ""
            if let attendance = meeting.getAttendance(for: BOD.ID){
                if !attendance.isPresent {
                    if var reasonStr = attendance.reason {
                        
                        
                        if reasonStr == "" {
                            reasonStr = "غير موجود"
                        }
                    reason = " " + reasonStr + " "
                    body += "<tr><td align='right' width='40%'>سعادة / \(BOD.name)</td><td align='right' width='60%'> \(BOD.designation) \(bracketStart) \(reason) \(bracketEnd)  </td></tr>"
                    }
                }
                else if attendance.isPresent {
                    body += "<tr><td align='right' width='40%'>سعادة / \(BOD.name)</td><td align='right' width='60%'>\(BOD.designation)</td></tr>"
                }
                
                
                
            }
        
        }
        

        
        let footer = "</table> </div>  "
        
        return "\(header) \(body) \(footer)"
    }
    
    
    func generateAgenda() -> String {
        
        
        if let agenda = meeting.agenda {
            var i = 0
            
           
            var header = ""
            var footer = ""
            
            if agenda.count > 0 {
                header = "<div align='right'> كما حضر عن إدارة الجمعية، سعادة/ ماجد سالم الجنيد - المدير العام، وبداً الإجتماع بعرض الأجندة والتي تضمنت :</div><br><div class='divTable'><div class='cellnumber' style=' border-left: 0px solid #999999;'><center></center></div><div align='right' class='cellcontent' style=' border-right: 0px solid #999999; border-left:0px;'><b>الموضوع</b> </div><div align='right' class='cellparticipants'><b>المشاركين</b></div></div>"
              //  footer = "</table> </div>"

            }
            var body = ""
            for agendaItem in agenda {
        
                let title = "\(agendaItem.title)"
                if let participants = agendaItem.participants {
                    
                    
                  
                    
                 body.append("<div class='divTable'><div style='border-top:1px' class='cellnumber'>\(Constants.arabicOrdinalNumbers[i]) </div><div class='cellcontent' style='border-right:0px; border-left:0px; border-top:1px; ' align='right'> \(title) </div><div class='cellparticipants' style='border-top:1px'  align='right'>\(participants)</div></div>")
                }
                else {
                   body.append("<div class='divTable'><div style='border-top:1px'  class='cellnumber'>\(Constants.arabicOrdinalNumbers[i]) </div><div class='cellcontent' style='border-right:0px; border-left:0px; border-top:1px;'  align='right'> \(title)&nbsp;&nbsp; </div><div style='border-top:1px'  class='cellparticipants'  align='right'> &nbsp;</div></div>")
                }
            i = i + 1
            }
            
            
            
            return "\(header) \(body)"
        }
        
        
        
        return ""
    }
    func generateHTML()->String{
     
        
        
        let template = "\(generateHeader()) \(generateTitle()) \(generateTimeRow()) <br>\(generateIntroductoryText()) <br>  \(generateAttendance()) <br>  \(generateAgenda()) \(generateActionItems()) \(generateSignature()) \(generateFooter())"
       
        for familyName:String in UIFont.familyNames {
            //print("Family Name: \(familyName)")
            for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                //print("--Font Name: \(fontName)")
            }
        }
        
        let webview = UIWebView()
    
        return template
        
       
    }
   
    func generateHTMLWithoutSignature()->String{
        
        
        
        let template = "\(generateHeader()) \(generateTitle()) \(generateTimeRow())  <br> \(generateIntroductoryText())  <br> \(generateAttendance()) <br> \(generateAgenda()) \(generateActionItems()) \(generateFooter())"
        
        
        
        let webview = UIWebView()
        
        
        
        return template
        
        
    }
    

     init(meetingRecord:MTMeeting) {
        meeting = meetingRecord
      
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_AE")
        formatter.dateFormat = "E"
        self.day = formatter.string(from: meeting.date as Date)
        
        formatter.dateFormat = "dd MMM yyyy"
        self.date = formatter.string(from: meeting.date as Date)
      //  print(self.date)
        
        formatter.dateFormat = "hh:mm"
        self.time = formatter.string(from: meeting.date as Date)
        
        
        formatter.dateFormat = "a"
        
        if formatter.string(from: meeting.date as Date) == "ص" {
            self.time+=" صباحاً"
        }
        else{
            self.time+=" ظهراً"
        }
        
      //  print(self.time)
        
        
        
    }
    
    
    
       
}
