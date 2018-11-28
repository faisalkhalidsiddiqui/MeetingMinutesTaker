//
//  SIGNATURE+CoreDataProperties.swift
//  
//
//  Created by faisal khalid on 3/21/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SIGNATURE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SIGNATURE> {
        return NSFetchRequest<SIGNATURE>(entityName: "SIGNATURE");
    }

    @NSManaged public var signature: NSData?
    @NSManaged public var memberID: Int16
    @NSManaged public var meeting: MEETING?

}
