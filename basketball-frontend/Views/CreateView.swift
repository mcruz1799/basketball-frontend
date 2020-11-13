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
  @State var creatingGame: Bool = true

  var body: some View {
    CreateFormView(viewModel: viewModel, creatingGame: $creatingGame)
  }
}

//struct CreateView_Previews: PreviewProvider {
//  static var previews: some View {
//    CreateView()
//  }
//}
