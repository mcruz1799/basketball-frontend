//
//  LocationSearchView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/19/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
  @State var locationSearch: String = ""
  @State var searchResults: [MKMapItem] = [MKMapItem]()
  let viewModel: ViewModel
  @Binding var creatingGame: Bool
  let geoCoder = CLGeocoder()
  
  var body: some View {
    let locSearch = Binding(
      get: { self.locationSearch },
      set: {
        self.locationSearch = $0;
        search()
      }
    )
    NavigationView {
      VStack {
        TextField("Search", text: locSearch)
          .padding()
        List {
          ForEach(searchResults, id: \.name) { result in
            NavigationLink(destination: CreateFormView(viewModel: viewModel,   creatingGame: $creatingGame)) {
              HStack {
                Text(result.name!)
                Text(result.placemark.locality ?? "")
              }
            }
          }
        }
      }.navigationBarTitle("Select Location")
    }
  }
  
  func search() {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = self.locationSearch
    //    searchRequest.region = yourMapView.region
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, error in
      guard let response = response else {
        print("Error: \(error?.localizedDescription ?? "Unknown error").")
        return
      }
//      response.mapItem.map({})
      self.searchResults = response.mapItems
    }
  }
}

struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(viewModel: ViewModel(), creatingGame: .constant(true))
  }
}
