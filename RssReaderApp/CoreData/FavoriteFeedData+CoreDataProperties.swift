//
//  FavoriteFeedData+CoreDataProperties.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/14.
//
//

import Foundation
import CoreData


extension FavoriteFeedData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteFeedData> {
        return NSFetchRequest<FavoriteFeedData>(entityName: "FavoriteFeedData")
    }

    @NSManaged public var guid: String?
    @NSManaged public var id: String?
    @NSManaged public var pubDate: String?
    @NSManaged public var titie: String?
    @NSManaged public var url: String?

}

extension FavoriteFeedData : Identifiable {

}
