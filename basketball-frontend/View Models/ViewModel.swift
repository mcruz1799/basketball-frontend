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
  
  @Published var user: Data<User>?
  
//  init () {
//    self.user = self.parser.update()
//  }
  
  func update() {
    self.user = self.parser.update()
  }
  
}
