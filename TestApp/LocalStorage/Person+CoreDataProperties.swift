//
//  Person+CoreDataProperties.swift
//  TestApp
//
//  Created by NotyTeam Group on 03.06.2020.
//  Copyright © 2020 Vasiliy Safta. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var url: String
    @NSManaged public var title: String

}
