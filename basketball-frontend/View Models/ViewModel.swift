//
//  ViewModel.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import Alamofire

class ViewModel: ObservableObject {
  
  var parser: Parser = Parser()
  
  @Published var games: [Games] = [Games]()
  @Published var groupedGames: Dictionary<String, [Games]> = Dictionary<String, [Games]>()
  
  //  init () {
  //    self.user = self.parser.update()
  //  }
  
  func groupGames() {
    self.groupedGames = Dictionary(grouping: self.games, by: {$0.date })
  }
  
  func update() {
    AF.request("http://secure-hollows-77457.herokuapp.com/games").responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
        print(self.games)
      }
    }
  }
  
}
