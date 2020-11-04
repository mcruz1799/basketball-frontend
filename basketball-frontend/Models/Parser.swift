//
//  Parser.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import Alamofire

let url: String = "http://secure-hollows-77457.herokuapp.com"

class Parser {
  
  var user: Data<User>?
  
  required init() {
    print("CONSOLE")


    AF.request("http://secure-hollows-77457.herokuapp.com/users/1").responseDecodable(of: Data<User>.self) { response in
      if let value: Data<User> = response.value {
        self.user = value
      }
    }
  }
  
  func update() -> Data<User>? {
    if user != nil {
      return self.user
    } else {
      _ = type(of: self).init()
    }
    return self.user
  }
}
