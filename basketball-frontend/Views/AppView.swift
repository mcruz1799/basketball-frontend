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
  
  init() {
		UITabBar.appearance().isTranslucent = false
		UITabBar.appearance().barTintColor = UIColor(named: "tabBarColor")
		UITabBar.appearance().unselectedItemTintColor = UIColor(named: "tabBarIconColor")
	
  }
  var body: some View {
    
    TabView{
      HomeView(viewModel: viewModel)
        .tabItem{
          Image(systemName: "house.fill")
						.font(.system(size: 50))

        }
      CreateView(viewModel: viewModel)
        .tabItem{
          Image(systemName: "plus.circle.fill")
					
        }
      ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
        .tabItem{
          Image(systemName: "person.circle")
						.font(.system(size: 2000))


        }
		}
		.onAppear { self.viewModel.fetchData() }
  }
}


struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
