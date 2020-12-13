
import Foundation
import MapKit

class GameAnnotation: NSObject, MKAnnotation {
  
  let id: String
  let subtitle: String?
  let title: String?
  let coordinate: CLLocationCoordinate2D
  let game: Games
  
  init(id: Int, subtitle: String, title: String, latitude: Double, longitude: Double, game: Games) {
    self.id = String(id)
    self.subtitle = subtitle
    self.title = title
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    self.game = game
  }
}
