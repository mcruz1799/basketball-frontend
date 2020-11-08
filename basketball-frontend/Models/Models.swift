//
//  Game.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation

struct Users: Decodable {
  let id: Int
  let username: String
  let email: String
  let firstName: String
  let lastName: String
  let dob: String
  let phone: String
  enum CodingKeys: String, CodingKey {
    case id
    case username
    case email
    case firstName = "firstname"
    case lastName = "lastname"
    case dob
    case phone
  }
}

struct Games: Decodable, Encodable, Identifiable {
  let id: Int
  let name: String
  let date: String
  let time: String
  let description: String
  let priv: Bool
  let longitude: Double
  let latitude: Double
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case date
    case time
    case description
    case priv = "private"
    case longitude
    case latitude
  }
}

struct Player: Decodable {
  let id: Int
  let status: String
  let game: APIData<Games>
  enum CodingKeys: String, CodingKey {
    case id
    case status
    case game
  }
}

struct Favorite: Decodable {
  let id: Int
  let favoriter_id: Int
  let favoritee_id: Int
  let user: APIData<Users>
  enum CodingKeys: String, CodingKey {
    case id
    case favoriter_id
    case favoritee_id
    case user
  }
}

struct User: Decodable {
  let id: Int
  let username: String
  let email: String
  let firstName: String
  let lastName: String
  let dob: String
  let phone: String
  let players: [APIData<Player>]
  let favorites: [APIData<Favorite>]
  enum CodingKeys: String, CodingKey {
    case id
    case username
    case email
    case firstName = "firstname"
    case lastName = "lastname"
    case dob
    case phone
    case players
    case favorites
  }
}

struct Game: Decodable {
  let id: Int
  let name: String
  let date: String
  let time: String
  let description: String
  let priv: Bool
  let longitude: Double
  let latitude: Double
  let invited: [APIData<Users>]
  let maybe: [APIData<Users>]
  let going: [APIData<Users>]
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case date
    case time
    case description
    case priv = "private"
    case longitude
    case latitude
    case invited
    case maybe
    case going
  }
}

struct ListData<T>: Decodable where T: Decodable {
  let data: [T]
  enum CodingKeys: String, CodingKey {
    case data
  }
  struct ListDataGenericData: Decodable {
    let id: String
    let type: String
    let attributes: T
    enum CodingKeys: String, CodingKey {
      case id
      case type
      case attributes
    }
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let results = try container.decode([ListDataGenericData].self, forKey: .data)
    self.data = results.map({ $0.attributes })
  }
}

struct APIData<T>: Decodable where T: Decodable {
  var data: T
  enum CodingKeys: String, CodingKey {
    case data
  }
  struct DataGenericData: Decodable {
    let id: String
    let type: String
    let attributes: T
    enum CodingKeys: String, CodingKey {
      case id
      case type
      case attributes
    }
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let results = try container.decode(DataGenericData.self, forKey: .data)
    self.data = results.attributes
  }
}
