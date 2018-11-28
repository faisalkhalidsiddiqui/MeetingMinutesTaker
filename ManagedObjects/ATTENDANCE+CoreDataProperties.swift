//
//  ATTENDANCE+CoreDataProperties.swift
//  
//
//  Created by faisal khalid on 3/21/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ATTENDANCE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ATTENDANCE> {
        return NSFetchRequest<ATTENDANCE>(entityName: "ATTENDANCE");
    }

    @NSManaged public var memberID: Int16
    @NSManaged public var isPresent: Bool
    @NSManaged public var reason: String?
    @NSManaged public var meeting: MEETING?

}
