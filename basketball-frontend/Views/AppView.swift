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

  var body: some View {
		
    
    if viewModel.currentScreen == "app" {
			GeometryReader {geometry in
				VStack{
					
					if viewModel.currentTab == "home" {
						HomeView(viewModel: viewModel, isOpen: $isOpen)
					}

					else if viewModel.currentTab == "profile" {
						ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
					}
					else if viewModel.currentTab == "invites" {
						InvitedGamesList(viewModel: viewModel)
					}
					HStack{
						//Home Icon
						Image(systemName: "house")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.foregroundColor(Color("tabBarIconColor"))
	//					if self.tabBarController.currentView == "home" {
	//						.foregroundColor(.white)
	//					}
	//					else{
	//						.foregroundColor(Color("tabBarIconColor"))
	//					}
							.padding(20)
							.frame(width: geometry.size.width/3, height: 75)
							.foregroundColor(Color("tabBarIconColor"))
							.onTapGesture {
								viewModel.currentTab = "home"
							}
						
						ZStack{
							//Plus Icon
							Circle()
								.foregroundColor(Color("tabBarColor"))
								.frame(width:75, height:75)
								.offset(y: -geometry.size.height/10/2)

							Image(systemName: "plus.circle.fill")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 75, height: 75)
								.foregroundColor(Color("tabBarIconColor"))
								.offset(y: -geometry.size.height/10/2)
								.onTapGesture {
									creatingGame.toggle()
								}
						}
						//Profile Icon
						Image(systemName: "person")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.foregroundColor(Color("tabBarIconColor"))
							.padding(20)
							.frame(width: geometry.size.width/3, height: 75)
							.onTapGesture{
								viewModel.currentTab = "profile"
							}
					}
					.frame(width: geometry.size.width, height: geometry.size.height/10)
					.background(Color("tabBarColor").shadow(radius: 5))
				}
			}.edgesIgnoringSafeArea(.bottom)
				.sheet(isPresented: $creatingGame) {
					CreateView(viewModel: viewModel, creatingGame: $creatingGame)
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
