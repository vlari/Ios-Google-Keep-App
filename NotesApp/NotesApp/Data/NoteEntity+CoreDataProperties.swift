//
//  NoteEntity+CoreDataProperties.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/9/21.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var textContent: String?
    @NSManaged public var title: String?
    @NSManaged public var tags: String?

}

extension NoteEntity : Identifiable {

}
