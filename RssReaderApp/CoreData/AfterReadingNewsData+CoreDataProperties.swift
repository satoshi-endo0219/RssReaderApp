//
//  AfterReadingNewsData+CoreDataProperties.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/16.
//
//

import Foundation
import CoreData


extension AfterReadingNewsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AfterReadingNewsData> {
        return NSFetchRequest<AfterReadingNewsData>(entityName: "AfterReadingNewsData")
    }

    @NSManaged public var id: String?
    @NSManaged public var guid: String?
    @NSManaged public var url: String?
    @NSManaged public var pubDate: String?
    @NSManaged public var title: String?

}

extension AfterReadingNewsData : Identifiable {

}
