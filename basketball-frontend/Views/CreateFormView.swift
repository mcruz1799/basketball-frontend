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
  @ObservedObject var viewModel: ViewModel
  let location: MKMapItem
  @State var game: Games = Games(id: 4, name: "", date: "", time: "", description: "", priv: false, longitude: 2.0, latitude: 2.0)
  @State var date: Date = Date()
  @Binding var creatingGame: Bool
  
  var body: some View {
    Form {
      Section(header: Text("GENERAL")) {
        TextField("Court Name", text: $game.name)
      }
      Section(header: Text("LOCATION")) {
        VStack(alignment: .leading) {
          Text(location.name ?? "").bold()
          Text(Helper.parseAddress(selectedItem: location.placemark))
        }
      }
      Section(header: Text("LOGISTICS")) {
        Toggle(isOn: $game.priv) {
          Text("Private Game")
        }
        DatePicker("Date", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
        TextField("Description", text: $game.description)
      }
      Section {
        Button(action: {
          createGame()
        }) {
          Text("Create Game")
        }
      }
    }.navigationBarTitle("Game Details")
    .alert(isPresented: $viewModel.showAlert) {
      viewModel.alert!
    }
  }
  
  func createGame() {
    viewModel.createGame(name: game.name, date: date, description: game.description, priv: game.priv, latitude: self.location.placemark.location!.coordinate.latitude, longitude: self.location.placemark.location!.coordinate.longitude)
    //    self.creatingGame = false
  }
}

struct CreateFormView_Previews: PreviewProvider {
  static var previews: some View {
    CreateFormView(viewModel: ViewModel(), location: MKMapItem(), creatingGame: .constant(true))
  }
}
