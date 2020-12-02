//
//  LoginView.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 12/1/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginView: View {
  var viewModel: ViewModel
  
  @State var username: String = ""
  @State var password: String = ""
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Username", text: $username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
          SecureField("Password", text: $password)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        
        Button(action: {
          login()
        }) {
          Text("Login")
        }
        
      }.navigationBarTitle("Welcome to Basketball App")
    }
  }
  
  func login() {
    viewModel.login(username: username, password: password)
  }
}
