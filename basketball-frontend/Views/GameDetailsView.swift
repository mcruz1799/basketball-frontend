//
//  GameDetailsView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct GameDetailsView: View {
  let game: Games
  
    var body: some View {
      Text(game.name)
    }
}

//struct GameDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameDetailsView()
//    }
//}
