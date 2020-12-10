//
//  GameDetailsView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI
import MapKit

struct GameDetailsView: View {
  @ObservedObject var viewModel: ViewModel
  
  @Binding var player: Player?
  @Binding var game: Game?
  
  @State var showingUsers = false
  //  @State var status: String
  @State var usersStatus: String = "Going"
  @State var selectedStatusList: String = "Going"
  @State var invitingUsers = false
  @State var showingActionSheet = false
  @State var users: [Users] = [Users]()
  @State private var selectedStatus = 0
  @State var address: String = ""
  
  var CR: CGFloat = 20
  
  var body: some View {
//    NavigationView {
      VStack {
        //MARK: - Game Information
        VStack(alignment: .leading){
          HStack{
            //Court Name
            Text(game?.name ?? "")
              .font(.system(size:25))
              .fontWeight(.bold)
              .frame(alignment: .leading)
              .padding([.leading, .trailing])
            Spacer()
            //Private or Public
            if let g = game {
              if g.priv{
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
          }
          //Game Date and Time
          HStack{
            Text("\(game?.onDate() ?? "") @ \(game?.onTime() ?? "")")
              .font(.system(size: 22))
              .italic()
              .padding(.leading)
          }
        }
        .padding(.bottom)
        
        Text(address)
        
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
            Text(player?.status.capitalized ?? "Not Going")
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
//    }
    .padding()
    .background(Color("backgroundColor"))
    
    //    .onAppear { self.viewModel.getGame(id: player?.game.data.id) }
    .sheet(isPresented: $showingUsers) {
      //      UsersListView(viewModel: viewModel, users: $users, status: selectedStatusList)
      UsersListView(viewModel: viewModel, users: $users)
    }
    .actionSheet(isPresented: $showingActionSheet) {
      ActionSheet(title: Text("Change Status"), message: Text("Select a status"), buttons: [
        //				.default(Text("Invited")) { statusChange(selectedStatus: "I'm Invited") },
        .default(Text("Maybe")) { statusChange(selectedStatus: "I'm Maybe") },
        .default(Text("Going")) { statusChange(selectedStatus: "I'm Going") },
        .default(Text("Not Going")) { statusChange(selectedStatus: "I'm Not Going") },
        .cancel()
      ])
    }
    .alert(isPresented: $viewModel.showAlert) {
      viewModel.alert!
    }
    .onAppear(perform: getAddress)
    Spacer()
  }
  
  //MARK: - Helper Methods
  
  func statusChange(selectedStatus: String) {
    if let p = self.player {
      viewModel.editPlayerStatus(playerId: p.id, status: selectedStatus)
    } else {
      viewModel.createPlayer(status: selectedStatus, userId: viewModel.userId!, gameId: self.game?.id ?? 4)
    }
    //    self.status = selectedStatus
  }
  
  func assignUsers(users: [Users], status: String) {
    self.users = users
    self.showingUsers = true
    self.selectedStatusList = status
  }
  
  func getAddress() {
    Helper.coordinatesToPlacemark(latitude: game?.latitude ?? 22.0, longitude: game?.longitude ?? 22.0) { placemark in
      //      self.address = Helper.parseAddress(selectedItem: Helper.CLtoMK(placemark: placemark)!)
      self.address = Helper.parseCL(placemark: placemark)
    }
  }
}

//MARK: - Player List Button Struct
struct PlayerListButton: View {
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




