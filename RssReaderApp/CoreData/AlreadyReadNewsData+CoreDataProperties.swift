//
//  AlreadyReadNewsData+CoreDataProperties.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/15.
//
//

import Foundation
import CoreData


extension AlreadyReadNewsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlreadyReadNewsData> {
        return NSFetchRequest<AlreadyReadNewsData>(entityName: "AlreadyReadNewsData")
    }

    @NSManaged public var guid: String?
    @NSManaged public var id: String?

}

extension AlreadyReadNewsData : Identifiable {

}
