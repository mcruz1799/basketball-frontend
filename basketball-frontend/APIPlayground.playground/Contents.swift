import UIKit
import Almaofire

struct Games: Decodable, Encodable, Identifiable {
  let id: Int?
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

let game = Games(name: "", date: "", time: "", description: "", priv: true, longitude: 2.0, latitude: 2.0)
print(game)
