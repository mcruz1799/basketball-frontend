//
//  CreateView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct CreateView: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var creatingGame: Bool
  
  var body: some View {
    LocationSearchView(viewModel: viewModel, creatingGame: $creatingGame)
  }
}

struct CreateView_Previews: PreviewProvider {
  static var previews: some View {
    CreateView(viewModel: ViewModel(), creatingGame: .constant(true))
  }
}
