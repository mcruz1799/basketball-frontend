//
//  ViewModel.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//
import Foundation
import Alamofire
import SwiftUI
import Photos
import Contacts
import MessageUI

class ViewModel: ObservableObject {
  
  let appDelegate: AppDelegate = AppDelegate()
  
  @Published var games: [Games] = [Games]()
  @Published var user: User?
  @Published var players: [Player] = [Player]()
  @Published var groupedPlayers: [Dictionary<String, [Player]>.Element] = [Dictionary<String, [Player]>.Element]()
  // Set of games associated with the players of the user
  @Published var playersSet: Set<Int> = Set()
  @Published var favorites: [Favorite] = [Favorite]()
  @Published var favoritesSet: Set<Int> = Set()
  @Published var userId: Int?
  var headers: HTTPHeaders?
  
  @Published var game: Game?
  @Published var player: Player?
  @Published var invited: [Users] = [Users]()
  @Published var maybe: [Users] = [Users]()
  @Published var going: [Users] = [Users]()
  
  @Published var gamePlayers: Set<Int> = Set()
  
  @Published var userLocation = Location()
  @Published var currentScreen: String = "landing"
	@Published var currentTab: String = "home"
  @Published var searchResults: [Users] = [Users]()
  @Published var isLoaded: Bool = false
  @Published var alert: Alert?
  @Published var showAlert: Bool = false
  @Published var showDetails: Bool = false
  @Published var creatingGame: Bool = false
  
  @Published var contacts: [Contact] = [Contact]()
  @Published var contactsFiltered: [Contact] = [Contact]()
  
  init () {}
  
  //
  // USER FUNCTIONS
  //
  
  //  perform login for a user
  //  :param username (String) - username of the user
  //  :param password (String) - password of the user in plain text
  //  :return none
  func login(username: String, password: String) {
    self.currentScreen = "login-splash"
    let credentials: String = username + ":" + password
    let encodedCredentials: String = Data(credentials.utf8).base64EncodedString()
    
    let headers: HTTPHeaders = [
      "Authorization": "Basic " + encodedCredentials
    ]
    
    AF.request("http://secure-hollows-77457.herokuapp.com/token/", headers: headers)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<UserLogin> ) in
        switch response.result {
        case .success:
          if let value: UserLogin = response.value {
            let token = value.api_key
            self.userId = value.id
            self.createAuthHeader(token: token)
            self.refreshCurrentUser()
            self.getGames()
            self.fetchContacts()
            self.currentScreen = "app"
          }
        case .failure:
          self.currentScreen = "login"
          self.alert = self.createAlert(title: "Invalid Login",
                                        message: "The username or password you entered was invalid",
                                        button: "Got it")
          self.showAlert = true
        }
      }
  }
  
  //  perform logout for a user by clearing all stored variables in ViewModel
  //  :param none
  //  :return none
  func logout() {
    self.games = [Games]()
    self.user = nil
    self.players = [Player]()
    self.playersSet = Set()
    self.favorites = [Favorite]()
    self.favoritesSet = Set()
    self.userId = nil
    self.headers = nil
    self.game = nil
    self.invited = [Users]()
    self.maybe = [Users]()
    self.going = [Users]()
    self.gamePlayers = Set()
    self.userLocation = Location()
    self.currentScreen = "landing"
    self.searchResults = [Users]()
    self.isLoaded = false
    self.alert = nil
    self.showAlert = false
  }
  
  //  refresh the current user by updating self.user
  //  :param none
  //  :return none
  func refreshCurrentUser() {
    let request = "http://secure-hollows-77457.herokuapp.com/users/" + String(self.userId!)
    AF.request(request, headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
        self.players = value.data.players.map { $0.data }
        self.groupedPlayers = self.groupPlayers(players: self.players)
        self.playersSet = Set(self.players.map { $0.game.data.id })
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
  //  :param dob (Date) - user's date of birth
  //  :param phone (String) - user's phone number, must be a valid phone number
  //  :param password (String) - user password, at least 6 characters
  //  :param passwordConfirmation (String) - a confirmation of user password, should be the same as password
  //  :return (User?) - a user object if the user is successfully created, nil otherwise
  func createUser(firstName: String, lastName: String, username: String, email: String, dob: Date, phone: String, password: String, passwordConfirmation: String) -> User? {
    let acceptableDate = Helper.toAcceptableDate(date: dob)
    let params = [
      "firstname": firstName,
      "lastname": lastName,
      "username": username,
      "email": email,
      "dob": acceptableDate,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation
    ]
    
    var user: User? = nil
    
    AF.request("http://secure-hollows-77457.herokuapp.com/create_user/", method: .post, parameters: params)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<User>> ) in
        switch response.result {
        case .success:
          if let value: APIData<User> = response.value {
            user = value.data
            self.login(username: username, password: password)
          }
        case .failure:
          self.alert = self.createAlert(title: "Invalid Profile Information",
                                        message: "The profile information you entered was invalid, please check your inputs and try again",
                                        button: "Got it")
          self.showAlert = true
        }
      }
    return user
  }
  
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
    
    AF.request("http://secure-hollows-77457.herokuapp.com/users/" + String(self.user!.id), method: .patch, parameters: params, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<User>> ) in
        switch response.result {
        case .success:
          if let value: APIData<User> = response.value {
            self.user = value.data
            self.refreshCurrentUser()
          }
        case .failure:
          self.alert = self.createAlert(title: "Invalid Profile Information",
                                        message: "The edited profile information you entered was invalid, please check your inputs and try again",
                                        button: "Try again")
          self.showAlert = true
        }
      }
  }
  
  //
  // GAME FUNCTIONS
  //
  
  //  get all games
  //  :param none
  //  :return none
  func getGames() {
    let params: Parameters = [
      "user_id": self.userId
    ]
    AF.request("http://secure-hollows-77457.herokuapp.com/get_games", method: .get, parameters: params, headers: self.headers!).responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
      }
    }
  }
  
  func getGame(id: Int?) {
    if let i = id {
      AF.request("http://secure-hollows-77457.herokuapp.com/games/" + String(i), headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<Game>> ) in
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
  }
  
  func findPlayer(gameId: String) {
    if let i = Int(gameId) {
      let players = self.players.filter({ $0.game.data.id == i })
      // There is already a player object associated with this game
      if players.count >= 1 {
        self.player = players.first
      } else {
        self.player = nil
      }
    }
  }
  
  func startCreating() {
    self.creatingGame = true
  }
  
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
      switch response.result {
      case .success:
        if let value: APIData<Game> = response.value {
          if let value: APIData<Game> = response.value {
            self.game = value.data
            game = self.game
            self.creatingGame = false
            self.showDetails = true
            self.createPlayer(status: "going", userId: self.user!.id, gameId: value.data.id)
            if let newGame = self.game {
              let newGame = Games(id: newGame.id, name: newGame.name, date: newGame.date, time: newGame.time, description: newGame.description, priv: newGame.priv, longitude: newGame.longitude, latitude: newGame.latitude)
              self.games.append(newGame)
            }
          }
        }
      case .failure:
        print(response.result)
        self.alert = Alert(title: Text("Create Game Failed"),
                           message: Text("Failed to create this game, please try again"),
                           primaryButton: .default(
                            Text("Try Again"),
                            action: {
                              self.createGame(name: name, date: date, description: description, priv: priv, latitude: latitude, longitude: longitude)
                            }
                           ),
                           secondaryButton: .default(
                            Text("Close"),
                            action: {
                              self.showAlert = false
                              self.alert = nil
                            }
                           )
        )
        self.showAlert = true
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
    
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites", method: .post, parameters: params, headers: self.headers!)
      .validate(statusCode: 200..<300)
      .responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        switch response.result {
        case .success:
          if let value: APIData<Favorite> = response.value {
            self.refreshCurrentUser()
            favorite = value.data
          }
        case .failure:
          print(response.result)
          self.alert = Alert(title: Text("Favorite Failed"),
                             message: Text("Failed to favorite this user, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.favorite(favoriterId: favoriterId, favoriteeId: favoriteeId)
                              }
                             ),
                             secondaryButton: .default(
                              Text("Close"),
                              action: {
                                self.showAlert = false
                                self.alert = nil
                              }
                             )
          )
          self.showAlert = true
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
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        switch response.result {
        case .success:
          if let _: APIData<Favorite> = response.value {
            self.refreshCurrentUser()
          }
        case .failure:
          self.alert = Alert(title: Text("Unfavorite Failed"),
                             message: Text("Failed to unfavorite this user, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.unfavorite(favoriteeId: favoriteeId)
                              }
                             ),
                             secondaryButton: .default(
                              Text("Close"),
                              action: {
                                self.showAlert = false
                                self.alert = nil
                              }
                             )
          )
          self.showAlert = true
        }
      }
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
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players", method: .post, parameters: params, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<Player>>) in
        switch response.result {
        case .success:
          if let value: APIData<Player> = response.value {
            self.getGame(id: self.game!.id)
            player = value.data
            self.players.insert(player!, at: 0)
            self.player = value.data
          }
        case .failure:
          self.alert = Alert(title: Text("Create Player Failed"),
                             message: Text("Failed to add this user to this game, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.createPlayer(status: status, userId: userId, gameId: gameId)
                              }
                             ),
                             secondaryButton: .default(
                              Text("Close"),
                              action: {
                                self.showAlert = false
                                self.alert = nil
                              }
                             )
          )
          self.showAlert = true
        }
      }
    return player
  }
  
  //  invite a player to a game
  //  :param status (String) - status of the player, can be "going", "maybe", "invited", or "not_going"
  //  :param userId (String) - user ID of the player
  //  :param gameId (String) - game ID of the player
  func inviteUser(status: String, userId: Int, gameId: Int) -> Player? {
    let params = [
      "status": status,
      "user_id": String(userId),
      "game_id": String(gameId)
    ]
    
    var player: Player? = nil
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players", method: .post, parameters: params, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<Player>>) in
        switch response.result {
        case .success:
          if let value: APIData<Player> = response.value {
            self.getGame(id: self.game!.id)
            player = value.data
            self.players.insert(player!, at: 0)
          }
        case .failure:
          self.alert = Alert(title: Text("Create Player Failed"),
                             message: Text("Failed to add this user to this game, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.createPlayer(status: status, userId: userId, gameId: gameId)
                              }
                             ),
                             secondaryButton: .default(
                              Text("Close"),
                              action: {
                                self.showAlert = false
                                self.alert = nil
                              }
                             )
          )
          self.showAlert = true
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
    print(params)
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(playerId), method: .patch, parameters: params, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<Player>> ) in
        switch response.result {
        case .success:
          print(response.result)
          
          if let player: APIData<Player> = response.value {
            self.getGame(id: self.game!.id)
            self.refreshCurrentUser()
            self.player = player.data
          }
        case .failure:
          print(response.result)
          
          self.alert = Alert(title: Text("Edit Player Status Failed"),
                             message: Text("Failed to edit the status of this player, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.editPlayerStatus(playerId: playerId, status: status)
                              }
                             ),
                             secondaryButton: .default(
                              Text("Close"),
                              action: {
                                self.showAlert = false
                                self.alert = nil
                              }
                             )
          )
          self.showAlert = true
        }
      }
  }
  
  //  get all players of a specific status
  //  :param status (String) - status of a player, can be "going", "maybe", "invited", or "not_going"
  //  :return ([Player]) - an array of Player objects with the specified status
  func getPlayerWithStatus(status: String) -> [Player] {
    var filteredResults: [Player] = [Player]()
    
    for player in self.players {
      if (player.status == status) {
        filteredResults.append(player)
      }
    }
    return filteredResults
  }
  
  //
  // MISC. FUNCTIONS
  //
  
  func fetchData() {
    login(username: "jxu", password: "secret")
  }
  
  // map a boolean to a list of users representing if they are favorited or not
  // :param users ([Users]) - list of the users
  // :return ([(User, Bool)]) - list of users with a tag for if they are favorited or not
  func forStatus(users: [Users]) -> [(user: Users, favorited: Bool)] {
    return users.map({ (user: $0, favorited: self.favoritesSet.contains($0.id)) })
  }
  
  // map a boolean to the list of favorites representing if they are invited or not
  // :return ([(Favorite, Bool)]) - list of users with a tag for if they are invited or not
  func favoritesNotInvited() -> [(favorite: Favorite, invited: Bool)] {
    return self.favorites.map({ (favorite: $0, invited: self.gamePlayers.contains($0.user.data.id)) })
  }
  
  // search the database for users
  // :param query (String) - query to send to the database
  // :return none
  func searchUsers(query: String) {
    let params = [
      "query": query.lowercased()
    ]
    let request  = "http://secure-hollows-77457.herokuapp.com/search"
    AF.request(request, method: .get, parameters: params).responseDecodable { ( response: AFDataResponse<ListData<Users>> ) in  
      if let value: ListData<Users> = response.value {
        self.searchResults = value.data
      }
    }
  }
  
  //  create an authorization header used in API requests
  //  :param token (String) - auth token of the current user
  //  :return none
  func createAuthHeader(token: String) {
    self.headers = [
      "Authorization": "Token " + token
    ]
  }
  
  //  create a alert with closing the alert as the dismissButton action
  //  :param title (String) - title of the alert
  //  :param message (String) - body message of the alert
  //  :param button (String) - text for the dismiss button
  func createAlert(title: String, message: String, button: String) -> Alert {
    return Alert(title: Text(title),
                 message: Text(message),
                 dismissButton: .default(
                  Text(button),
                  action: {
                    self.alert = nil
                  }
                 )
    )
  }
  
  //  loads contacts
  // :return none
  func fetchContacts() {
    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
    do {
      try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
        let newContact = Contact()
        newContact.firstName = contact.givenName
        newContact.lastName = contact.familyName
        newContact.phone = contact.phoneNumbers.first?.value
        if let uiImageNSData: NSData = contact.imageData as NSData? {
          newContact.picture = Image(uiImage: UIImage(data: uiImageNSData as Data, scale: 1.0)!)
        }
        self.contacts.append(newContact)
      })
      self.contacts.sort()
    }
    catch {
      NSLog("[Contacts] ERROR: was unable to parse contacts")
    }
  }
  
  // invites a user from the user's contacts to the game
  // :param contact (Contact) - the contact who is being invited
  // :return none
  func inviteContact(contact: Contact) {    
    return
  }
  
  // filters the contacts based on a query
  // :param query (String) - the query to filter by
  // :return none
  func searchContacts(query: String) {
    if query == "" {
      self.contactsFiltered = self.contacts
    } else {
      let q = query.lowercased()
      let c = self.contacts
      self.contactsFiltered = c.filter({ $0.name().lowercased().contains(q) })
    }
  }
  
  func groupPlayers(players: [Player]) -> [Dictionary<String, [Player]>.Element] {
    let p = players.sorted(by: { Helper.toTime(time: $0.game.data.time) < Helper.toTime(time: $1.game.data.time) })
    let players = Dictionary(grouping: p, by: { $0.game.data.onDate() })
    let keys = players.sorted(by: { Helper.toDate(date: $0.key) > Helper.toDate(date: $1.key) })
    return keys
  }
  
  //  func grabPlayer(game: Game?) -> Player {
  //    if let g = game {
  //      // User is already associated with the game
  //      if self.playersSet.contains(g.id) {
  //        return self.players.filter({ $0.game.data.id == g.id })[0]
  //      }
  //    }
  //    let player = self.createPlayer
  //    return
  //  }
}
