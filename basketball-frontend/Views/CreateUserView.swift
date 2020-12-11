//
//  CreateUserView.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 12/1/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct CreateUserView: View {
  @ObservedObject var viewModel: ViewModel
  
  @State var username: String = ""
  @State var firstname: String = ""
  @State var lastname: String = ""
  @State var dob: Date = Date()
  @State var email: String = ""
  @State var phone: String = ""
  @State var password: String = ""
  @State var passwordConfirmation: String = ""
  
  var body: some View {
    
    Form {
      Section {
        TextField("Username", text: $username)
          .autocapitalization(.none)
          .disableAutocorrection(true)
        TextField("First Name", text: $firstname)
          .disableAutocorrection(true)
        TextField("Last Name", text: $lastname)
          .disableAutocorrection(true)
        DatePicker("Date of Birth", selection: $dob, in: ...Date(), displayedComponents: [.date])
        TextField("Email", text: $email)
          .autocapitalization(.none)
          .disableAutocorrection(true)
        TextField("Phone", text: $phone)
          .autocapitalization(.none)
          .disableAutocorrection(true)
        SecureField("Password", text: $password)
          .autocapitalization(.none)
          .disableAutocorrection(true)
        SecureField("Password Confirmation", text: $passwordConfirmation)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      }
      
      Button(action: {
        createUser()
      }) {
        Text("Sign Up")
      }
    }.navigationBarTitle("Create Your Profile")
    .alert(isPresented: $viewModel.showAlert) {
      viewModel.alert!
    }
  }
  
  func createUser() {
    viewModel.createUser(firstName: firstname, lastName: lastname, username: username, email: email, dob: dob, phone: phone, password: password, passwordConfirmation: passwordConfirmation)
  }
}
