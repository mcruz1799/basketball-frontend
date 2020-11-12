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
//      print(mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, didAdd: [MKAnnotationView]) {
      
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, didChange: MKAnnotationView.DragState, fromOldState: MKAnnotationView.DragState) {
      
    }
    
    @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
      print("DOUBLE TAPPED")
    }
    
  }
  
  func makeCoordinator() -> CreateMapView.Coordinator {
    Coordinator(self)
  }
  
  func addAnnotation(gestureReconizer: UITapGestureRecognizer) {
    print("DOUBLE TAPPED")
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    //    var uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
    //    let gestureRecognizer = UITapGestureRecognizer(target: self, action:"triggerTouchAction:")
    //    gestureRecognizer.minimumPressDuration = 2.0
    //    mapView.addGestureRecognizer(gestureRecognizer)
//    let gestureRecognizer = UILongPressGestureRecognizer(target: self,     action: #selector(Coordinator.triggerTouchAction))
//    let gestureRecognizer = UILongPressGestureRecognizer(target: self,     action:   #selector(addAnnotation))
//    gestureRecognizer.minimumPressDuration = 2
//    mapView.addGestureRecognizer(gestureRecognizer)
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CreateMapView>) {
    let userLocation = viewModel.userLocation  
    viewModel.userLocation.getCurrentLocation()
    //    userLocation.loadLocation()
    print(userLocation)
    let coordinate = CLLocationCoordinate2D(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude
    )
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    uiView.setRegion(region, animated: true)
    uiView.showsUserLocation = true
    let droppedPin = MKPointAnnotation()
    droppedPin.coordinate = CLLocationCoordinate2D(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude
    )
    droppedPin.title = "Use this location"
    droppedPin.subtitle = "Look it's your car!"
    uiView.addAnnotation(droppedPin)
  }
  
}

struct CreateMapView_Previews: PreviewProvider {
  static var previews: some View {
    CreateMapView(viewModel: ViewModel())
  }
}
