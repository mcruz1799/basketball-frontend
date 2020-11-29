//
//  AppView2.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/29/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct AppView2: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var logged: Bool
  
  var body: some View {
    
    if logged {
      TabView{
        HomeView(viewModel: viewModel)
          .tabItem{
            Image(systemName: "house.fill")
              .font(.system(size: 25))
              .imageScale(.large)
            Text("Home")
          }
        CreateView(viewModel: viewModel)
          .tabItem{
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 36))
              .imageScale(.large)
            Text("Create Game")
            //            .onTapGesture {
            //              self.creatingGame = true
            //            }
          }
        ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
          .tabItem{
            Image(systemName: "person.circle")
              .font(.system(size: 25))
              .imageScale(.large)
            Text("Profile")
          }
      }.onAppear { self.viewModel.fetchData() }
    } else {
      //      SplashView()
      Button("Logging In") {
        viewModel.log()
      }
    }
  }
}

//struct AppView2_Previews: PreviewProvider {
//  static var previews: some View {
//    AppView2()
//  }
//}
