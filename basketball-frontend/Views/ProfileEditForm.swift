//
//  ProfileEditForm.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 11/5/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileEditFrom: View {
  
  var viewModel: ViewModel
  
  @state var username: String = ""
  @state var firstname: String = ""
  @state var lastname: String = ""
  
  var body: some View {
    VStack {
      HStack {
        Text("Username:")
          .fontWeight(.bold)
          .padding(.leading)
        TextField("Username", text: $username)
          .padding(.trailing)
      }.padding()
      
      HStack {
        Text("First Name:")
          .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
          .padding(.leading)
        TextField("First Name", text: $firstname)
          .padding(.trailing)
      }.padding()
      
      HStack {
        Text("Last Name:")
          .fontWeight(.bold)
          .padding(.leading)
        TextField("Last Name", text: $lastname)
          .padding(.trailing)
      }.padding()
    }
    .navigationBarTitle("Edit Your Information")
    .navigationBarItems(trailing:
                          Button(action: {})) {
      Text("Done")
    }
  }
}
