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
  
  var body: some View {
    
    if viewModel.currentScreen == "app" {
      GeometryReader { geometry in
        VStack {
          
          if viewModel.currentTab == "home" {
            HomeView(viewModel: viewModel)
          }
          
          else if viewModel.currentTab == "profile" {
            ProfileView(viewModel: viewModel)
          }
          else if viewModel.currentTab == "invites" {
            InvitedGamesList(viewModel: viewModel)
          }
          TabBarView(viewModel: viewModel, geometry: geometry)
        }
      }
      .edgesIgnoringSafeArea(.bottom)
      .sheet(isPresented: $viewModel.showingSheet, content: sheetContent)
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

extension AppView {
  @ViewBuilder func sheetContent() -> some View {
    switch viewModel.activeSheet {
    case .creatingGame:
      CreateView(viewModel: viewModel)
    case .showingDetails:
      NavigationView {
        GameDetailsView(viewModel: self.viewModel, player: $viewModel.player, game: $viewModel.game)
      }
			.navigationBarTitle("")
			.navigationBarHidden(true)
    case .searchingUsers:
      UsersSearchView(viewModel: viewModel)
    }
  }
}
