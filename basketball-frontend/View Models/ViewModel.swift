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
  @Published var players: [Player] = [Player]()
  @Published var favorites: [Favorite] = [Favorite]()
  
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
  
//  favorite another user and refresh the user info
//  :param favorite (Favorite) - a Favorite object
//  :return none
  func favorite(favorite: Favorite) {
    let params = [
      "favoriter_id": favorite.favoriter_id,
      "favoritee_id": favorite.favoritee_id
    ]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites", method: .post, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<Favorite>> ) in
      if let value: APIData<Favorite> = response.value {
        print(value.data)
      }
    }
    
    getUser(id: String(self.user!.id))
  }
  
  func fetchData() {
    print("Fetch Data")
    getUser(id: "4")
    getGames()
  }
  
//  get a user by id
//  :param id (Int) - user id
//  :return none
  func getUser(id: String) {
    AF.request("http://secure-hollows-77457.herokuapp.com/users/4").responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      print(response)
      if let value: APIData<User> = response.value {
        self.user = value.data
        print(self.user as Any)
        self.players = value.data.players.map { $0.data }
        self.favorites = value.data.favorites.map { $0.data }
        print(self.favorites)
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
      "phone": self.user?.phone,
      "password": "secret",
      "password_confirmation": "secret"
    ]

    AF.request("http://secure-hollows-77457.herokuapp.com/users/", method: .patch, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
      }
    }
  }
  
  
//  invite a user to a game
//  :param userId (String) - a user ID
//  :param gameId (String) - a game ID
//  :return none
  func inviteToGame(userId: String, gameId: String) {
    let params = [
      "status": "invited",
      "user_id": userId,
      "game_id": gameId
    ]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players/", method: .post, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<Player>>) in
      if let value: APIData<Player> = response.value {
        print(value.data)
      }
    }
  }
  
//  change the status of a player (can be used to edit player as well)
//  :param player (Player) - a Player object with the updated status ("going", "maybe", "invited")
//  :return none
  func changePlayerStatus(player: Player) {
    let params = [
      "status": player.status,
      "user_id": String(player.userId),
      "game_id": String(player.gameId)
    ]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(player.id), method: .patch, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<Player>>) in
      if let value: APIData<Player> = response.value {
        print(value.data)
      }
    }
  }
}
