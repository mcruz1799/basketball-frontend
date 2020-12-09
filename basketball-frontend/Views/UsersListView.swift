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
//  let status: String?
  
  var body: some View {
//    NavigationView {
      //    VStack {
      //      Text(status + " Users")
      List {
        ForEach(viewModel.forStatus(users: users), id: \.user.id) { arg in
          UsersListRowView(viewModel: viewModel, user: arg.user, isFavorited: arg.favorited)
        }
        //      }
//      }
//      .navigationBarTitle((status ?? "" ) + " Users")
    }
  }
}

struct UsersListRowView: View {
  @ObservedObject var viewModel: ViewModel
  let user: Users
  @State var isFavorited: Bool
  
  var body: some View {
    HStack {
      Text(user.displayName())
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
    }.alert(isPresented: $viewModel.showAlert) {
      viewModel.alert!
    }
  }
  
  func favoriteActions() {
    isFavorited = true
    viewModel.favorite(favoriterId: viewModel.user!.id, favoriteeId: user.id)
    viewModel.refreshCurrentUser()
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
