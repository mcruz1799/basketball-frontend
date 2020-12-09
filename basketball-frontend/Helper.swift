//
//  Helper.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import MapKit

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
  
  static func toDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let formattedDate = dateFormatter.date(from: date)
    if let date: Date = formattedDate {
      return date
    } else {
      return Date()
    }
  }
  
  static func toAcceptableDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
  }
  
  // Credit to Robert Chen, thorntech.com
  static func parseAddress(selectedItem: MKPlacemark) -> String {
    // put a space between "4" and "Melrose Place"
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    // put a comma between street and city/state
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    // put a space between "Washington" and "DC"
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
      format:"%@%@%@%@%@%@%@",
      // street number
      selectedItem.subThoroughfare ?? "",
      firstSpace,
      // street name
      selectedItem.thoroughfare ?? "",
      comma,
      // city
      selectedItem.locality ?? "",
      secondSpace,
      // state
      selectedItem.administrativeArea ?? ""
    )
    return addressLine
  }
  
  // Credit to Robert Chen, thorntech.com
  static func parseCL(placemark: CLPlacemark?) -> String {
    if let selectedItem = placemark {
      // put a space between "4" and "Melrose Place"
      let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
      // put a comma between street and city/state
      let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
      // put a space between "Washington" and "DC"
      let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
      let addressLine = String(
        format:"%@%@%@%@%@%@%@",
        // street number
        selectedItem.subThoroughfare ?? "",
        firstSpace,
        // street name
        selectedItem.thoroughfare ?? "",
        comma,
        // city
        selectedItem.locality ?? "",
        secondSpace,
        // state
        selectedItem.administrativeArea ?? ""
      )
      return addressLine
    } else {
      return ""
    }
  }
  
  static func composeMessage(user: User?, game: Game?) -> String {
    let message = String(format: "%@%@%@%@%@%@%@",
                         user?.displayName() ?? "",
                         " is inviting you to a pick-up basketball game, ",
                         game?.name ?? "",
                         ", on ",
                         game?.onDate() ?? "",
                         " at ",
                         game?.onTime() ?? ""
    )
    return message
  }
  
  static func coordinatesToPlacemark(latitude: Double, longitude: Double, completionHandler: @escaping (CLPlacemark?)
                                      -> Void ) {
    // Use the last reported location.
    let loc = CLLocation(latitude: latitude, longitude: longitude)
    let geocoder = CLGeocoder()
    
    // Look up the location and pass it to the completion handler
    geocoder.reverseGeocodeLocation(loc,
                                    completionHandler: { (placemarks, error) in
                                      if error == nil {
                                        let firstLocation = placemarks?[0]
                                        completionHandler(firstLocation)
                                      }
                                      else {
                                        // An error occurred during geocoding.
                                        completionHandler(nil)
                                      }
                                    })
  }
  
  static func CLtoMK(placemark: CLPlacemark?) -> MKPlacemark? {
    var mk: MKPlacemark?
    if let p = placemark {
      if let address = p.postalAddress, let coordinate = p.location?.coordinate {
        mk = MKPlacemark(coordinate: coordinate, postalAddress: address)
      }
    }
    return mk
  }
  
}
