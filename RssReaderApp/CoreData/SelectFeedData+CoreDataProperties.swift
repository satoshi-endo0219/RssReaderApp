//
//  SelectFeedData+CoreDataProperties.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/08.
//
//

import Foundation
import CoreData


extension SelectFeedData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectFeedData> {
        return NSFetchRequest<SelectFeedData>(entityName: "SelectFeedData")
    }

    @NSManaged public var url: String?
    @NSManaged public var id: String?

}

extension SelectFeedData : Identifiable {

}
