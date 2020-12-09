//
//  InvitedGamesList.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 12/7/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct InvitedGamesList: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    List {
      ForEach(viewModel.getPlayerWithStatus(status: "invited")) { player in
        NavigationLink(destination: GameDetailsView(viewModel: viewModel, player: player, status: player.status)) {
          GameRow(player: player)
        }
      }
    }
  }
}
