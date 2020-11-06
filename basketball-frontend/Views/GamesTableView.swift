//
//  GamesTableView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/5/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct GamesTableView: View {
  let games: [Games]
  
  var body: some View {
    NavigationView {
      List {
        ForEach(games) { game in
          GameRow(game: game)
        }
      }.navigationBarTitle("") // Title must be set to use hidden property
      .navigationBarHidden(true)}
  }
}

//struct DateRow: View {
//  let date: GamesDate
//
//  var body: some View {
//    let games = date.games
//    Section(header: Text(date.date)) {
//      ForEach(games) { game in
//        NavigationLink(destination: GameDetailsView(game: game)) {
//          GameRow(game: game)}
//      }
//    }
//  }
//}

struct GameRow: View {
  let game: Games
  
  var body: some View {
    VStack {
      HStack {
        Text(game.name).bold()
        Spacer()
        Text(game.name)
      }.padding(.bottom, 5)
      HStack {
        Text(game.time)
        Spacer()
        Image(systemName: "arrow.right")
      }
    }.padding(10)
    
  }
}

//struct GamesTableView_Previews: PreviewProvider {
//  static var previews: some View {
//    GamesTableView()
//  }
//}
