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
  
  @State var games: [Games] = []
  
  var body: some View {
    
    VStack {
      List(games) {  
        game in GameRow(game: game)
      }
    }.onAppear(perform: self.getGames)
  }
  
  func getGames() {
    games = viewModel.games
  }
}

struct GameRow: View {
  let game: Games
  
  var body: some View {
    Text(game.name)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
