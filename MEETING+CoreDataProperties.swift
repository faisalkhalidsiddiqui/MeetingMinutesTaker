//
//  MEETING+CoreDataProperties.swift
//  
//
//  Created by faisal khalid on 3/28/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MEETING {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MEETING> {
        return NSFetchRequest<MEETING>(entityName: "MEETING");
    }

    @NSManaged public var actionItemTitle: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var introductoryText: String?
    @NSManaged public var isMeetingEnded: Bool
    @NSManaged public var title: String?
    @NSManaged public var actionitem: NSSet?
    @NSManaged public var agenda: NSSet?
    @NSManaged public var attendance: NSSet?
    @NSManaged public var signature: NSSet?

}

// MARK: Generated accessors for actionitem
extension MEETING {

    @objc(addActionitemObject:)
    @NSManaged public func addToActionitem(_ value: ACTIONITEM)

    @objc(removeActionitemObject:)
    @NSManaged public func removeFromActionitem(_ value: ACTIONITEM)

    @objc(addActionitem:)
    @NSManaged public func addToActionitem(_ values: NSSet)

    @objc(removeActionitem:)
    @NSManaged public func removeFromActionitem(_ values: NSSet)

}

// MARK: Generated accessors for agenda
extension MEETING {

    @objc(addAgendaObject:)
    @NSManaged public func addToAgenda(_ value: AGENDA)

    @objc(removeAgendaObject:)
    @NSManaged public func removeFromAgenda(_ value: AGENDA)

    @objc(addAgenda:)
    @NSManaged public func addToAgenda(_ values: NSSet)

    @objc(removeAgenda:)
    @NSManaged public func removeFromAgenda(_ values: NSSet)

}

// MARK: Generated accessors for attendance
extension MEETING {

    @objc(addAttendanceObject:)
    @NSManaged public func addToAttendance(_ value: ATTENDANCE)

    @objc(removeAttendanceObject:)
    @NSManaged public func removeFromAttendance(_ value: ATTENDANCE)

    @objc(addAttendance:)
    @NSManaged public func addToAttendance(_ values: NSSet)

    @objc(removeAttendance:)
    @NSManaged public func removeFromAttendance(_ values: NSSet)

}

// MARK: Generated accessors for signature
extension MEETING {

    @objc(addSignatureObject:)
    @NSManaged public func addToSignature(_ value: SIGNATURE)

    @objc(removeSignatureObject:)
    @NSManaged public func removeFromSignature(_ value: SIGNATURE)

    @objc(addSignature:)
    @NSManaged public func addToSignature(_ values: NSSet)

    @objc(removeSignature:)
    @NSManaged public func removeFromSignature(_ values: NSSet)

}
