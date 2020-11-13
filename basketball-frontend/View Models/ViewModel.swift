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
  @Published var favoritesSet: Set<Int> = Set()
  
  @Published var game: Game?
  @Published var invited: [Users] = [Users]()
  @Published var maybe: [Users] = [Users]()
  @Published var going: [Users] = [Users]()
  @Published var gamePlayers: Set<Int> = Set()
  
  @Published var userLocation = Location()  
  
  
  init () {}
  
  //  unfavorite a user given a favorite id
  //  :param id (Int) - favorite id
  //  :return none
  func unfavorite(id: Int) {
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil).responseDecodable {
      ( response: AFDataResponse<APIData<Favorite>> ) in
      if let value: APIData<Favorite> = response.value {
        print(value.data)
      }
    }
    self.getUser(id: String(self.user!.id))
  }
  
  //  favorite another user and refresh the user info
  //  :param favorite (Favorite) - a Favorite object
  //  :return none
//  func favorite(favorite: Favorite) {
    //  favorite another user and refresh the user info but with IDs
    //  :param favoriterId (Int) - user ID of the favoriter
    //  :param favoriteeId (Int) - user ID of the favoritee
    //  :return (Favorite?) the result Favorite object if successful, nil otherwise
    func favoriteWithIds(favoriterId: Int, favoriteeId: Int) -> Favorite? {
      let params = [
        "favoriter_id": favoriterId,
        "favoritee_id": favoriteeId
      ]
      
      var favorite: Favorite? = nil
      
      AF.request("http://secure-hollows-77457.herokuapp.com/favorites", method: .post, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        if let value: APIData<Favorite> = response.value {
          self.getUser(id: String(self.user!.id))
          favorite = value.data
        }
      }
      return favorite
    }
    
    //  favorite another user and refresh the user info
    //  :param favorite (Favorite) - a Favorite object
    //  :return (Favorite?) the result Favorite object if successful, nil otherwise
    func favorite(favorite: Favorite) -> Favorite? {
      let params = [
        "favoriter_id": favorite.favoriter_id,
        "favoritee_id": favorite.favoritee_id
      ]
      
      var favorite: Favorite? = nil
      
      AF.request("http://secure-hollows-77457.herokuapp.com/favorites", method: .post, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        if let value: APIData<Favorite> = response.value {
          self.getUser(id: String(self.user!.id))
          favorite = value.data
        }
      }
      getUser(id: String(self.user!.id))
      return favorite
    }
    
    
    //  check if a user is favorited by the current user
    //  :param userId (Int) - a user ID of the potential favoritee
    //  :return (Bool) true if userId is a favorite of the current user, false otherwise
    func isFavorite(userId: Int) -> Bool {
      for favorite in self.favorites {
        if (favorite.favoritee_id == userId) {
          return true
        }
      }
      return false
    }
    
    //  find a favorite object in self.favorites given favoriter and favoritee
    //  :param favoriterId (Int) - user ID of the favoriter
    //  :param favoriteeId (Int) - user ID of the favoritee
    //  :return (Favorite?) a Favorite object if a match is found, nil otherwise
    func findFavorite(favoriterId: Int, favoriteeId: Int) -> Favorite? {
      for favorite in self.favorites {
        if (favorite.favoriter_id == favoriterId && favorite.favoritee_id == favoriteeId) {
          return favorite
        }
      }
      return nil
    }
    
    func favoriteUser(favoriter_id: Int, favoritee_id: Int) {
      let params = [
        "favoriter_id": favoriter_id,
        "favoritee_id": favoritee_id
      ]
      AF.request("http://secure-hollows-77457.herokuapp.com/favorites", method: .post, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        if let value: APIData<Favorite> = response.value {
          print(value.data)
        }
      }
      getUser(id: String(self.user!.id))
    }
    
    func unfavoriteUser(favoriter_id: Int, favoritee_id: Int) {
      let id = self.favorites.filter({ $0.favoritee_id == favoritee_id })[0].id
      AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil).responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        if let value: APIData<Favorite> = response.value {
          print(value.data)
        }
      }
      getUser(id: String(self.user!.id))
    }
    
    func isInvited(favorite: Favorite) -> Bool {
      return true
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
          self.favoritesSet = Set(self.favorites.map { $0.user.data.id })
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
    
    func getGame(id: Int) {
      AF.request("http://secure-hollows-77457.herokuapp.com/games/" + String(id)).responseDecodable { ( response: AFDataResponse<APIData<Game>> ) in
        if let value: APIData<Game> = response.value {
          self.game = value.data
          self.invited = value.data.invited.map { $0.data }
          self.maybe = value.data.maybe.map { $0.data }
          self.going = value.data.going.map { $0.data }
          let arr = self.invited + self.maybe + self.going
          self.gamePlayers = Set(arr.map { $0.id })
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
    
    // TODO: use actual private value
    //  create a new game
    //  :param game (Game) - a Game object
    //  :return none
    func createGame(game: Games, date: Date, latitude: Double, longitude: Double) {
      // TODO: use actual private value
      let acceptableDate = Helper.toAcceptableDate(date: date)
      let params: Parameters = [
        "name": game.name,
        "date": acceptableDate,
        "time": acceptableDate,
        "description": game.description,
        "private": game.priv,
        "longitude": longitude,
        "latitude": latitude
      ] as [String : Any]
      
      AF.request("http://secure-hollows-77457.herokuapp.com/games", method: .post, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Game>> ) in
        if let value: APIData<Game> = response.value {
          self.game = value.data
          let gameParams: Parameters = [
            "status": "going",
            "user_id": self.user!.id,
            "game_id": value.data.id
          ]
          
          AF.request("http://secure-hollows-77457.herokuapp.com/players", method: .post, parameters: gameParams).responseDecodable {
            ( response: AFDataResponse<APIData<Player>>) in
            if let value: APIData<Player> = response.value {
              print(value.data) // 4
              self.getGame(id: self.game!.id)
              self.players.insert(value.data, at: 0)
            }
          }
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
    //  :param firstName (String) - first name of the user
    //  :param lastName (String) - last name of the user
    //  :param username (String) - username of the user, must be unique
    //  :param email (String) - email of the user, must be correctly formatted
    //  :param phone (String) - phone number of the user, must be correctly formatted
    //  :return none
    func editUser(firstName: String, lastName: String, username: String, email: String, phone: String) {
      let params = [
        "firstname": firstName,
        "lastname": lastName,
        "username": username,
        "email": email,
        "dob": self.user?.dob,
        "phone": phone,
        "password": "secret",
        "password_confirmation": "secret"
      ]
      
      AF.request("http://secure-hollows-77457.herokuapp.com/users/" + String(self.user!.id), method: .patch, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<User>> ) in
        if let value: APIData<User> = response.value {
          self.user = value.data
        }
      }
      
      getUser(id: String(self.user!.id))
    }
    
    
    //  invite a user to a game
    //  :param userID (Int) - a user ID
    //  :param gameID (Int) - a game ID
    //  :return none
    func inviteToGame(userID: Int, gameID: Int) {
      let params: Parameters = [
        "status": "invited",
        "user_id": userID,
        "game_id": gameID
      ]
      
      AF.request("http://secure-hollows-77457.herokuapp.com/players/", method: .post, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Player>>) in
        if let value: APIData<Player> = response.value {
          print(value.data)
          self.getGame(id: self.game!.id)
        }
      }
    }
    
    func updateStatus(player_id: Int, status: String) {
      var s = ""
      
      if (status == "I'm Going") {
        s = "going"
      } else if (status == "I'm Invited") {
        s = "invited"
      } else if (status == "I'm Maybe") {
        s = "maybe"
      } else if (status == "I'm Not Going") {
        s = "not_going"
      } else {
        s = status
      }
      
      let params: Parameters = [
        "status": s
      ]
      
      print(player_id)
      
      AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(player_id), method: .patch, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Player>> ) in
        if let value: APIData<Player> = response.value {
          print(value)
          self.getGame(id: self.game!.id)
        }
      }
      getUser(id: "4")
    }
    
    //  change the status of a player (can be used to edit player as well)
    //  :param player (Player) - a Player object with the updated status ("going", "maybe", "invited". "not_going")
    //  :return none
    func changePlayerStatus(player: Player) {
      let params = [
        "status": player.status,
        "user_id": String(player.userId),
        "game_id": String(player.game.data.id)
      ]
      
      AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(player.id), method: .patch, parameters: params).responseDecodable {
        ( response: AFDataResponse<APIData<Player>>) in
        if let value: APIData<Player> = response.value {
          print(value.data)
        }
      }
    }
    
    func favoritesNotInvited() -> [(favorite: Favorite, invited: Bool)] {
      return self.favorites.map({ (favorite: $0, invited: self.gamePlayers.contains($0.user.data.id)) })
    }
    
    func forStatus(users: [Users]) -> [(user: Users, favorited: Bool)] {
      return users.map({ (user: $0, favorited: self.favoritesSet.contains($0.id)) })
    }
  }
