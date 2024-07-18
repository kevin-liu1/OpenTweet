//
//  DateFormatter.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-18.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

class DateFormat {
    static func formatDateFromString(_ date: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: date)
    }
    static func convertToPrettyString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
