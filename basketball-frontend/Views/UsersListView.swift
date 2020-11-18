//
//  UsersListView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var users: [Users]
  let status: String
  
  var body: some View {
    VStack {
      Text(status + " Users")
      List {
        ForEach(viewModel.forStatus(users: users), id: \.user.id) { arg in
          UsersListRowView(viewModel: viewModel, user: arg.user, isFavorited: arg.favorited)
        }
      }
    }
  }
}

struct UsersListRowView: View {
  @ObservedObject var viewModel: ViewModel
  let user: Users
  @State var isFavorited: Bool
  
  var body: some View {
    HStack {
      Text(user.username)
      Spacer()
      if (isFavorited) {
        Button(action: {
          self.unfavoriteActions()
        }) {
          Image("star-selected")
        }
      } else {
        Button(action: {
          self.favoriteActions()
        }) {
          Image("star-deselected")
        }
      }
    }
  }
  func favoriteActions() {
    isFavorited = true
    viewModel.favorite(favoriterId: viewModel.user!.id, favoriteeId: user.id)
  }
  
  func unfavoriteActions() {
    isFavorited = false
    viewModel.unfavorite(favoriteeId: user.id)
  }
}

//struct UsersListView_Previews: PreviewProvider {
//  static var previews: some View {
//    UsersListView()
//  }
//}
