//
//  CreateView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct CreateView: View {
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

//struct CreateView_Previews: PreviewProvider {
//  static var previews: some View {
//    CreateView()
//  }
//}
