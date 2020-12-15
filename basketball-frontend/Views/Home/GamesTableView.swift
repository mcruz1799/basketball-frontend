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
  
  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.groupPlayers(players: viewModel.players), id: \.key) { player in
          DateRow(viewModel: viewModel, date: player.key, players: player.value)
        }
      }
      .navigationBarTitle("") // Title must be set to use hidden property
      .navigationBarHidden(true)}
  }
}

struct DateRow: View {
  @ObservedObject var viewModel: ViewModel
  let date: String
  let players: [Player]?
  
  var body: some View {
    Section(header: Text(date)) {
      ForEach(players ?? [Player]()) { player in
        GameRow(viewModel: viewModel, player: player)
      }
    }
  }
}


struct GameRow: View {
  @ObservedObject var viewModel: ViewModel
  let player: Player
  
  var body: some View {
    Button(action: { viewModel.showDetails(); viewModel.game = player.game.data; viewModel.player = player; viewModel.getGame(id: player.game.data.id) }) {
      
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
}

struct GamesTableView_Previews: PreviewProvider {
  static var previews: some View {
    GamesTableView(viewModel: ViewModel())
  }
}
