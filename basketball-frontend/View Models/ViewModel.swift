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
    
  @Published var games: [Games] = [Games]()
  @Published var user: User?
  
  init () {}
  
//  unfavorite a user given a favorite id
//  :param id (Int) - favorite id
//  :return none
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
  
//  get a user by id
//  :param id (Int) - user id
//  :return none
  func getUser(id: String) {
    AF.request("http://secure-hollows-77457.herokuapp.com/users/" + String(id)).responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
      }
    }
  }
  
//  get all games
//  :param none
//  :return none
  func getGames() {
    AF.request("http://secure-hollows-77457.herokuapp.com/games").responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
      }
    }
  }
  
//  create a new user
//  :param user (User) - a User object
//  :param password (String) - user password
//  :param passwordConfirmation (String) - a confirmation of user password, should be the same as password
//  :return none
  func createUser(user: User, password: String, passwordConfirmation: String) {
    let params = [
      "firstname": user.firstName,
      "lastname": user.lastName,
      "username": user.username,
      "email": user.email,
      "dob": user.dob,
      "phone": user.phone,
      "password": password,
      "password_confirmation": passwordConfirmation
    ]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/users/", method: .post, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
      }
    }
  }
  
//  create a new game
//  :param game (Game) - a Game object
//  :return none
  func createGame(game: Game) {
    // TODO: use actual private value
    let params = [
      "name": game.name,
      "date": game.date,
      "time": game.time,
      "description": game.description,
      "private": "false",
      "longitude": game.longitude,
      "latitude": game.latitude
    ] as [String : Any]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/games/", method: .post, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<Game>> ) in
      if let value: APIData<Game> = response.value {
        print(value.data)
      }
    }
  }
  
//  edit a game
//  :param game (Game) - a Game object
//  :return none
  func editGame(game: Game) {
    let params = [
      "name": game.name,
      "date": game.date,
      "time": game.time,
      "description": game.description,
      "private": "false",
      "longitude": game.longitude,
      "latitude": game.latitude
    ] as [String : Any]
    
    let requestUrl = "http://secure-hollows-77457.herokuapp.com/games/" + String(game.id)
    
    AF.request(requestUrl, method: .patch, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<Game>> ) in
      if let value: APIData<Game> = response.value {
        print(value.data)
      }
    }
  }
  
// TODO: use authorization token in backend
//  edit a user
//  :param none
//  :return none
  func editUser() {
    let params = [
      "firstname": self.user?.firstName,
      "lastname": self.user?.lastName,
      "username": self.user?.username,
      "email": self.user?.email,
      "dob": self.user?.dob,
      "phone": self.user?.phone
    ]

    AF.request("http://secure-hollows-77457.herokuapp.com/users/", method: .patch, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
      }
    }
  }
}
