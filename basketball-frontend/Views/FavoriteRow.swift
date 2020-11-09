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
  
  var body: some View {
    HStack {
      Text(favorite.user.data.username)
      Spacer()
      Image("star-selected")
    }
  }
}
