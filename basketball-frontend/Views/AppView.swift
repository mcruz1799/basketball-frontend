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
    UITabBar.appearance().backgroundColor = UIColor.orange
  }
  var body: some View {
    
    if viewModel.currentScreen == "app" {
      TabView{
        HomeView(viewModel: viewModel)
          .tabItem{
            Image(systemName: "house.fill")
              .font(.system(size: 25))
              .imageScale(.large)
            Text("Home")
          }
        CreateView(viewModel: viewModel)
          .tabItem{
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 36))
              .imageScale(.large)
            Text("Create Game")
  //            .onTapGesture {
  //              self.creatingGame = true
  //            }
          }
        ProfileView(user: $viewModel.user, favorites: $viewModel.favorites, viewModel: viewModel)
          .tabItem{
            Image(systemName: "person.circle")
              .font(.system(size: 25))
              .imageScale(.large)
            Text("Profile")
          }
      }
    } else if viewModel.currentScreen == "login-splash" {
      SplashView()
    } else if viewModel.currentScreen == "create-user" {
      CreateUserView(viewModel: self.viewModel)
    } else if viewModel.currentScreen == "login" {
      LoginView(viewModel: self.viewModel)
    } else if viewModel.currentScreen == "landing" {
      LandingView(viewModel: self.viewModel)
    }
  }
}

//
//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
