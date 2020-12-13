//
//  MapView.swift
//  FindMyCar
//
//  Created by Matthew Cruz on 10/11/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  @ObservedObject var viewModel: ViewModel
  @Binding var selectedEvent: Game?
  @Binding var event: Games?
  @Binding var showDetails: Bool
  let games: [Games]
  
  class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init (_ parent: MapView) {
      self.parent = parent
    }
    //runs every time user interacts and moves map some way
    //can possibly be used to make pins disappear at certain distance?
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
      //			print(mapView.centerCoordinate)
    }
    //used to change what the annotation view looks like
    //can build a custom view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if annotation is MKUserLocation {
        return nil
      }
      let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
      view.canShowCallout = true
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      
      return view
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      if control == view.rightCalloutAccessoryView {
//        parent.showDetails = true
        parent.viewModel.showDetails = true
      }
    }
    
    
    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
      let currAnnotation = view.annotation as? GameAnnotation
      if let curr = currAnnotation {
        parent.viewModel.getGame(id: Int(curr.id))
        parent.viewModel.findPlayer(gameId: curr.id)  
        parent.event = curr.game
      }
      parent.selectedEvent = parent.viewModel.game
      print(view)
    }
		
    func mapView(_: MKMapView, didDeselect view: MKAnnotationView) {
      parent.selectedEvent = nil
      parent.showDetails = false
    }
  }
  
  func makeCoordinator() -> MapView.Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    let userLocation = viewModel.userLocation
    userLocation.getCurrentLocation()
    userLocation.loadLocation()
    let coordinate = CLLocationCoordinate2D(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude
    )
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
    mapView.showsUserLocation = true
    return mapView
    
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    let annotations = games.map({ GameAnnotation(id: $0.id, subtitle: $0.name, title:   $0.name, latitude: $0.latitude, longitude: $0.longitude, game: $0)})
    uiView.addAnnotations(annotations)
    
  }
  
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//			MapView(viewModel: ViewModel(), gameAnnotations: viewModel.gameAnnotations)
//    }
//}
