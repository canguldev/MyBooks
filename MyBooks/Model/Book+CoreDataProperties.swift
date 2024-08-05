//
//  Book+CoreDataProperties.swift
//  MyBooks
//
//  Created by Can Gül on 5.08.2024.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastReadPage: String?
    @NSManaged public var pages: String?
    @NSManaged public var title: String?

}

extension Book : Identifiable {

}
