//
//  AppView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/4/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct AppView: View {
  var body: some View {
    TabView{
      ContentView()
        .tabItem{
          Image(systemName: "house.fill")
						.imageScale(.large)
					Text("Home")
        }
			CreateView()
				.tabItem{
					Image(systemName: "plus.circle.fill")
						.imageScale(.large)
					Text("Create Game")
			}
      ProfileDetail()
        .tabItem{
          Image(systemName: "person.circle")
						.imageScale(.large)
          Text("Profile")
      }
    }
  }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
