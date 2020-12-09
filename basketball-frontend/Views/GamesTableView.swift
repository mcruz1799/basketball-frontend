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
  //  @Binding var players: [Player]
  @Binding var groupedPlayers: [Dictionary<String, [Player]>.Element]
  @Binding var isOpen: Bool
  //  let players = Bundle.main.decode([Player].self, from: "players.json")
  
  var body: some View {
    
    NavigationView {
//      VStack {
//        Text("GotNext")
        List {
          ForEach(groupedPlayers, id: \.key) { player in
            DateRow(viewModel: viewModel, date: player.key, players: player.value)
          }
        }.navigationBarTitle("") // Title must be set to use hidden property
        .navigationBarHidden(true)}
//    }
  }
}

struct DateRow: View {
  let viewModel: ViewModel
  let date: String
  let players: [Player]?
  
  var body: some View {
    Section(header: Text(date)) {
      ForEach(players ?? [Player]()) { player in
        NavigationLink(destination: GameDetailsView(viewModel: viewModel, player: player, status: player.status)) {
          GameRow(player: player)}
      }
    }
  }
}


struct GameRow: View {
  let player: Player
  
  var body: some View {
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

struct GamesTableView_Previews: PreviewProvider {
  static var previews: some View {
    let user = User(id: 4, username: "jigims", email: "", firstName: "JJ", lastName: "Igims", dob: "", phone: "", players: [APIData<Player>](), favorites: [APIData<Favorite>]())
    GamesTableView(viewModel: ViewModel(), user: .constant(user), groupedPlayers: .constant([Dictionary<String, [Player]>.Element]()), isOpen: .constant(true))
  }
}
