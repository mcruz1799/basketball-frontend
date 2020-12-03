//
//  LandingView.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 12/1/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct LandingView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    VStack {
      Button(action: {
        self.viewModel.currentScreen = "login"
      }) {
        Text("Login")
      }
      
      Button(action: {
        self.viewModel.currentScreen = "create-user"
      }) {
        Text("Create User")
      }
      
      Button(action: {
        self.viewModel.login(username: "jxu", password: "secret")
      }) {
        Text("Testing")
      }
    }
  }
}
