//
//  UsersStatusView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 12/16/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersStatusView: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var users: [Users]
  let status: String
  
  var body: some View {
    NavigationView {
      UsersListView(viewModel: viewModel, users: $users)
        .navigationBarTitle(status + " Users")
    }
  }
}

struct UsersStatusView_Previews: PreviewProvider {
  static var previews: some View {
    UsersStatusView(viewModel: ViewModel(), users: .constant([Users]()), status: "Going")
  }
}
