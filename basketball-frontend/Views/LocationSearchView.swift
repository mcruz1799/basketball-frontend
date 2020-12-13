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
  @ObservedObject var viewModel: ViewModel
  
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
          ForEach(searchResults, id: \.self) { result in
            NavigationLink(destination: CreateFormView(viewModel: viewModel, location: result)) {
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
      print(self.searchResults)
    }
  }
}

struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(viewModel: ViewModel())
  }
}
