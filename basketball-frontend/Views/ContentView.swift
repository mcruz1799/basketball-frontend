//
//  ContentView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/2/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel: ViewModel = ViewModel()
  
<<<<<<< HEAD
  //  @State var games: [Games] = []
  
=======
>>>>>>> api
  var body: some View {
    VStack {
<<<<<<< HEAD
      Button(action: { self.viewModel.update() }) { Text("Update")}
      List(viewModel.games) {
        game in GameRow(game: game)
      }
    }.onAppear { self.viewModel.update() }
  }
  
  //  func getGames() {
  //    games = viewModel.games
  //  }
}

struct GameRow: View {
  let game: Games
  
  var body: some View {
    Text(game.name)
=======
      Text(viewModel.user?.username ?? "")
      GamesTableView(games: viewModel.games).onAppear(perform: { viewModel.update(); viewModel.getUser(username: "username") })
    }
>>>>>>> api
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
