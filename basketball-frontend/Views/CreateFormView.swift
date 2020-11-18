//
//  CreateFormView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI
import MapKit

struct CreateFormView: View {
  let viewModel: ViewModel
  @State var game: Games = Games(id: 4, name: "", date: "", time: "", description: "", priv: false, longitude: 2.0, latitude: 2.0)
  @State var date: Date = Date()
  @State var locationSearch: String = ""
  @State var latitude: Double = 40
  @State var longitude: Double = 40
  @Binding var creatingGame: Bool
  
  var body: some View {
    NavigationView {
      Form {
        Section {
        TextField("Court Name", text: $game.name)
        TextField("Location", text: $locationSearch)
          Button(action: {
            getAddress()
          }) {
            Text("Search Address")
          }
        }
        Toggle(isOn: $game.priv) {
          Text("Private Game")
        }
        DatePicker("Date", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
        TextField("Description", text: $game.description)
        Section {
          Button(action: {
            createGame()
          }) {
            Text("Create Game")
          }
        }
      }.navigationBarTitle("Create A Game")
    }
  }
  
  func getAddress() {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = self.locationSearch
//    searchRequest.region = yourMapView.region
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, error in
        guard let response = response else {
            print("Error: \(error?.localizedDescription ?? "Unknown error").")
            return
        }

        for item in response.mapItems {
          self.latitude = item.placemark.location!.coordinate.latitude
          self.longitude = item.placemark.location!.coordinate.longitude
          self.locationSearch = item.name!
        }
    }
  }
  
  func createGame() {
    viewModel.createGame(name: game.name, date: date, description: game.description, priv: game.priv, latitude: self.latitude, longitude: self.longitude)
    self.creatingGame = false
  }
}

//struct CreateFormView_Previews: PreviewProvider {
//  static var previews: some View {
//    CreateFormView()
//  }
//}
