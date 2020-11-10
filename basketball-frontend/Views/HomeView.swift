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
  
  var body: some View {
    GeometryReader { geometry in
//      MapView()
      // Content is passed as a closure to the bottom view
      BottomView(isOpen: self.$isOpen, maxHeight: geometry.size.height * 0.8) {
        GamesTableView(user: self.$viewModel.user, players: self.$viewModel.players)
      }
    }.edgesIgnoringSafeArea(.all)
  }
}

//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    HomeView()
//  }
//}
