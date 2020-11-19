//
//  CreateMapView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/10/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI
import MapKit

struct CreateMapView: UIViewRepresentable {
  @ObservedObject var viewModel: ViewModel
  
  class Coordinator: NSObject, MKMapViewDelegate {
    var parent: CreateMapView
    
    init (_ parent: CreateMapView) {
      self.parent = parent
    }
    //runs every time user interacts and moves map some way
    //can possibly be used to make pins disappear at certain distance?
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
      print(mapView.centerCoordinate)
    }
    //used to change what the annotation view looks like
    //can build a custom view
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
    //        view.canShowCallout = true
    //        return view
    //    }
  }
  
  func makeCoordinator() -> CreateMapView.Coordinator {
    Coordinator(self)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    var uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
    uilgr.minimumPressDuration = 2.0
    mapView.addGestureRecognizer(uilgr)
    return mapView
    
  }
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CreateMapView>) {
    let userLocation = viewModel.userLocation  
    userLocation.getCurrentLocation()
    userLocation.loadLocation()
    let coordinate = CLLocationCoordinate2D(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude
    )
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    uiView.setRegion(region, animated: true)
    uiView.showsUserLocation = true
  }
  
//  func makeGamePins(mapView: MKMapView) {
//    let games: [Games] = viewModel.games
//    for game in games {
//      let droppedPin = MKPointAnnotation()
//      droppedPin.coordinate = CLLocationCoordinate2D(
//        latitude: game.latitude,
//        longitude: game.longitude
//      )
//      droppedPin.title = game.name
//      droppedPin.subtitle = game.time
//      mapView.addAnnotation(droppedPin)
//    }
//  }
  func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
    print("GESTURE")
  }
}

struct CreateMapView_Previews: PreviewProvider {
  static var previews: some View {
    CreateMapView(viewModel: ViewModel())
  }
}
