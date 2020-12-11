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
  @Binding var groupedPlayers: [Dictionary<String, [Player]>.Element]
  @Binding var isOpen: Bool
  //  let players = Bundle.main.decode([Player].self, from: "players.json")
  
  var body: some View {
    
    NavigationView {
      //      VStack {
      //        Text("GotNext")
      List {
        ForEach(viewModel.groupPlayers(players: players), id: \.key) { player in
          DateRow(viewModel: viewModel, date: player.key, players: player.value, game: $viewModel.game)
        }
      }.navigationBarTitle("") // Title must be set to use hidden property
      .navigationBarHidden(true)}
    //    }
  }
}

struct DateRow: View {
  @ObservedObject var viewModel: ViewModel
  let date: String
  let players: [Player]?
  @Binding var game: Game?
  
  var body: some View {
    Section(header: Text(date)) {
      //      ForEach(players ?? [Player]()) { player in
      //        NavigationLink(destination: GameDetailsView(viewModel: viewModel, player: player, game: g, status: player.status)) {
      //          GameRow(player: player)}
      //      }
      //      ForEach(players ?? [Player]()) { player in
      //        NavigationLink(destination: Wrapper(viewModel: viewModel, player: player, game:   player.game.data, status: player.status)) {
      //          GameRow(player: player)}
      //      }
      ForEach(players ?? [Player]()) { player in
        GameRow(player: player, viewModel: viewModel)
      }
    }
  }
}


struct GameRow: View {
  @State var player: Player
  @State var showDetails: Bool = false
  @State var selectedEvent: Game? = nil
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    Button(action: { viewModel.showDetails = true; viewModel.game = player.game.data; viewModel.player = player; viewModel.getGame(id: player.game.data.id) }) {
      
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
//    .sheet(isPresented: $showDetails){
//      GameDetailsView(viewModel: self.viewModel, player: $viewModel.player, game: $viewModel.game)
//    }
  }
}

struct GamesTableView_Previews: PreviewProvider {
  static var previews: some View {
    let user = User(id: 4, username: "jigims", email: "", firstName: "JJ", lastName: "Igims", dob: "", phone: "", players: [APIData<Player>](), favorites: [APIData<Favorite>]())
    GamesTableView(viewModel: ViewModel(), user: .constant(user), players: .constant([Player]()), groupedPlayers: .constant([Dictionary<String, [Player]>.Element]()), isOpen: .constant(true))
  }
}
