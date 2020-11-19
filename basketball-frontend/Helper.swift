//
//  Helper.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation

class Helper {
  
  static func onTime(time: String) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let formattedTime = timeFormatter.date(from: time)
    if let time: Date = formattedTime {
      timeFormatter.dateFormat = "h:mm a"
      return timeFormatter.string(from: time)
    } else {
      return ""
    }
  }
  
  static func onDate(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let formattedDate = dateFormatter.date(from: date)
    if let date: Date = formattedDate {
      dateFormatter.dateFormat = "MM/dd/yyyy"
      return dateFormatter.string(from: date)
    } else {
      return ""
    }
  }
  
  static func toAcceptableDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
  }
}
