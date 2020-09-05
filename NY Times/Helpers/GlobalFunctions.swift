//
//  GlobalFunctions.swift
//  NY Times
//
//  Created by David Kababyan on 05/09/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import Foundation

//number of minutes between reload of news
public let kRELOADTIME: Float = 30.0

/// Convert NYT API Timestamp to Date object
///
/// - Parameters:
///   - timestamp: The Timestamp.
///   - returns: Date object
func dateFrom(timestamp: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    return dateFormatter.date(from: timestamp) ?? Date()
}
