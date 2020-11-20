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
            NavigationLink(destination: CreateFormView(viewModel: viewModel,   creatingGame: $creatingGame)) {
              VStack(alignment: .leading) {
                Text(result.name!).bold()
                Text(parseAddress(selectedItem: result.placemark))
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
  
  // Credit to Robert Chen, thorntech.com
  func parseAddress(selectedItem: MKPlacemark) -> String {
    // put a space between "4" and "Melrose Place"
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    // put a comma between street and city/state
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    // put a space between "Washington" and "DC"
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
      format:"%@%@%@%@%@%@%@",
      // street number
      selectedItem.subThoroughfare ?? "",
      firstSpace,
      // street name
      selectedItem.thoroughfare ?? "",
      comma,
      // city
      selectedItem.locality ?? "",
      secondSpace,
      // state
      selectedItem.administrativeArea ?? ""
    )
    return addressLine
  }
}

struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(viewModel: ViewModel(), creatingGame: .constant(true))
  }
}
