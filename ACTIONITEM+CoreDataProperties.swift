//
//  ACTIONITEM+CoreDataProperties.swift
//  
//
//  Created by faisal khalid on 02/04/2017.
//
//

import Foundation
import CoreData


extension ACTIONITEM {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ACTIONITEM> {
        return NSFetchRequest<ACTIONITEM>(entityName: "ACTIONITEM")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var meeting: MEETING?

}
