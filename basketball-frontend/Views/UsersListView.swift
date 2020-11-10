//
//  UsersListView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
  @Binding var users: [Users]
  
  var body: some View {
    List {
      ForEach(users) { user in  
        Text(user.username)
      }
    }
  }
}

//struct UsersListView_Previews: PreviewProvider {
//  static var previews: some View {
//    UsersListView()
//  }
//}
