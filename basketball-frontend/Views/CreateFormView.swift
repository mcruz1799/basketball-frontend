//
//  CreateFormView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct CreateFormView: View {
  let viewModel: ViewModel
  @State var game: Games = Games(id: 4, name: "", date: "", time: "", description: "", priv: false, longitude: 2.0, latitude: 2.0)
  @State var date: Date = Date()
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Court Name", text: $game.name)
        Toggle(isOn: $game.priv) {
          Text("Private Game")
        }
        DatePicker("Date", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
        TextField("Description", text: $game.description)
        Section {
          Button(action: {
            viewModel.createGame(game: game, date: date)
          }) {
            Text("Create Game")
          }
        }
      }.navigationBarTitle("Set Game Details")
    }
  }
}

//struct CreateFormView_Previews: PreviewProvider {
//  static var previews: some View {
//    CreateFormView()
//  }
//}
