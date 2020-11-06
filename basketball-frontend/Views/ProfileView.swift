//
//  ProfileView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
			@ObservedObject var viewModel = ViewModel()
			
			var body: some View {
				VStack {
					Text("username")
						.padding()
					
					HStack {
						Text("Name:")
							.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
							.padding(.leading)
						Spacer()
						Text("Jeff Xu")
					}.padding()
					
		//      List {
		//        ForEach(viewModel.user.favorites) { favorite in
		//          FavoriteRow(favoritee: favorite)
		//        }
		//      }
				}
			}
		}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
