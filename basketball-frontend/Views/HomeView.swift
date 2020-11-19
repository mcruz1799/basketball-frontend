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
  @State private var isOpen = false
	@State var selectedEvent: Game? = nil
	@State var showDetails: Bool = false
  
  var body: some View {
    GeometryReader { geometry in
			
      MapView(viewModel: self.viewModel, gameAnnotations: self.$viewModel.gameAnnotations, selectedEvent: self.$selectedEvent, showDetails: self.$showDetails, games: viewModel.games)
			
				.sheet(isPresented: self.$showDetails){
//					GameDetailsView(viewModel: self.viewModel, game: self.$selectedEvent, player: viewModel.players[0])
					GameDetailsView(viewModel: self.viewModel, player: viewModel.players[0], status: "Going")

				}
			
			// Content is passed as a closure to the bottom view
			BottomView(isOpen: self.$isOpen, maxHeight: geometry.size.height * 0.8) {
				GamesTableView(viewModel: self.viewModel, user: self.$viewModel.user, players: self.$viewModel.players)
      }
    }.edgesIgnoringSafeArea(.all)
  }
}


//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    HomeView()
//  }
//}
