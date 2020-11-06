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
  var favoritee: User
  
  var body: some View {
    HStack {
      Text(favoritee.username)
      Spacer()
      Image("star-selected")
    }
  }
}
