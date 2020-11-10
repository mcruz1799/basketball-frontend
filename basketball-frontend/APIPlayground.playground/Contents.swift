import UIKit
import Alamofire
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

struct Player: Decodable, Identifiable {
  let id: Int
  let userId: Int
  let status: String
  let gameId: Int
  enum CodingKeys: String, CodingKey {
    case id
    case status
    case gameId = "game_id"
    case userId = "user_id"
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

//var time = "2000-01-01T13:16:43.000Z"
//var date = "2020-10-29"
//
//let isoDate = "2016-04-14T10:44:00+0000"
//
//let timeFormatter = DateFormatter()
//let dateFormatter = DateFormatter()
//dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//dateFormatter.dateFormat = "yyyy-MM-dd"
//timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//if let formatted: Date = dateFormatter.date(from:date)
//{
//  print(formatted)
//} else {
//  print("Not Format")
//}
//if let formattedTime: Date = timeFormatter.date(from:time)
//{
//  print(formattedTime)
//} else {
//  print("Not Format")
//}

let p = Player(id: 9, userId: 6, status: "going", gameId: 3)

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

print(changePlayerStatus(player: p))
