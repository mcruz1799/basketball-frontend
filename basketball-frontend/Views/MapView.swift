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
		@Binding var games: [Games]
//    var body: some View {
	
//    }
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapView
		static var gamePinsRendered = false
		
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
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
				let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
				view.canShowCallout = true
				return view
		}
	}
	
	func makeCoordinator() -> MapView.Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
//		let annotation = MKPointAnnotation()
//		annotation.title = "New York City"
//    annotation.subtitle = "The City that Never Sleeps"
//    annotation.coordinate = CLLocationCoordinate2D(latitude: 40, longitude: -74)
//    mapView.addAnnotation(annotation)

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
		if (Coordinator.gamePinsRendered == false) {makeGamePins(mapView: uiView)}

	}

	func makeGamePins(mapView: MKMapView) {
		print("--------------------------------GAMES-------------------------------------------")
		print(games)
		for game in games {
			let gameAnnotation = MKPointAnnotation()

			gameAnnotation.coordinate = CLLocationCoordinate2D(
					latitude: game.latitude,
					longitude: game.longitude
			)
			print("MADE GAME ---------------------------------------------------/n", game.name, game.time)

			gameAnnotation.title = game.name
			gameAnnotation.subtitle = game.time
			mapView.addAnnotation(gameAnnotation)
		}
	}
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(viewModel: ViewModel())
//    }
//}
