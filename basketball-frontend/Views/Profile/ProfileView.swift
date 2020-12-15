//
//  ProfileView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    NavigationView {
      VStack {
        Image("default-profile")
          .resizable()
          .scaledToFit()
          .clipShape(Circle())
          .overlay(
            Circle()
              .stroke(Color.white, lineWidth: 4)
              .shadow(radius: 10)
          )
        
        Text(viewModel.user?.username ?? "N/A")
          .padding()
        
        HStack {
          Text("Name:")
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding(.leading)
          Spacer()
          Text(viewModel.user?.displayName() ?? "N/A")
        }.padding()
        
        HStack {
          Button(action: { viewModel.searchUsers()
          })
          {
            Text("Search Users")
            Image(systemName: "magnifyingglass")
          }
        }
        
        List {
          ForEach(viewModel.favorites) { favorite in
            FavoriteRow(favorite: favorite, viewModel: self.viewModel)
          }
        }
      }
      .navigationBarItems(leading:
                            NavigationLink(destination: EditProfileForm(
                                            viewModel: viewModel,
                                            username: viewModel.user?.username ?? "n/a",
                                            firstName: viewModel.user?.firstName ?? "n/a",
                                            lastName: viewModel.user?.lastName ?? "n/a",
                                            email: viewModel.user?.email ?? "n/a",
                                            phone: viewModel.user?.phone ?? "n/a"))
                            {
                              Image(systemName: "pencil")
                            }, trailing:
                              Button(action: {
                                viewModel.logout()
                              }) {
                                Text("Log Out")
                              }
      )
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(viewModel: ViewModel())
  }
}
