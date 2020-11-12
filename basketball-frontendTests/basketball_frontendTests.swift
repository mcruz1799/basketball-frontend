//
//  basketball_frontendTests.swift
//  basketball-frontendTests
//
//  Created by Matthew Cruz on 11/2/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import XCTest
import Alamofire
@testable import basketball_frontend

class basketball_frontendTests: XCTestCase {
  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
//    let viewModel: ViewModel = ViewModel()
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGameModel() {
    let game: Game = Game(id: 4, name: "Schenley Park", date: "2020-11-30", time: "2000-01-01T01:16:43.000Z", description: "", priv: false, longitude: 2.0, latitude: 2.0, invited: [APIData<Users>](), maybe: [APIData<Users>](), going: [APIData<Users>]())
    
    let time = game.onTime()
    
    XCTAssertEqual(time, "8:16 PM")
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
}
