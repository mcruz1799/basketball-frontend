//
//  GamesTableView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct GamesTableView: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var user: User?
  @Binding var players: [Player]
  //  let players = Bundle.main.decode([Player].self, from: "players.json")
  
  var body: some View {
    
    NavigationView {
      List {
        ForEach(players) { player in
//          NavigationLink(destination: GameDetailsView(viewModel: viewModel, game: player)) {
//            GameRow(player: player)}
        }
      }.navigationBarTitle("") // Title must be set to use hidden property
      .navigationBarHidden(true)}
  }
}

struct GameRow: View {
  let player: Player
  
  var body: some View {
    //    let game = player.game.data
    VStack {
      HStack {
        Text(player.game.data.name).bold()
        Spacer()
        Text(player.status)
      }.padding(.bottom, 5)
      HStack {
        Text(player.game.data.onTime())
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
