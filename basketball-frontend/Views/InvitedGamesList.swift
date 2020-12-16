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
        GameRow(viewModel: viewModel, player: player)
      }
    }
  }
}

struct InvitedGamesList_Previews: PreviewProvider {
  static var previews: some View {
    InvitedGamesList(viewModel: ViewModel())
  }
}
