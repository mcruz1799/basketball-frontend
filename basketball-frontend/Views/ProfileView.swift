//
//  ProfileView.swift
//  basketball-frontend
//
//  Created by Matthew Cruz on 11/6/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  @Binding var user: User?
  @Binding var favorites: [Favorite]
  
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
      List {
        ForEach(favorites) { favorite in
          FavoriteRow(favorite: favorite)
        }
      }
    }
  }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
