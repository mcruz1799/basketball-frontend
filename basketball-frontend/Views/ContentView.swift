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
  
  var body: some View {
    VStack {
      Text(viewModel.user?.username ?? "")
      GamesTableView(games: viewModel.games).onAppear(perform: { viewModel.update(); viewModel.getUser(username: "username") })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
