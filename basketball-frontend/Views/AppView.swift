//
//  AppView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/4/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @ObservedObject var viewModel: ViewModel = ViewModel()
  @State var creatingGame: Bool = false
  @State var isOpen: Bool = false
  
  init() {
    //		UITabBar.appearance().isTranslucent = false
    UITabBar.appearance().barTintColor = UIColor(named: "tabBarColor")
    UITabBar.appearance().unselectedItemTintColor = UIColor(named: "tabBarIconColor")
    
  }
  var body: some View {
    
    if viewModel.currentScreen == "app" {
      GeometryReader { geometry in
        ZStack {
          TabView{
            HomeView(viewModel: viewModel, isOpen: $isOpen, selectedEvent: $viewModel.game, player: $viewModel.player)
              .tabItem{
                Image(systemName: "house.fill")
                  .font(.system(size: 25))
                  .imageScale(.large)
                Text("Home")
              }
            ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
              .tabItem{
                Image(systemName: "person.circle")
                  .font(.system(size: 25))
                  .imageScale(.large)
                Text("Profile")
              }
          }
          ZStack {
            Button(action: {
              //                    self.creatingGame = true
              viewModel.startCreating()
              
            }) {
              VStack {
                Image(systemName: "plus.circle.fill")
                  .font(.system(size: 36))
                  .imageScale(.large)
                //                Text("Create Game")
              }
            }
          }.offset(y: geometry.size.height/2 - 20)
        }
      }.sheet(isPresented: $viewModel.creatingGame) {
        CreateView(viewModel: viewModel, creatingGame: $viewModel.creatingGame)
      }
    } else if viewModel.currentScreen == "login-splash" {
      SplashView()
    } else if viewModel.currentScreen == "create-user" {
      CreateUserView(viewModel: self.viewModel)
    } else if viewModel.currentScreen == "login" {
      LoginView(viewModel: self.viewModel)
    } else if viewModel.currentScreen == "landing" {
      LandingView(viewModel: self.viewModel)
    } else {
      SplashView()
        .onAppear { self.viewModel.login(username: "jxu", password: "secret") }
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
