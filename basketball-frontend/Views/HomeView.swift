//
//  HomeView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct HomeView: View {
			@ObservedObject var viewModel: ViewModel = ViewModel()
			
			var body: some View {
				
				VStack {
					Text("Username:")
//					Text(viewModel.user?.data.firstName ?? "JJ")
				}
			}
			
			func getUser() {
				print("CONSOLE")
				self.viewModel.update()
			}
		}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
