//
//  AGENDA+CoreDataProperties.swift
//  
//
//  Created by faisal khalid on 02/04/2017.
//
//

import Foundation
import CoreData


extension AGENDA {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AGENDA> {
        return NSFetchRequest<AGENDA>(entityName: "AGENDA")
    }

    @NSManaged public var participants: String?
    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var meeting: MEETING?

}
