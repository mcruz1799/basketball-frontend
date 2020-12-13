//
//  TabBarView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 12/13/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  @ObservedObject var viewModel: ViewModel
  var geometry: GeometryProxy

  
  var body: some View {
    HStack{
      //Home Icon
      Image(systemName: "house")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(Color("tabBarIconColor"))
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
            viewModel.startCreating()
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
}

//struct TabBarView_Previews: PreviewProvider {
//  static var previews: some View {
//    TabBarView(viewModel: ViewModel(), geometry: GeometryProxy)
//  }
//}
