//
//  PersistentManager.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/21/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit
import CoreData
class PersistentManager: NSObject {
    
    static let shared = PersistentManager()
    let delegate =  UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext
    
    override init(){
        context = self.delegate.persistentContainer.viewContext
    }
    
    
    func createMeeting (title:String, date:NSDate,introductoryText:String?,actionItemTitle:String?, agendaList:[AGENDA]?,completionHandler:@escaping (_ error:Error?,_ Meeting:MTMeeting?) -> ()){
        
        let meeting = MEETING(context: context)
        meeting.title = title
        meeting.date = date
        meeting.actionItemTitle = actionItemTitle
        meeting.introductoryText = introductoryText
       
        
        //default all present 
        
        
        for member in Members.shared.getAllBoardOfDirectors() {
        let attendance = ATTENDANCE(context: context)
        attendance.isPresent = true
        attendance.reason = ""
        attendance.memberID = member.ID
        meeting.addToAttendance(attendance)
            
            
            
        }
        
        
        
        
        
        if let agendaList = agendaList {
            
            for agendaItem in agendaList {
                
                meeting.addToAgenda(agendaItem)
            }
        }
        
        do {
            
            try self.context.save()
            
            meeting.id = meeting.objectID.uriRepresentation().absoluteString
            
            try self.context.save()
            
            
            completionHandler(nil, meetingToMTMeeting(meeting: meeting))
            
            
        }
        catch
        {
            
            print("unable to save context")
            completionHandler(error, nil)
            
        }
    }
    
    func getAllCompletedMeetings ()->[MTMeeting]?{
        do{
            let request: NSFetchRequest<NSFetchRequestResult> = MEETING.fetchRequest()
            request.predicate = NSPredicate(format: "isMeetingEnded == %@", NSNumber(booleanLiteral: true))
            
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true,selector: #selector(NSString.localizedStandardCompare))]

            var meetingList = try context.fetch(request) as! [MEETING]
            
            var mtMeetingList:[MTMeeting] = []
            for meeting in meetingList {
                mtMeetingList.append(meetingToMTMeeting(meeting: meeting))
            }
            return mtMeetingList
        }
        catch{
            
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getAllPendingMeetings ()->[MTMeeting]?{
        do{
            let request: NSFetchRequest<NSFetchRequestResult> = MEETING.fetchRequest()
            request.predicate = NSPredicate(format: "isMeetingEnded == %@", NSNumber(booleanLiteral: false))
            
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true,selector: #selector(NSString.localizedStandardCompare))]

            var meetingList = try context.fetch(request) as! [MEETING]
            
            var mtMeetingList:[MTMeeting] = []
            for meeting in meetingList {
                mtMeetingList.append(meetingToMTMeeting(meeting: meeting))
            }
            return mtMeetingList
        }
        catch{
            
            print(error.localizedDescription)
        return nil
        }
    }
    
    func getMeeting (from id:String)-> MEETING? {
      
        do{
            
            let request: NSFetchRequest<NSFetchRequestResult> = MEETING.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
            request.returnsObjectsAsFaults = false
            
          let results =  try context.fetch(request) as! [MEETING]
            if results.count == 1 {
            return results[0]
            }
       
            
            return nil
            
            
            
        }
        catch{
               print(error.localizedDescription)
            return nil
        }

    }
    
    func addAgenda (meeting:String,title:String,participants:String,completionHandler:@escaping (_ error:Error?,_ agenda:MTAgenda?) -> ()){
        
        
        if let meeting = getMeeting(from: meeting){
        let agenda = AGENDA(context: context)
        agenda.title  = title
        agenda.participants = participants
        meeting.addToAgenda(agenda)
        
        do{
       
            
            
            try self.context.save()
            
            agenda.id = agenda.objectID.uriRepresentation().absoluteString
            
            try self.context.save()
            
            
            completionHandler(nil, agendaToMTAgenda(agenda: agenda))
            
        }
        catch {
            completionHandler(error, nil)
        }
        }
        else {
         completionHandler(NSError(), nil)
        }
        
        
    
    }
    
    func addActionItem (meeting:String,title:String,completionHandler:@escaping (_ error:Error?,_ actionItem:MTActionItem?) -> ()){
        
        
        if let meeting = getMeeting(from: meeting){
            let actionItem = ACTIONITEM(context: context)
            actionItem.title  = title
            meeting.addToActionitem(actionItem)
            
            do{
                
                
                
                try self.context.save()
                
                actionItem.id = actionItem.objectID.uriRepresentation().absoluteString
                
                try self.context.save()
                
                
                completionHandler(nil, actionItemToMTActionItem(actionItem: actionItem))
                
            }
            catch {
                completionHandler(error, nil)
            }
        }
        else {
            completionHandler(NSError(), nil)
        }
        
        
        
    }
    
    
    func addSignature (of:MEETING,memberID:Int16,signatureData:NSData,completionHandler:@escaping (_ error:Error?,_ Signature:MTSignature?) -> ()){
        let signature = SIGNATURE(context: context)
        signature.memberID = memberID
        signature.signature = signatureData
        
        of.addToSignature(signature)
        
        
        do{
            try context.save()
            completionHandler(nil, signatureToMTSignature(signature: signature))
            
        }
        catch {
            completionHandler(error, nil)
        }
    }
    
    
    func addAttendance (of:MEETING,memberID:Int16,isPresent:Bool,reason:String?,completionHandler:@escaping (_ error:Error?,_ Attendance:MTAttendance?) -> ()){
        let attendance = ATTENDANCE(context: context)
        attendance.memberID = memberID
        attendance.isPresent = isPresent
        attendance.reason = reason
        
        of.addToAttendance(attendance)
        
        do{
            try context.save()
            completionHandler(nil, attendanceToMTAttendance(attendance: attendance))
            
        }
        catch {
            completionHandler(error, nil)
        }
    }
    
    
    
    
    
    func endMeeting(meeting:MEETING,completionHandler:@escaping (_ error:Error?) -> ()){
    
        meeting.isMeetingEnded = true
        do {
            
            try context.save()
            completionHandler(nil)
        
        }
        catch{
            completionHandler(error)
        
        }
    
    }
    
    
    
    
    
      func meetingToMTMeeting(meeting:MEETING)->MTMeeting{

        
        var mtMeeting = MTMeeting(id:meeting.objectID.uriRepresentation().absoluteString,date: meeting.date!, title: meeting.title!,introductoryText:meeting.introductoryText,actionItemTitle:meeting.actionItemTitle,isMeetingEnded:meeting.isMeetingEnded, agenda: nil, signature: nil, attendance: nil, actionitem: nil)
        
        
        
        // agenda
        
        
        if let agendaList:[AGENDA] = meeting.agenda?.allObjects as! [AGENDA]? {
            
            var mtAgendaList:[MTAgenda] = []
            
            for agenda in agendaList {
                mtAgendaList.append(agendaToMTAgenda(agenda: agenda))
            }
            
            mtMeeting.agenda = mtAgendaList
            
        }
        
        //action item
        if var actionItemList:[ACTIONITEM] = meeting.actionitem?.allObjects as! [ACTIONITEM]? {
           actionItemList =  actionItemList.sorted (by: {
                
                $0.id! < $1.id!
            })
            
            var mtActionItemList:[MTActionItem] = []
            
            for actionItem in actionItemList {
                mtActionItemList.append(actionItemToMTActionItem(actionItem: actionItem))
            }
            
            mtMeeting.actionitem = mtActionItemList
            
        }
        
        //signature
        if let signatureList:[SIGNATURE] = meeting.signature?.allObjects as! [SIGNATURE]? {
            
            var mtSignatureList:[MTSignature] = []
            
            for signatue in signatureList {
                mtSignatureList.append(signatureToMTSignature(signature: signatue))
            }
            
            mtMeeting.signature = mtSignatureList
            
        }
        
        
        
        //attendance
        if let attendanceList:[ATTENDANCE] = meeting.attendance?.allObjects as! [ATTENDANCE]? {
            
            var mtAttendanceList:[MTAttendance] = []
            
            for attendance in attendanceList {
                mtAttendanceList.append(attendanceToMTAttendance(attendance: attendance))
            }
            
            mtMeeting.attendance = mtAttendanceList
            
        }
        
        
        
        if var agendaList:[AGENDA] = meeting.agenda?.allObjects as! [AGENDA]? {
        
         
            agendaList = agendaList.sorted (by: {
            
                $0.id! < $1.id!
            })
            
            var mtAgendaList:[MTAgenda] = []
            
            for agenda in agendaList {
                mtAgendaList.append(agendaToMTAgenda(agenda: agenda))
            }
            
            mtMeeting.agenda = mtAgendaList
            
        }
        
        
        return mtMeeting
            
        
        //
    
    }
    
  private  func agendaToMTAgenda(agenda:AGENDA) -> MTAgenda{
    
        return MTAgenda(id: agenda.id, title: agenda.title!, participants: agenda.participants)
    
    }
    
     private   func actionItemToMTActionItem(actionItem:ACTIONITEM) -> MTActionItem{
        
        return MTActionItem(id:actionItem.id,title: actionItem.title!)
        
    }
    
     private   func signatureToMTSignature(signature:SIGNATURE) -> MTSignature{
        
        return MTSignature(signature: signature.signature!, memberID: signature.memberID)
        
        
    }
    
    
     private   func attendanceToMTAttendance(attendance:ATTENDANCE) -> MTAttendance{
        
        return MTAttendance(memberID: attendance.memberID, isPresent: attendance.isPresent, reason: attendance.reason)
        
        
        
    }
    
    
    private func getMeetingFromID(from id:String)->MEETING?{
        do{
            let request: NSFetchRequest<NSFetchRequestResult> = SIGNATURE.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@",id)
            request.fetchLimit = 1
            var meetingList = try context.fetch(request) as! [MEETING]
            
            for meeting in meetingList {
                return meeting
            }
        }
        catch {
            
            print("error retriving meeting with id: \(id)")
        }
        
        return nil
    
    }
    
    
    func deleteAgenda(meetingID:String,agendaID:String)->Error?{
        
     
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = AGENDA.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@ AND meeting == %@",agendaID,meeting)
            request.fetchLimit = 1
            do{
                var agendaList = try context.fetch(request) as! [AGENDA]
                
                if agendaList.count == 1 {
                    
                    meeting.removeFromAgenda(agendaList[0])
                    try context.save()
                    print("agenda removed")
                    return nil
                }
                
                
                
                
                
            }
                
            catch{
                return error
            }
            
            return nil
        }
        
        return nil

    
    }
    
    
    func deleteActionItem(meetingID:String,actionID:String)->Error?{
        
        
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = ACTIONITEM.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@ AND meeting == %@",actionID,meeting)
            request.fetchLimit = 1
            do{
                var actionItemList = try context.fetch(request) as! [ACTIONITEM]
                
                if actionItemList.count == 1 {
                    
                    meeting.removeFromActionitem(actionItemList[0])
                    try context.save()
                    print("actionItem removed")
                    return nil
                }
                else {
                
               return nil
                }
                
                
                
                
                
                
                
            }
                
            catch{
                return error
            }
            
            return nil
        }
        
        return nil
        
        
    }

    

    
    func saveSignature(meetingID:String, signature:MTSignature)->MTSignature?{
    
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = SIGNATURE.fetchRequest()
            request.predicate = NSPredicate(format: "memberID == %d AND meeting == %@",signature.memberID,meeting)
            request.fetchLimit = 1
            do{
                var signatureList = try context.fetch(request) as! [SIGNATURE]
                
                if signatureList.count == 1 {
                    
                signatureList[0].signature = signature.signature
                    
                 try context.save()
                    print("signature saved")
                    return signatureToMTSignature(signature: signatureList[0])
                }
                
                if signatureList.count == 0 {
                    
                    
                    let sign = SIGNATURE(context: context)
                    sign.memberID = signature.memberID
                    sign.signature = signature.signature
                
                    meeting.addToSignature(sign)
                    try context.save()
                    
                    print("signature saved")
                    return signatureToMTSignature(signature: sign)
                }
                
                
                
                
            }
                
            catch{
                print("error requesting get signature")
                return nil
            }
            
            return nil
        }
        
        return nil
    }
    
    
  
    func deleteSignature(meetingID:String, memberID:Int16)->Error?{
        
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = SIGNATURE.fetchRequest()
            request.predicate = NSPredicate(format: "memberID == %d AND meeting == %@",memberID,meeting)
            request.fetchLimit = 1
            do{
                var signatureList = try context.fetch(request) as! [SIGNATURE]
                
                if signatureList.count == 1 {
                    
                    do {
                    
                    try meeting.removeFromSignature(signatureList[0])
                        return nil
                    }
                    
                    catch {
                    
                    return error
                    }
                }
                
            }
                
            catch{
                print("error requesting get signature")
                return nil
            }
            
            return nil
        }
        
        return nil
    }
    
    
    func getSignature(meetingID:String, memberID:Int16)->MTSignature?{
    
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = SIGNATURE.fetchRequest()
            request.predicate = NSPredicate(format: "memberID == %d AND meeting == %@",memberID,meeting)
            request.fetchLimit = 1
            do{
            var signatureList = try context.fetch(request) as! [SIGNATURE]
                
                if signatureList.count == 1 {
                
                    let signature = MTSignature(signature: signatureList[0].signature ?? NSData(), memberID: memberID)
                    return signature
                }
                
            }
            
            catch{
                print("error requesting get signature")
             return nil
            }
            
            return nil
        }
        
        return nil
    }
    
    
    func updateActionItem (meetingID:String , actionItem:MTActionItem)->Error?{
        
        do{
            let request: NSFetchRequest<NSFetchRequestResult> = ACTIONITEM.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@",actionItem.id!)
            request.fetchLimit = 1
            var actionItemList = try context.fetch(request) as! [ACTIONITEM]
            
            if actionItemList.count == 1 {
                actionItemList[0].title = actionItem.title
                
                
                try context.save()
                
                return nil
                
                
                
            }
            
            
            
        }
        catch{
            
            return error
        }
        
        return nil
    }
    
    func updateAgenda (meetingID:String , agenda:MTAgenda)->Error?{
        
        do{
            let request: NSFetchRequest<NSFetchRequestResult> = AGENDA.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@",agenda.id!)
            request.fetchLimit = 1
            var agendaList = try context.fetch(request) as! [AGENDA]
            
            if agendaList.count == 1 {
             agendaList[0].participants = agenda.participants
               agendaList[0].title = agenda.title
                
                
                try context.save()
                
                return nil
                
                
                
            }
                
            
            
        }
        catch{
            
            return error
        }
        
        return nil
    }

    func getAllActionItem(meetingID:String)->[MTActionItem]?{
        
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = ACTIONITEM.fetchRequest()
            request.predicate = NSPredicate(format: "meeting == %@",meeting)
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true,selector: #selector(NSString.localizedStandardCompare))]

            do{
                var actionItemList = try context.fetch(request) as! [ACTIONITEM]
                
                
                var actionItemlistMT:[MTActionItem] = []
                for agenda in actionItemList {
                    
                    actionItemlistMT.append(actionItemToMTActionItem(actionItem: agenda))
                }
                
                return actionItemlistMT
                
            }
                
            catch{
                print("error requesting get signature")
                return nil
            }
            
            return nil
        }
        
        return nil
    }
    
    
    func getAllAgenda(meetingID:String)->[MTAgenda]?{
        
        if let meeting = getMeeting(from: meetingID) {
            var request: NSFetchRequest<NSFetchRequestResult> = AGENDA.fetchRequest()
            request.predicate = NSPredicate(format: "meeting == %@",meeting)
     
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true,selector: #selector(NSString.localizedStandardCompare))]

            do{
                var agendaList = try context.fetch(request) as! [AGENDA]
                
                
                var agendalistMT:[MTAgenda] = []
                for agenda in agendaList {
                    
                   agendalistMT.append(agendaToMTAgenda(agenda: agenda))
                }
                
                return agendalistMT
                
            }
                
            catch{
                print("error requesting get signature")
                return nil
            }
            
            return nil
        }
        
        return nil
    }
    
    func updateAttendance (meetingID:String , Attendance:MTAttendance){
    
        do{
            let request: NSFetchRequest<NSFetchRequestResult> = MEETING.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@",meetingID)
            request.fetchLimit = 1
            var meetingList = try context.fetch(request) as! [MEETING]
            
            for meeting in meetingList {
                
                var request: NSFetchRequest<NSFetchRequestResult> = ATTENDANCE.fetchRequest()
                request.predicate = NSPredicate(format: "memberID == %d AND meeting == %@",Attendance.memberID,meeting)
               
               
                var attendanceList = try context.fetch(request) as! [ATTENDANCE]
                attendanceList[0].isPresent = Attendance.isPresent
                
                if Attendance.isPresent {
                    attendanceList[0].reason = ""
                }
                else {
                attendanceList[0].reason = Attendance.reason
                }
                
                do {
                
                try context.save()
                    print("saved")
                }
 

                catch {
            
                    print("error in saving \(Attendance)")
                }
            

            }
        
        }
        catch{
            
            print(error.localizedDescription)
          
        }
        
    
    }
    

    
    
    
    func resetData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MEETING")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            
           try  context.execute(deleteRequest)
            print("ALL DATA CLEARED")
        } catch let error as NSError {
              print("ERROR IN CLEARING DATA")
            // TODO: handle the error
        }
    }
    
    func completeMeeting(meetingID:String)->Error?{
        if let meeting = getMeeting(from: meetingID) {
        meeting.isMeetingEnded = true
            do {
            try context.save()
                print(meeting.isMeetingEnded)
                return nil
            }
            catch {
            return error
            }
        
        }
      return nil
    }
  
    func updateTemplate(meetingID:String,introductoryText:String,actionTitleText:String,title:String,date:NSDate)->Error?{
        if let meeting = getMeeting(from: meetingID) {
            meeting.introductoryText = introductoryText
            meeting.actionItemTitle = actionTitleText
            meeting.date = date
            meeting.title = title
            do {
                try context.save()
                print("updated template text")
                return nil
            }
            catch {
                print("error updating template text")

                return error
            }
            
        }
        return nil
    }
    
}
