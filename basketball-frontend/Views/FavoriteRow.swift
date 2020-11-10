//
//  FavoriteRow.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 11/4/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct FavoriteRow: View {
  let favorite: Favorite
  @ObservedObject var viewModel: ViewModel
  @State private var isFavorited: Bool = true
  
  var body: some View {
    HStack {
      Text(favorite.user.data.username)
      Spacer()
      if (isFavorited) {
        Button(action: {
					self.unfavoriteActions()
        }) {
          Image("star-selected")
        }
      } else {
        Button(action: {
          favoriteActions()
					self.unfavoriteActions()
        }) {
          Image("star-deselected")
        }
      }
    }
  }
  
  func favoriteActions() {
    isFavorited = true
    viewModel.favorite(favorite: favorite)
  }
  
  func unfavoriteActions() {
    isFavorited = false
    viewModel.unfavorite(id: favorite.id)
  }
}
