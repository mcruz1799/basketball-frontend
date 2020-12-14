//
//  basketball_frontendViewModelTests.swift
//  basketball-frontendTests
//
//  Created by Jeff Xu on 12/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

//  IMPORTANT!!!!!!
//  RUN testLoginSuccess() once before running all tests
//  API needs a call to warm up
//
//  If a test fails, check for database conflicts before running again

import XCTest
import Alamofire
import Foundation
import SwiftUI
@testable import basketball_frontend

class basketball_frontendViewModelTests: XCTestCase {
  override func setUp() {
  }

  override func tearDown() {
  }
  
  let expired = 5.0
  
  //  VIEW MODEL CODE
  var games: [Games] = [Games]()
  var user: User?
  var players: [Player] = [Player]()
  var playersSet: Set<Int> = Set()
  var favorites: [Favorite] = [Favorite]()
  var favoritesSet: Set<Int> = Set()
  var userId: Int? = 1
  var headers: HTTPHeaders? = [
    "Authorization": "Token 37935062f0b281fe9e36a08727680363"
  ]
  
  var game: Game?
  var invited: [Users] = [Users]()
  var maybe: [Users] = [Users]()
  var going: [Users] = [Users]()
  
  var gamePlayers: Set<Int> = Set()
  
  var userLocation = Location()
  var currentScreen: String = "landing"
  var searchResults: [Users] = [Users]()
  var isLoaded: Bool = false
  var alert: Alert?
  var showAlert: Bool = false
  var activeSheet: Sheet = .creatingGame
  var showingSheet: Bool = false
  
  //
  // USER FUNCTIONS
  //
  
  //  perform login for a user
  //  :param username (String) - username of the user
  //  :param password (String) - password of the user in plain text
  //  :return none
  func login(username: String, password: String, completionHandler: @escaping () -> Void) {
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
            self.refreshCurrentUser() {}
            self.getGames() {}
            self.currentScreen = "app"
            completionHandler()
          }
        case .failure:
          self.currentScreen = "login"
          self.alert = self.createAlert(title: "Invalid Login",
                                        message: "The username or password you entered was invalid",
                                        button: "Got it")
          self.showAlert = true
          completionHandler()
        }
      }
  }
  
  func testLoginSuccess() {
    self.userId = nil
    self.headers = nil
    let expectation = self.expectation(description: "Able to login")
    
    self.login(username: "jxu", password: "secret") {
      XCTAssertEqual(self.currentScreen, "app")
      XCTAssertEqual(self.userId!, 1)
      XCTAssertEqual(self.headers!["Authorization"]!, "Token 37935062f0b281fe9e36a08727680363")
      XCTAssertFalse(self.showAlert)
      XCTAssertNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  func testLoginFail() {
    self.userId = nil
    self.headers = nil
    let expectation = self.expectation(description: "Unable to login")
    
    self.login(username: "", password: "") {
      XCTAssertEqual(self.currentScreen, "login")
      XCTAssertTrue(self.showAlert)
      XCTAssertNotNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //  refresh the current user by updating self.user
  //  :param none
  //  :return none
  func refreshCurrentUser(completionHandler: @escaping () -> Void) {
    let request = "http://secure-hollows-77457.herokuapp.com/users/" + String(self.userId!)
    AF.request(request, headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value.data
        self.players = value.data.players.map { $0.data }
        self.playersSet = Set(self.players.map { $0.game.data.id })
        self.favorites = value.data.favorites.map { $0.data }
        self.favoritesSet = Set(self.favorites.map { $0.user.data.id })
        completionHandler()
      }
    }
  }
  
  func testRefreshCurrentUser() {
    let expectation = self.expectation(description: "Able to refresh current user")

    self.refreshCurrentUser() {
      XCTAssertEqual(self.user!.id, 1)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //  get a user by id
  //  :param id (Int) - a user ID
  //  :return (User?) - a User object if one is found, nil otherwise
  func getUser(id: Int, completionHandler: @escaping (User) -> Void) -> User? {
    let request  = "http://secure-hollows-77457.herokuapp.com/users/" + String(id)
    var user: User? = nil
    AF.request(request, headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        user = value.data
        completionHandler(user!)
      }
    }
    return user
  }
  
  func testGetUser() {
    let expectation = self.expectation(description: "Able to get a user by ID")
    
    self.getUser(id: 1) { (user) in
      XCTAssertEqual(user.id, 1)
      XCTAssertEqual(user.username, "jxu")
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
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
  func createUser(firstName: String, lastName: String, username: String, email: String, dob: Date, phone: String, password: String, passwordConfirmation: String, completionHandler: @escaping (User?) -> Void) -> User? {
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
            self.login(username: username, password: password, completionHandler: { () in print("done") })
            completionHandler(user)
          }
        case .failure:
          self.alert = self.createAlert(title: "Invalid Profile Information",
                                        message: "The profile information you entered was invalid, please check your inputs and try again",
                                        button: "Got it")
          self.showAlert = true
          completionHandler(user)
        }
      }
    return user
  }
  
  func testCreateUserSuccess() {
    let expectation = self.expectation(description: "Able to create a user")
    
    let dob = Date(timeIntervalSinceReferenceDate: -100000000)
    self.createUser(firstName: "Test", lastName: "Test", username: "test", email: "test@gmail.com", dob: dob, phone: "1234567890", password: "secret", passwordConfirmation: "secret") { (user) in
      XCTAssertEqual(user!.username, "test")
      XCTAssertEqual(user!.displayName(), "Test Test")
      self.deleteUserHelper(id: user!.id)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10.0)
  }
  
  func testCreateUserFailure() {
    let expectation = self.expectation(description: "Unable to create a user")
    
    let dob = Date(timeIntervalSinceReferenceDate: -100000000)
    self.createUser(firstName: "Test", lastName: "Test", username: "test", email: "test@gmail.com", dob: dob, phone: "1234567890", password: "secret", passwordConfirmation: "") { (user) in
      XCTAssertNil(user)
      XCTAssertTrue(self.showAlert)
      XCTAssertNotNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //  edit the current user
  //  :param firstName (String) - first name of the user
  //  :param lastName (String) - last name of the user
  //  :param username (String) - username of the user, must be unique
  //  :param email (String) - email of the user, must be correctly formatted
  //  :param phone (String) - phone number of the user, must be correctly formatted
  //  :return none
  func editCurrentUser(firstName: String, lastName: String, username: String, email: String, phone: String, completionHandler: @escaping () -> Void) {
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
            self.refreshCurrentUser() {}
            completionHandler()
          }
        case .failure:
          self.alert = self.createAlert(title: "Invalid Profile Information",
                                        message: "The edited profile information you entered was invalid, please check your inputs and try again",
                                        button: "Try again")
          self.showAlert = true
          completionHandler()
        }
      }
  }
  
  func testEditCurrentUserSuccess() {
    self.user = User(id: 1, username: "jxu", email: "jxu@gmail.com", firstName: "Jeff", lastName: "Xu", dob: "01-01-2000", phone: "1234567890", players: [APIData<Player>](), favorites: [APIData<Favorite>]())
    let expectation = self.expectation(description: "Able to edit a user")
    
    self.editCurrentUser(firstName: "Jeff1", lastName: "Xu", username: "jxu", email: "jxu@gmail.com", phone: "1234567890") {
      XCTAssertEqual(self.user!.id, 1)
      XCTAssertEqual(self.user!.firstName, "Jeff1")
      self.editCurrentUser(firstName: "Jeff", lastName: "Xu", username: "jxu", email: "jxu@gmail.com", phone: "1234567890") {}
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  func testEditCurrentUserFailure() {
    self.user = User(id: 1, username: "jxu", email: "jxu@gmail.com", firstName: "Jeff", lastName: "Xu", dob: "01-01-2000", phone: "1234567890", players: [APIData<Player>](), favorites: [APIData<Favorite>]())
    let expectation = self.expectation(description: "Unable to edit a user")
    
    self.editCurrentUser(firstName: "Jeff", lastName: "Xu", username: "", email: "jxu@gmail.com", phone: "1234567890") {
      XCTAssertEqual(self.user!.id, 1)
      XCTAssertEqual(self.user!.username, "jxu")
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //
  // GAME FUNCTIONS
  //
  
  //  get all games
  //  :param none
  //  :return none
  func getGames(completionHandler: @escaping () -> Void) {
    AF.request("http://secure-hollows-77457.herokuapp.com/games", headers: self.headers!).responseDecodable { ( response: AFDataResponse<ListData<Games>> ) in
      if let value: ListData<Games> = response.value {
        self.games = value.data
        completionHandler()
      }
    }
  }
  
  func testGetGames() {
    let expectation = self.expectation(description: "Able to get all games in database")
    
    self.getGames() {
      XCTAssertNotNil(self.games)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  func getGame(id: Int, completionHandler: @escaping () -> Void) {
    AF.request("http://secure-hollows-77457.herokuapp.com/games/" + String(id), headers: self.headers!).responseDecodable { ( response: AFDataResponse<APIData<Game>> ) in
      if let value: APIData<Game> = response.value {
        self.game = value.data
        self.invited = value.data.invited.map { $0.data }
        self.maybe = value.data.maybe.map { $0.data }
        self.going = value.data.going.map { $0.data }
        let arr = self.invited + self.maybe + self.going
        self.gamePlayers = Set(arr.map { $0.id })
        completionHandler()
      }
    }
  }
  
  func testGetGame() {
    let expectation = self.expectation(description: "Able to get a game by ID")
    
    self.getGame(id: 1) {
      XCTAssertEqual(self.game!.id, 1)
      XCTAssertEqual(self.game!.name, "Apple HQ Court 1")
      XCTAssertNotNil(self.invited)
      XCTAssertNotNil(self.maybe)
      XCTAssertNotNil(self.going)
      XCTAssertNotNil(self.gamePlayers)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //
  // FAVORITE FUNCTIONS
  //
  
  //  favorite another user and refresh the user info
  //  :param favoriterId (Int) - user ID of the favoriter
  //  :param favoriteeId (Int) - user ID of the favoritee
  //  :return (Favorite?) the result Favorite object if successful, nil otherwise
  func favorite(favoriterId: Int, favoriteeId: Int, completionHandler: @escaping (Favorite?) -> Void) -> Favorite? {
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
            self.refreshCurrentUser() {}
            favorite = value.data
            completionHandler(favorite)
          }
        case .failure:
          print(response.result)
          self.alert = Alert(title: Text("Favorite Failed"),
                             message: Text("Failed to favorite this user, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.favorite(favoriterId: favoriterId, favoriteeId: favoriteeId, completionHandler: completionHandler)
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
          completionHandler(favorite)
        }
      }
    return favorite
  }
  
  func testFavoriteSuccess() {
    let expectation = self.expectation(description: "Able to favorite user")
    
    self.favorite(favoriterId: 1, favoriteeId: 2) { (favorite) in
      XCTAssertEqual(favorite!.favoriter_id, 1)
      XCTAssertEqual(favorite!.favoritee_id, 2)
      self.unfavoriteHelper(id: favorite!.id)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10.0)
  }
  
  func testFavoriteFailure() {
    let expectation = self.expectation(description: "Unable to favorite user")
    
    self.favorite(favoriterId: 0, favoriteeId: 0) { (favorite) in
      XCTAssertNil(favorite)
      XCTAssertTrue(self.showAlert)
      XCTAssertNotNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
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
  
  func testIsFavorite() {
    let data =
      """
    {
      "data": {
        "id": "4",
        "type": "users",
        "attributes": {
          "id": 4,
          "username": "jigims",
          "email": "",
          "firstname": "",
          "lastname": "",
          "dob": "",
          "phone": ""
        }
      }
    }
    """.data(using: .utf8)
    
    var f: APIData<Users>?
    let decoder = JSONDecoder()
    do {
      f = try decoder.decode(APIData<Users>.self, from: data!)
    } catch {
      f = nil
    }
    let favorite = Favorite(id: 1, favoriter_id: 1, favoritee_id: 2, user: f!)
    self.favorites.append(favorite)
    
    XCTAssertTrue(self.isFavorite(userId: 2))
    XCTAssertFalse(self.isFavorite(userId: 10))
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
  
  func testFindFavorite() {
    let data =
      """
    {
      "data": {
        "id": "4",
        "type": "users",
        "attributes": {
          "id": 4,
          "username": "jigims",
          "email": "",
          "firstname": "",
          "lastname": "",
          "dob": "",
          "phone": ""
        }
      }
    }
    """.data(using: .utf8)
    
    var f: APIData<Users>?
    let decoder = JSONDecoder()
    do {
      f = try decoder.decode(APIData<Users>.self, from: data!)
    } catch {
      f = nil
    }
    let favorite = Favorite(id: 1, favoriter_id: 1, favoritee_id: 2, user: f!)
    self.favorites.append(favorite)
    
    XCTAssertEqual(self.findFavorite(favoriterId: 1, favoriteeId: 2)!.favoriter_id, 1)
    XCTAssertNil(self.findFavorite(favoriterId: 2, favoriteeId: 3))
  }
  
  // unfavorite another user
  // :param favoriteeId (Int) - user ID of the user being unfavorited
  // :return none
  func unfavorite(favoriteeId: Int, completionHandler: @escaping () -> Void) {
    let id = self.favorites.filter({ $0.favoritee_id == favoriteeId })[0].id
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<Favorite>> ) in
        switch response.result {
        case .success:
          if let _: APIData<Favorite> = response.value {
            self.refreshCurrentUser() {}
            completionHandler()
          }
        case .failure:
          self.alert = Alert(title: Text("Unfavorite Failed"),
                             message: Text("Failed to unfavorite this user, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.unfavorite(favoriteeId: favoriteeId) {}
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
          completionHandler()
        }
      }
  }
  
  func testUnfavoriteFailure() {
    let data =
      """
    {
      "data": {
        "id": "4",
        "type": "users",
        "attributes": {
          "id": 4,
          "username": "jigims",
          "email": "",
          "firstname": "",
          "lastname": "",
          "dob": "",
          "phone": ""
        }
      }
    }
    """.data(using: .utf8)
    
    var f: APIData<Users>?
    let decoder = JSONDecoder()
    do {
      f = try decoder.decode(APIData<Users>.self, from: data!)
    } catch {
      f = nil
    }
    let favorite = Favorite(id: 1, favoriter_id: 0, favoritee_id: 0, user: f!)
    self.favorites.append(favorite)
    
    let expectation = self.expectation(description: "Able to unfavorite a user")
    
    self.unfavorite(favoriteeId: 0) {
      XCTAssertTrue(self.showAlert)
      XCTAssertNotNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //
  // PLAYER FUNCTIONS
  //
  
  //  create a player
  //  :param status (String) - status of the player, can be "going", "maybe", "invited", or "not_going"
  //  :param userId (String) - user ID of the player
  //  :param gameId (String) - game ID of the player
  func createPlayer(status: String, userId: Int, gameId: Int, completionHandler: @escaping (Player?) -> Void) -> Player? {
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
            self.getGame(id: self.game!.id) {}
            player = value.data
            completionHandler(player)
          }
        case .failure:
          self.alert = Alert(title: Text("Create Player Failed"),
                             message: Text("Failed to add this user to this game, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.createPlayer(status: status, userId: userId, gameId: gameId, completionHandler: completionHandler)
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
          completionHandler(player)
        }
      }
    return player
  }
  
  func testCreatePlayerSuccess() {
    let expectation = self.expectation(description: "Able to create player")
    self.game = Game(id: 1, name: "test", date: "test", time: "test", description: "test", priv: true, longitude: 0.0, latitude: 0.0, invited: [APIData<Users>](), maybe: [APIData<Users>](), going: [APIData<Users>]())
    
    self.createPlayer(status: "going", userId: 1, gameId: 3) { (player) in
      XCTAssertEqual(player!.status, "going")
      XCTAssertEqual(player!.game.data.id, 3)
      self.deletePlayerHelper(id: player!.id)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10.0)
  }
  
  func testCreatePlayerFailure() {
    let expectation = self.expectation(description: "Unable to create player")
    
    self.createPlayer(status: "", userId: 0, gameId: 0) { (player) in
      XCTAssertNil(player)
      XCTAssertEqual(self.showAlert, true)
      XCTAssertNotNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  // edit the status of a player belonging to the current user
  // :param playerId (Int) - ID of the player
  // :param status (String) - status of the player, can be "going", "maybe", "invited", "not_going", "I'm going", "I'm Invited", "I'm Maybe", or "I'm Not Going"
  // :return none
  func editPlayerStatus(playerId: Int, status: String, completionHandler: @escaping () -> Void) {
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
    
    AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(playerId), method: .patch, parameters: params, headers: self.headers!)
      .validate()
      .responseDecodable {
        ( response: AFDataResponse<APIData<Player>> ) in
        switch response.result {
        case .success:
          if let _: APIData<Player> = response.value {
            self.getGame(id: self.game!.id) {}
            self.refreshCurrentUser() {}
            completionHandler()
          }
        case .failure:
          self.alert = Alert(title: Text("Edit Player Status Failed"),
                             message: Text("Failed to edit the status of this player, please try again"),
                             primaryButton: .default(
                              Text("Try Again"),
                              action: {
                                self.editPlayerStatus(playerId: playerId, status: status) {}
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
          completionHandler()
        }
      }
  }
  
  func testEditPlayerStatusSuccess() {
    self.game = Game(id: 1, name: "test", date: "test", time: "test", description: "test", priv: true, longitude: 0.0, latitude: 0.0, invited: [APIData<Users>](), maybe: [APIData<Users>](), going: [APIData<Users>]())
    let expectation = self.expectation(description: "Able to edit player status")
    
    self.editPlayerStatus(playerId: 1, status: "going") {
      XCTAssertEqual(self.showAlert, false)
      XCTAssertNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  func testEditPlayerStatusFailure() {
    let expectation = self.expectation(description: "Unable to edit player status")
    
    self.editPlayerStatus(playerId: 1, status: "") {
      XCTAssertEqual(self.showAlert, true)
      XCTAssertNotNil(self.alert)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
  }
  
  //
  // MISC. FUNCTIONS
  //
  
  func fetchData() {
    login(username: "jxu", password: "secret" , completionHandler: { () in print("done") })
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
  func searchUsers(query: String, completionHandler: @escaping () -> Void) {
    let params = [
      "query": query.lowercased()
    ]
    let request  = "http://secure-hollows-77457.herokuapp.com/search"
    AF.request(request, method: .get, parameters: params).responseDecodable { ( response: AFDataResponse<ListData<Users>> ) in
      if let value: ListData<Users> = response.value {
        self.searchResults = value.data
        completionHandler()
      }
    }
  }
  
  func testSearchUser() {
    let expectation = self.expectation(description: "Able to search for user")
    
    self.searchUsers(query: "jxu") {
      XCTAssertNotNil(self.searchResults)
      expectation.fulfill()
    }
    waitForExpectations(timeout: expired)
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
  
  // HELPERS
  func deleteUserHelper(id: Int) {
    AF.request("http://secure-hollows-77457.herokuapp.com/users/" + String(id), method: .delete, parameters: nil, headers: self.headers!)
      .responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
        if let _: APIData<User> = response.value {
          print("User deleted")
        }
      }
  }
  
  func unfavoriteHelper(id: Int) {
    AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil, headers: self.headers!)
      .responseDecodable { ( response: AFDataResponse<APIData<Favorite>> ) in
        if let _: APIData<Favorite> = response.value {
          print("unfavorited")
        }
      }
  }
  
  func deletePlayerHelper(id: Int) {
    AF.request("http://secure-hollows-77457.herokuapp.com/players/" + String(id), method: .delete, parameters: nil, headers: self.headers!)
      .responseDecodable { ( response: AFDataResponse<APIData<Player>> ) in
        if let _: APIData<Player> = response.value {
          print("player deleted")
        }
      }
  }
}
