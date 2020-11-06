//
//  ProfileDetails.swift
//  basketball-frontend
//
//  Created by Jeff Xu on 11/3/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileDetail: View {
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

//struct ProfileDetails_Previews: PreviewProvider {
//  static var previews: some View {
//    /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//  }
//}
