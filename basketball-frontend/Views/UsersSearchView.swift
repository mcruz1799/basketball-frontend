//
//  UsersSearchView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/20/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersSearchView: View {
  let viewModel: ViewModel
  @State var userSearch: String = ""
  @Binding var searchResults: [Users] 
  @State private var isEditing = false
  
  var body: some View {
    let usSearch = Binding(
      get: {
        self.userSearch },
      set: {
        self.userSearch = $0;
        search()
      }
    )
    VStack {
      SearchBarView<Users>(searchText: usSearch, searchResults: $searchResults)
      UsersListView(viewModel: viewModel, users: $searchResults)
    }.navigationBarTitle("Search Users")
    .onAppear { search() }
  }
  
  func search() {
    viewModel.searchUsers(query: self.userSearch)
  }
}

struct UsersSearchView_Previews: PreviewProvider {
  static var previews: some View {
    UsersSearchView(viewModel: ViewModel(), searchResults: .constant([Users]()))
  }
}
