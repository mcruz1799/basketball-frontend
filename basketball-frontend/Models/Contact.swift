//
//  Contact.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 12/5/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI
import Contacts

class Contact: Identifiable, Comparable {
  
  // MARK: Properties
  var firstName: String = "Batman" // let's be honest, we all want Batman as a contact
  var lastName: String?
  var phone: CNPhoneNumber?
  var picture: Image?
  
  init(firstName: String = "Batman", lastName: String? = nil, phone: CNPhoneNumber? = nil, imagePath: String? = nil) {
    self.firstName = firstName
    self.lastName = lastName
    self.phone = phone
    if let image = imagePath {   // Pass the name of an xcasset image here (use this for your previews!)
      self.picture = Image(image)
    }
  }
  
  func displayPhone() -> String {
    return phone?.stringValue ?? "n/a"
  }
  func name() -> String {
    if let lN = lastName {
      return firstName + " " + lN
    } else {
      return firstName
    }
  }
  static func == (lhs: Contact, rhs: Contact) -> Bool {
    return lhs.firstName == rhs.firstName &&
      lhs.lastName == rhs.lastName &&
      lhs.phone == rhs.phone
  }
  
  static func < (lhs: Contact, rhs: Contact) -> Bool {
    if lhs.firstName == "" {
      return false
    }
    if rhs.firstName == "" {
      return true 
    }
    if let lhsLastName = lhs.lastName {
      if let rhsLastName = rhs.lastName {
        if lhs.firstName == rhs.firstName {
          return lhsLastName < rhsLastName
        }
      }
    }
    return lhs.firstName < rhs.firstName
  }
}
