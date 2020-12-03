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
        SearchBarView<MKMapItem>(searchText: locSearch, searchResults: $searchResults)
        List {
          ForEach(searchResults, id: \.name) { result in
            NavigationLink(destination: CreateFormView(viewModel: viewModel,   location: result, creatingGame: $creatingGame)) {
              VStack(alignment: .leading) {
                Text(result.name ?? "").bold()
                Text(Helper.parseAddress(selectedItem: result.placemark))
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
      self.searchResults = response.mapItems
    }
  }
}

struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(viewModel: ViewModel(), creatingGame: .constant(true))
  }
}
