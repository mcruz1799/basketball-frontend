//
//  UsersListView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
  @Binding var users: [Users]
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    List {
      ForEach(users) { user in  
        if (viewModel.isFavorite(userId: user.id)) {
          let favorite = viewModel.findFavorite(favoriterId: viewModel.user!.id, favoriteeId: user.id)
          PlayerRow(user: user, viewModel: viewModel, isFavorited: true, favorite: favorite)
        } else {
          PlayerRow(user: user, viewModel: viewModel, isFavorited: false, favorite: nil)
        }
      }
    }
  }
}

//struct UsersListView_Previews: PreviewProvider {
//  static var previews: some View {
//    UsersListView()
//  }
//}
