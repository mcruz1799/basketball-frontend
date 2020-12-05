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
  @State var selectedStatusList: String = "Invited"
  @State var invitingUsers = false
  @State var showingActionSheet = false
  @State var users: [Users] = [Users]()
  @State private var selectedStatus = 0
  
  var CR: CGFloat = 20
  
  var body: some View {
    
    VStack {
      
      
      //MARK: - Game Information
      VStack(alignment: .leading){
        HStack{
          //Court Name
          Text(player.game.data.name)
            .font(.system(size:25))
            .fontWeight(.bold)
            .frame(alignment: .leading)
            .padding([.leading, .trailing])
          Spacer()
          //Private or Public
          if player.game.data.priv{
            Text("- Private")
              .italic()
              .font(.system(size: 22))
              .padding(.trailing)
          }
          else{
            Text("- Public")
              .italic()
              .font(.system(size: 22))
              .padding(.trailing)
          }
        }
        //Game Date and Time
        HStack{
          Text("\(player.game.data.onDate()) @ \(player.game.data.onTime())")
            .font(.system(size: 22))
            .italic()
            .padding(.leading)
        }
      }
      .padding(.bottom)
      
      
      
      
      
      
      
      // MARK: - Player Lists by Status
      
      HStack(alignment: .lastTextBaseline) {
        
        //Button to show list of Going players
        PlayerListButton(selectedUsers: viewModel.going, status: "Going",
                         image: "checkmark", users: $users,
                         showingUsers: $showingUsers,
                         selectedStatusList: $selectedStatusList)
        
        //Button to show list of Maybe players
        PlayerListButton(selectedUsers: viewModel.maybe, status: "Maybe",
                         image: "questionmark.diamond", users: $users,
                         showingUsers: $showingUsers,
                         selectedStatusList: $selectedStatusList)
        
        //Button to show list of Invited players
        PlayerListButton(selectedUsers: viewModel.invited, status: "Invited",
                         image: "envelope", users: $users,
                         showingUsers: $showingUsers,
                         selectedStatusList: $selectedStatusList)
        
      }
      
      
      //MARK: - Change Status
      
      
      Button(action: {
        showingActionSheet = true
      }) {
        HStack{
          Text(status.capitalized)
          Image(systemName: "chevron.down")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("secondaryButtonColor"))
        .foregroundColor(.black)
        .cornerRadius(CR)
        .padding([.trailing, .leading])
        
        
      }
      
      
      //MARK: - Invite Users
      NavigationLink(destination: InvitingUsersView(viewModel: viewModel)) {
        Text("Invite Friends")
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color("secondaryButtonColor"))
          .foregroundColor(.black)
          .cornerRadius(CR)
          .padding([.trailing, .leading])
      }
      
      
      
      //MARK: - VSTACK Modifiers
      
    }
    .padding()
    .background(Color("backgroundColor"))
    
    .onAppear { self.viewModel.getGame(id: player.game.data.id) }
    .sheet(isPresented: $showingUsers) {
      UsersListView(viewModel: viewModel, users: $users, status: selectedStatusList)
    }
    .actionSheet(isPresented: $showingActionSheet) {
      ActionSheet(title: Text("Change Status"), message: Text("Select a new color"), buttons: [
        //				.default(Text("Invited")) { statusChange(selectedStatus: "I'm Invited") },
        .default(Text("Maybe")) { statusChange(selectedStatus: "I'm a Maybe") },
        .default(Text("Going")) { statusChange(selectedStatus: "I'm Going") },
        .default(Text("Not Going")) { statusChange(selectedStatus: "I'm Not Going") },
        .cancel()
      ])
      
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
          UsersListView(viewModel: viewModel, users: $users)
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
      
      //MARK: - Player List Button Struct
      struct PlayerListButton: View{
        var selectedUsers: [Users]
        var status: String
        var image: String
        @Binding var users: [Users]
        @Binding var showingUsers: Bool
        @Binding var selectedStatusList: String
        var CR: CGFloat = 20
        var body: some View{
          //Button to view going players
          Button(action: { assignUsers(users: selectedUsers, status: status)}){
            VStack{
              Image(systemName: image)
                .font(.system(size: 20))
                .frame(width:22, height: 20)
                .padding(.bottom,2)
              Text("\(selectedUsers.count) \(status)")
            }
            //Vstack modifiers
            .padding(10)
            .background(Color("primaryButtonColor"))
            .foregroundColor(.black)
            .cornerRadius(CR)
          }
          //button modifiers
          .padding(10)
        }
        
        func assignUsers(users: [Users], status: String) {
          self.users = users
          self.showingUsers = true
          self.selectedStatusList = status
        }
      }
      
      //MARK: - Helper Methods
      
      
      func statusChange(selectedStatus: String) {
        print(selectedStatus)
        viewModel.editPlayerStatus(playerId: self.player.id, status: selectedStatus)
        self.status = selectedStatus
      }
      
    }
  }
}

//MARK: - Extensions
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




