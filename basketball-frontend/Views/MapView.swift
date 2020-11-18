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
		@Binding var gameAnnotations: [GameAnnotation]
		@Binding var selectedEvent: Game?
		@Binding var showDetails: Bool

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
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
				if annotation is MKUserLocation {
					return nil
				}
				let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
				view.canShowCallout = true
				view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

				return view
		}
		
		
		func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
				if control == view.rightCalloutAccessoryView {
					parent.showDetails = true
				}
		}
		
		
		func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
			let currAnnotation = view.annotation as? GameAnnotation
			parent.viewModel.getGame(id: Int(currAnnotation!.id)!)
			parent.selectedEvent = parent.viewModel.game
//			parent.showDetails = true
		}
		func mapView(_: MKMapView, didDeselect view: MKAnnotationView) {
			parent.selectedEvent = nil
			parent.showDetails = false
		}
	}
	
	func makeCoordinator() -> MapView.Coordinator {
		Coordinator(self)
	}
	
	func makeGameAnnotations(_ mapView: MKMapView){
		var loaded = false
		DispatchQueue.main.async {
			while(!loaded){

				self.viewModel.getGameAnnotations()
				if (self.viewModel.gameAnnotations.count > 0){
					loaded = true
				}
				print("ANNOTATIONS: ", self.viewModel.gameAnnotations.count, "---------------------------------")
				mapView.addAnnotations(self.viewModel.gameAnnotations)
			}
		}

	}
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		makeGameAnnotations(mapView)
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
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		uiView.setRegion(region, animated: true)
		uiView.showsUserLocation = true
		//if the pins haven't been rendered yet add them
//		if (self.viewModel.gameAnnotationsLoaded)
//		{
//			print("ANNOTATIONS: ", self.viewModel.gameAnnotations.count, "---------------------------------")
//			uiView.addAnnotations(self.viewModel.gameAnnotations)
//		}

	}

		
	}


//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(viewModel: ViewModel())
//    }
//}
