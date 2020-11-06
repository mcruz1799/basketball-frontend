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
  @Published var user: User?
  @Published var groupedGames: Dictionary<String, [Games]> = Dictionary<String, [Games]>()
  
  init () {}
  
  func groupGames() {
    self.groupedGames = Dictionary(grouping: self.games, by: {$0.date })
  }
  
  func unfavorite(id: Int) {
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
      do {
        guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
          print("Error: Cannot convert data to JSON object")
          return
        }
        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
          print("Error: Cannot convert JSON object to Pretty JSON data")
          return
        }
        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
          print("Error: Could print JSON in String")
          return
        }
        
        print(prettyPrintedJson)
      } catch {
        print("Error: Trying to convert JSON data to string")
        return
      }
    }
  }
  
  func getUser(username: String) {
    AF.request("http://secure-hollows-77457.herokuapp.com/users/1").responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
        print(self.user)
      }
    }
  }
  
  func update() {
    self.games = self.parser.update()
    AF.request("http://secure-hollows-77457.herokuapp.com/games").responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
      }
    }
  }
  
}
