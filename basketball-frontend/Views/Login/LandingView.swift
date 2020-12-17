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
  var CR: CGFloat = 20
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        Image("logo")
				Text("GotNext")
					.font(.largeTitle)
					.foregroundColor(Color("tabBarColor"))
        Spacer()
        NavigationLink(destination: LoginView(viewModel: viewModel)) {
          Text("Log In")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("primaryButtonColor"))
            .foregroundColor(.black)
            .cornerRadius(CR)
            .padding([.trailing, .leading])
        }
        
        NavigationLink(destination: CreateUserView(viewModel: viewModel)) {
          Text("Create Account")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("secondaryButtonColor"))
            .foregroundColor(.black)
            .cornerRadius(CR)
            .padding([.trailing, .leading])
        }
      }
    }
  }
}

struct LandingView_Previews: PreviewProvider {
  static var previews: some View {
    LandingView(viewModel: ViewModel())
  }
}
