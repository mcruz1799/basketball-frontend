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
//    viewController.carLocation.loadLocation()
//    let coordinate = CLLocationCoordinate2D(latitude: viewController.carLocation.latitude, longitude: viewController.carLocation.longitude
//    )
//    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//    let region = MKCoordinateRegion(center: coordinate, span: span)
//    uiView.setRegion(region, animated: true)
    uiView.showsUserLocation = true
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)
    let droppedPin = MKPointAnnotation()
//    droppedPin.coordinate = CLLocationCoordinate2D(
//      latitude: viewController.carLocation.latitude,
//      longitude: viewController.carLocation.longitude
//    )
//    droppedPin.title = "Your car is Here"
//    droppedPin.subtitle = "Look it's your car!"
//    mapView.addAnnotation(droppedPin)
    return mapView
    // .edgesIgnoringSafeArea(.all)
  }
  
}

struct SelectLocation_Previews: PreviewProvider {
  static var previews: some View {
    SelectLocation()
  }
}
