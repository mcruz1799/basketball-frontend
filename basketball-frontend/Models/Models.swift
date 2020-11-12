//
//  Game.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation

struct Users: Decodable, Identifiable {
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
  var id: Int
  var name: String
  var date: String
  var time: String
  var description: String
  var priv: Bool
  var longitude: Double
  var latitude: Double
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
  func onTime() -> String {
    return Helper.onTime(time: self.time)
  }
}

struct Player: Decodable, Identifiable {
  let id: Int
  let userId: Int
  let status: String
  let game: APIData<Games>
  enum CodingKeys: String, CodingKey {
    case id
    case status
    case userId = "user_id"
    case game
  }
}

struct Favorite: Decodable, Identifiable {
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
  
  func displayName() -> String {
    return self.firstName + " " + self.lastName
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
  
  func onTime() -> String {
    return Helper.onTime(time: self.time)
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

extension Bundle {
  // Borrowed from Paul Hudson (@twostraws)
  func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate \(file) in bundle.")
    }
    
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Failed to load \(file) from bundle.")
    }
    
    let decoder = JSONDecoder()
    
    guard let loaded = try? decoder.decode(T.self, from: data) else {
      fatalError("Failed to decode \(file) from bundle.")
    }
    
    return loaded
  }
}


//dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//dateFormatter.dateFormat = "yyyy-MM-dd"
//timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//game.date = dateFormatter.date(from:game.date)
//game.time = timeFormatter.date(from:game.time)

class NormalizingDecoder: JSONDecoder {
  
  var dateFormatter: DateFormatter = DateFormatter()
  var timeFormatter: DateFormatter = DateFormatter()
  let calendar = Calendar.current
  
  override init() {
    super.init()
    //    dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .medium
    keyDecodingStrategy = .convertFromSnakeCase
    dateFormatter.dateFormat = "yyyy-MM-dd"
    timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateDecodingStrategy = .custom { (decoder) -> Date in
      let container = try decoder.singleValueContainer()
      let dateString = try container.decode(String.self)
      let date = self.dateFormatter.date(from: dateString)
      
      if let date = date {
        let midnightThen = self.calendar.startOfDay(for: date)
        let millisecondsFromMidnight = date.timeIntervalSince(midnightThen)
        
        let today = Date()
        let midnightToday = self.calendar.startOfDay(for: today)
        let normalizedDate = midnightToday.addingTimeInterval(millisecondsFromMidnight)
        
        return normalizedDate
      } else {
        throw DecodingError.dataCorruptedError(in: container,
                                               debugDescription:
                                                "Date values must be formatted like \"7:27:02 AM\" " +
                                                "or \"12:16:28 PM\".")
      }
    }
  }
}

