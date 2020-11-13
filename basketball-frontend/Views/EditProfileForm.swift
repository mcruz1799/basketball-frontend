//
//  EditProfileForm.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct EditProfileForm: View {
  var viewModel: ViewModel
  
  @State var username: String = ""
  @State var firstName: String = ""
  @State var lastName: String = ""
  @State var email: String = ""
  @State var phone: String = ""
  
  var body: some View {
    Text("Edit Your Information").font(.largeTitle).bold()
//    Image("default-profile")
//      .resizable()
//      .scaledToFit()
//      .clipShape(Circle())
//      .overlay(
//        Circle()
//          .stroke(Color.white, lineWidth: 4)
//          .shadow(radius: 10)
//      )
//    VStack {
//      HStack {
//        Text("Username:")
//          .fontWeight(.bold)
//          .padding(.leading)
//				TextField("Username", text: self.$username)
//          .padding(.trailing)
//      }.padding()
//
//      HStack {
//        Text("First Name:")
//          .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//          .padding(.leading)
//				TextField("First Name", text: self.$firstName)
//          .padding(.trailing)
//      }.padding()
//
//      HStack {
//        Text("Last Name:")
//          .fontWeight(.bold)
//          .padding(.leading)
//				TextField("Last Name", text: self.$lastName)
//          .padding(.trailing)
//      }.padding()
//
//      HStack {
//        Text("Email:")
//          .fontWeight(.bold)
//          .padding(.leading)
//				TextField("Email", text: self.$email)
//          .padding(.trailing)
//      }.padding()
//
//      HStack {
//        Text("Phone:")
//          .fontWeight(.bold)
//          .padding(.leading)
//				TextField("Phone", text: self.$phone)
//          .padding(.trailing)
//      }.padding()
//
//      Button(action: {
//        self.viewModel.editUser(firstName: self.firstName, lastName: self.lastName, username: self.username, email: self.email, phone: self.phone)
//      }) {
//        Text("Save")
//      }
//    }
  }
}
