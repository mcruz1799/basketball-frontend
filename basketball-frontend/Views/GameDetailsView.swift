//
//  GameDetailsView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct GameDetailsView: View {
//    let game: Games
  @State var game: Games = Games(id: 4, name: "Schenley Park", date: "", time: "", description: "", priv: false, longitude: 2.0, latitude: 2.0)
  
  var body: some View {
    NavigationView {
      VStack {
        Button(action: {
        }) {
          Text("Invite Friends")
            .padding()
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .background(Color.red)
            .foregroundColor(.black)
            .cornerRadius(40)
        }
      }
      
      //      Text(game.name)
    }.navigationBarTitle("Game Details")
  }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView()
    }
}
