//
//  UsersSearchView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/20/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersSearchView: View {
  @State var userSearch: String = ""
  @State var searchResults: [Users] = [Users]()
  let viewModel: ViewModel
  @State private var isEditing = false
  
  var body: some View {
    let usSearch = Binding(
      get: { self.userSearch },
      set: {
        self.userSearch = $0;
        search()
      }
    )
    NavigationView {
      VStack {
        SearchBarView<Users>(searchText: usSearch, searchResults: $searchResults)
        List {
          ForEach(searchResults) { result in
            VStack(alignment: .leading) {
              Text(result.username).bold()
//              Text(parseAddress(selectedItem: result.placemark))
            }
          }
        }
      }.navigationBarTitle("Search Users")
    }
  }
  
  func search() {
    viewModel.searchUsers(query: userSearch)
  }
}

struct UsersSearchView_Previews: PreviewProvider {
  static var previews: some View {
    UsersSearchView(viewModel: ViewModel())
  }
}
