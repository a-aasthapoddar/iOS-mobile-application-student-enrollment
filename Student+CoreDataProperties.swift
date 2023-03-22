//
//  Student+CoreDataProperties.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 06/02/23.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String
    @NSManaged public var dob: String?
    @NSManaged public var place: String?

}

extension Student : Identifiable {

}
