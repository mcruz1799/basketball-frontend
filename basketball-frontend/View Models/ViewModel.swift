//
//  ViewModel.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation

class ViewModel: ObservableObject {
  
  var parser: Parser = Parser()
  
  @Published var games: [Games] = [Games]()
  
//  init () {
//    self.user = self.parser.update()
//  }
  
  func update() {
    self.games = self.parser.update()
  }
  
}
