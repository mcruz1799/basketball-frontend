//
//  basketball_frontendTests.swift
//  basketball-frontendTests
//
//  Created by Matthew Cruz on 11/2/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import XCTest
import Alamofire
import Contacts
@testable import basketball_frontend

class basketball_frontendTests: XCTestCase {
  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
//    let viewModel: ViewModel = ViewModel()
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testUsersModel() {
    let users: Users = Users(id: 1, username: "testtest", email: "test@gmail.com", firstName: "Test", lastName: "Test", dob: "01-01-2000", phone: "1234567890")
    
    XCTAssertEqual(users.displayName(), "Test Test")
  }
  
  func testUserModel() {
    let user: User = User(id: 1, username: "michaeljordan", email: "michaeljordan@gmail.com", firstName: "Michael", lastName: "Jordan", dob: "2000-01-01", phone: "1234567890", players: [APIData<Player>](), favorites: [APIData<Favorite>]())
    
    let name = user.displayName()
    
    XCTAssertEqual(name, "Michael Jordan")
  }
  
  func testGamesModel() {
    let games: Games = Games(id: 1, name: "test", date: "2020-11-30", time: "2000-01-01T01:16:43.000Z", description: "", priv: false, longitude: 0.0, latitude: 0.0)
    
    let time = games.onTime()
    
    XCTAssertEqual(time, "8:16 PM")
  }
  
  func testGameModel() {
    let game: Game = Game(id: 4, name: "Schenley Park", date: "2020-11-30", time: "2000-01-01T01:16:43.000Z", description: "", priv: false, longitude: 2.0, latitude: 2.0, invited: [APIData<Users>](), maybe: [APIData<Users>](), going: [APIData<Users>]())
    
    let time = game.onTime()
    
    XCTAssertEqual(time, "8:16 PM")
  }
  
  func testFavoriteModel() {
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
    let favorite: Favorite = Favorite(id: 1, favoriter_id: 0, favoritee_id: 0, user: f!)
    
    XCTAssertEqual(favorite.id, 1)
    XCTAssertEqual(favorite.favoriter_id, 0)
  }
  
  func testUserLoginModel() {
    let userLogin: UserLogin = UserLogin(id: 1, username: "testtest", api_key: "test")
    
    XCTAssertEqual(userLogin.id, 1)
    XCTAssertEqual(userLogin.username, "testtest")
  }
  
  func testContactModel() {
    let contact: Contact = Contact(firstName: "Test", lastName: "Test", phone: CNPhoneNumber(stringValue: "1234567890"), imagePath: nil)
    
    XCTAssertEqual(contact.name(), "Test Test")
    XCTAssertEqual(contact.displayPhone(), "1234567890")
    
    let contact1: Contact = Contact(firstName: "Test1", lastName: "Test", phone: CNPhoneNumber(stringValue: "1234567890"), imagePath: nil)
    
    XCTAssertFalse(contact == contact1)
    XCTAssertTrue(contact < contact1)
  }
  
  func testGameAnnotationModel() {
    let games: Games = Games(id: 1, name: "Test", date: "01-01-2020", time: "12:00 PM", description: "Test", priv: true, longitude: 0.0, latitude: 0.0)
    let gameAnnotation: GameAnnotation = GameAnnotation(id: 1, subtitle: "Test", title: "Test", latitude: 0.0, longitude: 0.0, game: games)
    
    XCTAssertEqual(gameAnnotation.id, "1")
    XCTAssertEqual(gameAnnotation.title, "Test")
    XCTAssertEqual(gameAnnotation.game.id, 1)
  }
}
