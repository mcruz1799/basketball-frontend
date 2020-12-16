//
//  UsersSearchView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/20/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersSearchView: View {
  @ObservedObject var viewModel: ViewModel
  @State var userSearch: String = ""
  
  var body: some View {
    let usSearch = Binding(
      get: {
        self.userSearch },
      set: {
        self.userSearch = $0;
        search()
      }
    )
    NavigationView {
      VStack {
        SearchBarView<Users>(searchText: usSearch)
        UsersListView(viewModel: viewModel, users: $viewModel.searchResults)
      }.navigationBarTitle("Search Users")
    }
    .onAppear { search() }
  }
  
  func search() {
    viewModel.searchUsers(query: self.userSearch)
  }
}

struct UsersSearchView_Previews: PreviewProvider {
  static var previews: some View {
    UsersSearchView(viewModel: ViewModel())
  }
}
