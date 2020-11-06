import Foundation
import Alamofire  
import RxSwift

//PlaygroundPage.current.needsIndefiniteExecution = true

let url: String = "http://secure-hollows-77457.herokuapp.com"

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

struct Games: Decodable {
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

class P {
  
  var user: APIData<User>?
  
  required init() {
    AF.request("http://secure-hollows-77457.herokuapp.com/users/1").responseDecodable { ( response: AFDataResponse<APIData<User>> ) in
      if let value: APIData<User> = response.value {
        self.user = value
        print(self.user)
      }
    }
  }
  
  func update() -> APIData<User>? {
    if user != nil {
      return self.user
    } else {
      _ = type(of: self).init()
    }
    return self.user
  }
}

class ViewModel: ObservableObject {
  
  var parser: P = P()
  
  @Published var user: APIData<User>?
//  @Published var players: [APIData<Player>] = []
//  @Published var favorites: [APIData<Favorite>] = []
  
  func update() {
    self.user = self.parser.update()
//    if let user = self.user {
//      self.players = user.data.players
//      self.favorites = user.data.favorites
//      print(self.players)
//    }
  }
}

//var viewModel: ViewModel = ViewModel()
//DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//  print(viewModel.user)
//}

func unfavorite(id: Int) {
  AF.request("http://secure-hollows-77457.herokuapp.com/favorites/" + String(id), method: .delete, parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
    do {
      guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
        print("Error: Cannot convert data to JSON object")
        return
      }
      guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
        print("Error: Cannot convert JSON object to Pretty JSON data")
        return
      }
      guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
        print("Error: Could print JSON in String")
        return
      }
      
      print(prettyPrintedJson)
    } catch {
      print("Error: Trying to convert JSON data to string")
      return
    }
  }
}

unfavorite(id: 1)

