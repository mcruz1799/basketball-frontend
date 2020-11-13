//
//  PlayerRow.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 11/11/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation

import Foundation
import SwiftUI

struct PlayerRow: View {
  let user: Users
  @ObservedObject var viewModel: ViewModel
  @State var isFavorited: Bool = true
  @State var favorite: Favorite?
  
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
    favorite = viewModel.favoriteWithIds(favoriterId: viewModel.user!.id, favoriteeId: self.user.id)
  }
  
  func unfavoriteActions() {
//    isFavorited = false
//    viewModel.unfavorite(id: favorite!.id)
  }
}
