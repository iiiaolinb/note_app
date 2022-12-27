//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Егор Худяев on 21.12.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var name: String?
    @NSManaged public var text: NSAttributedString?
    @NSManaged public var date: String?

}

extension Note : Identifiable {

}
