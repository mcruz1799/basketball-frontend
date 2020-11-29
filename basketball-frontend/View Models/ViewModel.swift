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
  @Published var userId: Int = 1
  var headers: HTTPHeaders?
  
  @Published var game: Game?
  @Published var invited: [Users] = [Users]()
  @Published var maybe: [Users] = [Users]()
  @Published var going: [Users] = [Users]()
	
  @Published var gamePlayers: Set<Int> = Set()
  
  @Published var userLocation = Location()
  @Published var isLoaded: Bool = false
  
	init () {}
  
  //
  // USER FUNCTIONS
  //
  
  //  perform login for a user
  //  :param username (String) - username of the user
  //  :param password (String) - password of the user in plain text
  //  :return none
  func login(username: String, password: String) {
    let credentials: String = username + ":" + password
    let encodedCredentials: String = Data(credentials.utf8).base64EncodedString()

    let headers: HTTPHeaders = [
      "Authorization": "Basic " + encodedCredentials
    ]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/token/", headers: headers).responseDecodable {
      ( response: AFDataResponse<UserLogin> ) in
      if let value: UserLogin = response.value {
        let token = value.api_key
        self.createAuthHeader(token: token)
        self.refreshCurrentUser()
        self.getGames()
        self.isLoaded = true
      }
    }
  }
  
  //  refresh the current user by updating self.user
  //  :param none
  //  :return none
  func refreshCurrentUser() {
    let request = "http://secure-hollows-77457.herokuapp.com/users/" + String(self.userId)
    AF.request(request, headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
        self.players = value.data.players.map { $0.data }
        self.favorites = value.data.favorites.map { $0.data }
        self.favoritesSet = Set(self.favorites.map { $0.user.data.id })
      }
    }
  }
  
  //  get a user by id
  //  :param id (Int) - a user ID
  //  :return (User?) - a User object if one is found, nil otherwise
  func getUser(id: Int) -> User? {
    let request  = "http://secure-hollows-77457.herokuapp.com/users/" + String(id)
    var user: User? = nil
    AF.request(request, headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        user = value.data
      }
    }
    return user
  }
  
  //  create a new user
  //  :param firstName (String) - user's first name
  //  :param lastName (String) - user's last name
  //  :param username (String) - user's username
  //  :param email (String) - user's email, must be a valid email address
  //  :param dob (String) - user's date of birth, in dd-mm-yyyy format
  //  :param phone (String) - user's phone number, must be a valid phone number
  //  :param password (String) - user password, at least 6 characters
  //  :param passwordConfirmation (String) - a confirmation of user password, should be the same as password
  //  :return (User?) - a user object if the user is successfully created, nil otherwise
  func createUser(firstName: String, lastName: String, username: String, email: String, dob: String, phone: String, password: String, passwordConfirmation: String) -> User? {
    let params = [
      "firstname": firstName,
      "lastname": lastName,
      "username": username,
      "email": email,
      "dob": dob + " 00:00:00",
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation
    ]
    
    var user: User? = nil
    
    AF.request("http://secure-hollows-77457.herokuapp.com/create_user/", method: .post, parameters: params).responseDecodable {
      ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        user = value.data
      }
    }
    return user
  }
  
  //  TODO: use authorization token in backend
  //  edit the current user
  //  :param firstName (String) - first name of the user
  //  :param lastName (String) - last name of the user
  //  :param username (String) - username of the user, must be unique
  //  :param email (String) - email of the user, must be correctly formatted
  //  :param phone (String) - phone number of the user, must be correctly formatted
  //  :return none
  func editCurrentUser(firstName: String, lastName: String, username: String, email: String, phone: String) {
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
    
    AF.request("http://secure-hollows-77457.herokuapp.com/users/" + String(self.user!.id), method: .patch, parameters: params, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
      }
    }
    refreshCurrentUser()
  }
  
  //
  // GAME FUNCTIONS
  //
  
  //  get all games
  //  :param none
  //  :return none
  func getGames() {
    AF.request("http://secure-hollows-77457.herokuapp.com/games", headers: self.headers!).responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
      }
    }
  }
  
  func getGame(id: Int) {
    AF.request("http://secure-hollows-77457.herokuapp.com/games/" + String(id), headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<Game>> ) in
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
  
  //  TODO: instead of assigning game to self.game, use the return value instead
  //  create a new game
  //  :param name (String) - name of the game court
  //  :date (Date) - date and time of the game
  //  :description (String) - description of the game
  //  :priv (Bool) - whether the game is private
  //  :latitude (Double) - latitude of the game location
  //  :longitude: (Double) - longitude of the game location
  //  :return (Game?) - the game object if created successfully, nil otherwise
  func createGame(name: String, date: Date, description: String, priv: Bool, latitude: Double, longitude: Double) -> Game? {
    let acceptableDate = Helper.toAcceptableDate(date: date)
    let params: Parameters = [
      "name": name,
      "date": acceptableDate,
      "time": acceptableDate,
      "description": description,
      "private": priv,
      "longitude": longitude,
      "latitude": latitude
    ]
    
    var game: Game? = nil
    AF.request("http://secure-hollows-77457.herokuapp.com/games", method: .post, parameters: params, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<Game>> ) in
      if let value: APIData<Game> = response.value {
        self.game = value.data
        game = value.data
        
        let player: Player? = self.createPlayer(status: "going", userId: self.user!.id, gameId: value.data.id)
        
        if (player != nil) {
          self.getGame(id: self.game!.id)
          self.players.insert(player!, at: 0)
        }
      }
    }
    return game
  }
  
  //  edit a game
  //  :param game (Game) - a Game object
  //  :return (Game) - the edited game object if successful, the previous game object otherwise
  func editGame(game: Game) -> Game {
    let params = [
      "name": game.name,
      "date": game.date,
      "time": game.time,
      "description": game.description,
      "private": "false",
      "longitude": game.longitude,
      "latitude": game.latitude
    ] as [String : Any]
    
    var game: Game = game
    let requestUrl = "http://secure-hollows-77457.herokuapp.com/games/" + String(game.id)
    
    AF.request(requestUrl, method: .patch, parameters: params, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<Game>> ) in
      if let value: APIData<Game> = response.value {
        game = value.data
      }
    }
    return game
  }
  
  //  calls getGames and creates a game annotation object for each game
  //  :param none
  //  :return (Bool) - true if self.gameAnnotations has been loaded, false otherwise

  
  //  convert games data to format accepted by mapView
  //  :param none
  //  :return none

  
  //
  // FAVORITE FUNCTIONS
  //
  
  //  favorite another user and refresh the user info
  //  :param favoriterId (Int) - user ID of the favoriter
  //  :param favoriteeId (Int) - user ID of the favoritee
  //  :return (Favorite?) the result Favorite object if successful, nil otherwise
  func favorite(favoriterId: Int, favoriteeId: Int) -> Favorite? {
    let params = [
      "favoriter_id": favoriterId,
      "favoritee_id": favoriteeId
    ]
    
    var favorite: Favorite? = nil
    
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites", method: .post, parameters: params, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<Favorite>> ) in
      if let value: APIData<Favorite> = response.value {
        self.refreshCurrentUser()
        favorite = value.data
      }
    }
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
  
  // unfavorite another user
  // :param favoriteeId (Int) - user ID of the user being unfavorited
  // :return none
  func unfavorite(favoriteeId: Int) {
    let id = self.favorites.filter({ $0.favoritee_id == favoriteeId })[0].id
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<Favorite>> ) in
      if let value: APIData<Favorite> = response.value {
        print(value.data)
      }
    }
    refreshCurrentUser()
  }
  
  //
  // PLAYER FUNCTIONS
  //
  
  //  create a player
  //  :param status (String) - status of the player, can be "going", "maybe", "invited", or "not_going"
  //  :param userId (String) - user ID of the player
  //  :param gameId (String) - game ID of the player
  func createPlayer(status: String, userId: Int, gameId: Int) -> Player? {
    let params = [
      "status": status,
      "user_id": String(userId),
      "game_id": String(gameId)
    ]
    
    var player: Player? = nil
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players", method: .post, parameters: params, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<Player>>) in
      if let value: APIData<Player> = response.value {
        self.getGame(id: self.game!.id)
        player = value.data
      }
    }
    return player
  }
  
  // edit the status of a player belonging to the current user
  // :param playerId (Int) - ID of the player
  // :param status (String) - status of the player, can be "going", "maybe", "invited", "not_going", "I'm going", "I'm Invited", "I'm Maybe", or "I'm Not Going"
  // :return none
  func editPlayerStatus(playerId: Int, status: String) {
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
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(playerId), method: .patch, parameters: params, headers: self.headers!).responseDecodable {
      ( response: AFDataResponse<APIData<Player>> ) in
      if let _: APIData<Player> = response.value {
        self.getGame(id: self.game!.id)
      }
    }
    refreshCurrentUser()
    fetchData()
  }
  
  //
  // MISC. FUNCTIONS
  //
  
  func isInvited(favorite: Favorite) -> Bool {
    return true
  }
  
  func fetchData() {
    login(username: "jxu", password: "secret")
  }
  
  func forStatus(users: [Users]) -> [(user: Users, favorited: Bool)] {
    return users.map({ (user: $0, favorited: self.favoritesSet.contains($0.id)) })
  }
  
  func favoritesNotInvited() -> [(favorite: Favorite, invited: Bool)] {
    return self.favorites.map({ (favorite: $0, invited: self.gamePlayers.contains($0.user.data.id)) })
  }
  
  func createAuthHeader(token: String) {
    self.headers = [
      "Authorization": "Token " + token
    ]
  }
}
