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
	
	//constant holding the corner radius for all buttons
	let CR: CGFloat = 20
	
	//list of statuses
//  var statuses = ["I'm Invited", "I'm Going", "I'm a Maybe", "I'm Not Going"]
  
  var body: some View {
		
    VStack {
			
			
			//MARK: - Game Information
			
			
			HStack {
				Text("Court Name:")
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
			
			// MARK: - Player Lists by Status
			
			HStack {
				
				//Button to view going players
				Button(action: {
					assignUsers(users: viewModel.going, status: "Going")
				}) {
					VStack{
						Image(systemName: "checkmark")
						Text("\(viewModel.going.count) Going")
					}
						.padding()
						.background(Color.red)
						.foregroundColor(.black)
						.cornerRadius(CR)
						.padding([.trailing])
				}
				//Button to view maybe players
				Button(action: {
					assignUsers(users: viewModel.maybe, status: "Maybe")
				}) {
					VStack{
						Image(systemName: "questionmark.diamond")
						Text("\(viewModel.maybe.count) Maybe")
					}
						.padding()
						.background(Color.red)
						.foregroundColor(.black)
						.cornerRadius(CR)
						.padding([.trailing, .leading])
				}
				//Button to view invited players
				Button(action: {
					assignUsers(users: viewModel.invited, status: "Invited")
				}) {
					VStack{
						Image(systemName: "envelope")
						Text("\(viewModel.invited.count) Invited")

					}
						.padding()
						.background(Color.red)
						.foregroundColor(.black)
						.cornerRadius(CR)
						.padding([.leading])
				}
			}
			
			
			//MARK: - Change Status
			
			
			Button(action: {
				showingActionSheet = true
			}) {
				HStack{
					Text("Change Status")
					Image(systemName: "chevron.down")
				}
				.padding()
				.frame(maxWidth: .infinity)
				.background(Color.red)
				.foregroundColor(.black)
				.cornerRadius(CR)
				.padding([.trailing, .leading])
				

			}
			//MARK: - Invite Users
			NavigationLink(destination: InvitingUsersView(viewModel: viewModel)) {
				Text("Invite Friends")
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.red)
					.foregroundColor(.black)
					.cornerRadius(CR)
					.padding([.trailing, .leading])
			}
			

		
		//MARK: - VSTACK Modifiers
		
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
  //MARK: - Helper Methods
  func assignUsers(users: [Users], status: String) {
    self.users = users
    self.showingUsers = true
    self.statusList = status
  }
  
  func statusChange(selectedStatus: String) {
    print(selectedStatus)
    viewModel.editPlayerStatus(playerId: self.player.id, status: selectedStatus)
    self.status = selectedStatus
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
