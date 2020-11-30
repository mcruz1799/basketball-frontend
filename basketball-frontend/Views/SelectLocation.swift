//
//  Select Location.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI
import MapKit

struct SelectLocation: UIViewRepresentable {
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<SelectLocation>) {

  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)

    return mapView
  }
  
}

struct SelectLocation_Previews: PreviewProvider {
  static var previews: some View {
    SelectLocation()
  }
}
