//
//  HomeView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var isOpen: Bool
  @State var selectedEvent: Game? = nil
  @State var showDetails: Bool = false
  
  var body: some View {
    GeometryReader { geometry in
      MapView(viewModel: self.viewModel, selectedEvent: self.$selectedEvent, showDetails: self.$showDetails, games: viewModel.games)
        // Close the feed when the map is tapped
//        .onTapGesture() {
//          self.isOpen = false
//        }
        .sheet(isPresented: self.$showDetails){
          GameDetailsView(viewModel: self.viewModel, player: viewModel.players[0], status: "Going")
        }
      // Content is passed as a closure to the bottom view
      BottomView(isOpen: self.$isOpen, maxHeight: geometry.size.height * 0.84) {
        GamesTableView(viewModel: self.viewModel, user: self.$viewModel.user, groupedPlayers: self.$viewModel.groupedPlayers, isOpen: $isOpen)
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}


//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    HomeView()
//  }
//}
