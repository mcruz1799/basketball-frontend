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
//    var body: some View {
	
//    }
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapView
		
		init (_ parent: MapView) {
			self.parent = parent
		}
		//runs every time user interacts and moves map some way
		//can possibly be used to make pins disappear at certain distance?
		func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
				print(mapView.centerCoordinate)
		}
		//used to change what the annotation view looks like
		//can build a custom view
//		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//				let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//				view.canShowCallout = true
//				return view
//		}
	}
	
	func makeCoordinator() -> MapView.Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		
//		let annotation = MKPointAnnotation()
//		annotation.title = "London"
//    annotation.subtitle = "Capital of England"
//    annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13)
//    mapView.addAnnotation(annotation)
		
		makeGamePins(mapView: mapView)

    return mapView
		
	}
	func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
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

	func makeGamePins(mapView: MKMapView) {
		let games: [Games] = viewModel.games
		for game in games {
			let droppedPin = MKPointAnnotation()
			droppedPin.coordinate = CLLocationCoordinate2D(
					latitude: game.latitude,
					longitude: game.longitude
			)
			print("MADE GAME", game.latitude)

			droppedPin.title = game.name
			droppedPin.subtitle = game.time
			mapView.addAnnotation(droppedPin)
		}
	}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: ViewModel())
    }
}
