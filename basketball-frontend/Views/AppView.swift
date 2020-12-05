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
	@ObservedObject var tabController = TabController()
  

  var body: some View {
		GeometryReader {geometry in
			VStack{
				
				if self.tabController.currentView == "home" {
					HomeView(viewModel: viewModel)
				}
				else if tabController.currentView == "create" {
					CreateView(viewModel: viewModel)
				}
				else if tabController.currentView == "profile" {
					ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
					
				}
				HStack{
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
							self.tabController.currentView = "home"
						}
					ZStack{
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
								self.tabController.currentView = "create"
							}
					}
					Image(systemName: "person")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.foregroundColor(Color("tabBarIconColor"))
						.padding(20)
						.frame(width: geometry.size.width/3, height: 75)
						.onTapGesture{
							self.tabController.currentView = "profile"
						}
				}
				.frame(width: geometry.size.width, height: geometry.size.height/10)
				.background(Color("tabBarColor").shadow(radius: 2))
			}
		}.edgesIgnoringSafeArea(.bottom)
		
//    TabView{
//      HomeView(viewModel: viewModel)
//        .tabItem{
//          Image(systemName: "house.fill")
////						.font(.system(size: 50))
//
//        }
//      CreateView(viewModel: viewModel)
//        .tabItem{
//          Image(systemName: "plus.circle.fill")
//
//        }
//      ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
//        .tabItem{
//          Image(systemName: "person.circle")
////						.font(.system(size: 2000))
//
//
//        }
//		}.accentColor(.gray)
		.onAppear { self.viewModel.fetchData() }
  }
}


struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
