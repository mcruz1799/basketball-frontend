//
//  GameDetailsView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct GameDetailsView: View {
  @ObservedObject var viewModel: ViewModel
  let player: Player
  //  @State var game: Game = Game(id: 4, name: "Schenley Park", date: "", time: "", description: "", priv: false, longitude: 2.0, latitude: 2.0, invited: [APIData<Users>](), maybe: [APIData<Users>](), going: [APIData<Users>]())
  @State var showingUsers = false
  @State var status: String
  @State var statusList: String = "Invited"
  @State var invitingUsers = false
  @State var showingActionSheet = false
  @State var users: [Users] = [Users]()
  @State private var selectedStatus = 0
  var statuses = ["I'm Invited", "I'm Going", "I'm Maybe", "I'm Not Going"]
  
  var body: some View {
    VStack {
      VStack {
        HStack {
          Button(action: {
            assignUsers(users: viewModel.invited, status: "Invited")
          }) {
            Text("Invited")
              .padding()
              .background(Color.red)
              .foregroundColor(.black)
              .cornerRadius(40)
              .padding([.trailing, .leading])
          }
          Button(action: {
            assignUsers(users: viewModel.going, status: "Going")
          }) {
            Text("Going")
              .padding()
              .background(Color.red)
              .foregroundColor(.black)
              .cornerRadius(40)
              .padding([.trailing, .leading])
          }
          Button(action: {
            assignUsers(users: viewModel.maybe, status: "Maybe")
          }) {
            Text("Maybe")
              .padding()
              .background(Color.red)
              .foregroundColor(.black)
              .cornerRadius(40)
              .padding([.trailing, .leading])
          }
        }
        Button(action: {
          showingActionSheet = true
        }) {
          Text("Change Status")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.black)
            .cornerRadius(40)
            .padding([.trailing, .leading])
        }
        NavigationLink(destination: InvitingUsersView(viewModel: viewModel)) {
          Text("Invite Friends")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.black)
            .cornerRadius(40)
            .padding([.trailing, .leading])
        }
        
        HStack {
          Text("Name:")
            .padding(.leading)
          Spacer()
          Text(player.game.data.name)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }              .padding([.trailing, .leading])
        
        
        HStack {
          Text("Date:")
            .padding(.leading)
          Spacer()
          Text(player.game.data.onDate())
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }              .padding([.trailing, .leading])
        
        HStack {
          Text("Time:")
            .padding(.leading)
          Spacer()
          Text(player.game.data.onTime())
            .fontWeight(.bold)
        }              .padding([.trailing, .leading])
        
        HStack {
          Text("Status:")
            .padding(.leading)
          Spacer()
          Text(status)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        }              .padding([.trailing, .leading])
        
      }
      .navigationBarTitle("Game Details")
      .onAppear { self.viewModel.getGame(id: player.game.data.id) }
      .sheet(isPresented: $showingUsers) {
        UsersListView(viewModel: viewModel, users: $users, status: statusList)
      }
      .actionSheet(isPresented: $showingActionSheet) {
        ActionSheet(title: Text("Change Status"), message: Text("Select a new color"), buttons: [
          .default(Text("Invited")) { statusChange(selectedStatus: "I'm Invited") },
          .default(Text("Maybe")) { statusChange(selectedStatus: "I'm Maybe") },
          .default(Text("Going")) { statusChange(selectedStatus: "I'm Going") },
          .default(Text("Not Going")) { statusChange(selectedStatus: "I'm Not Going") },
          .cancel()
        ])
//         UsersListView(users: $users, viewModel: viewModel)
      }
      Spacer()
    }
  }
  
  func assignUsers(users: [Users], status: String) {
    self.users = users
    self.showingUsers = true
    self.statusList = status
  }
  
  func statusChange(selectedStatus: String) {
    print(selectedStatus)
    viewModel.updateStatus(player_id: self.player.id, status: selectedStatus)
    self.status = selectedStatus
  }
}

//struct GameDetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    GameDetailsView()
//    
//  }
//}

extension Binding {
  func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
    return Binding(
      get: { self.wrappedValue },
      set: { selection in
        self.wrappedValue = selection
        handler(selection)
      })
  }
}
