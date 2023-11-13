//
//  DateUtils.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/13.
//

import Foundation

class DateUtils {
    class func dateFromString(dateString: String) -> Date {
        let format = "yyyy/MM/dd HH:mm:ss"

        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateString) else {
            return Date()
        }
        return date
    }
}
