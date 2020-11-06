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
  
  var games: [Games] = []
  
  required init() {
    AF.request("http://secure-hollows-77457.herokuapp.com/games").responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
        print(self.games)
      }
    }
  }
  
  func update() -> [Games] {
    if games.isEmpty {
      _ = type(of: self).init()
    }
//    print(self.games)
    return self.games
  }
}

