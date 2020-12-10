//
//  Wrapper.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 12/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct Wrapper: View {
  @ObservedObject var viewModel: ViewModel
  @State var player: Player
  @State var game: Game?
  @State var status: String
  
  var body: some View {
    GameDetailsView(viewModel: viewModel, player: player, game: $game, status: player.status)
  }
}

//struct Wrapper_Previews: PreviewProvider {
//  static var previews: some View {
//    Wrapper()
//  }
//}
