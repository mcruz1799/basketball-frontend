//
//  Parser.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import Alamofire

let url: String = "http://secure-hollows-77457.herokuapp.com/"

class Parser {
  
  var games: [Game] = []
  
  required init() {
    AF.request(url + "/games").responseDecodable(of: Games.self) { response in
      if let value: Games = response.value {
        self.games = value.items
      }
    }
  }
  
  func update() -> [Game] {
    if games.isEmpty {
      _ = type(of: self).init()
    }
    return self.games
  }
}
