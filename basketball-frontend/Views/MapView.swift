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
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
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

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        let userLocation = viewModel.userLocation
				userLocation.getCurrentLocation()
        userLocation.loadLocation()
        let droppedPin = MKPointAnnotation()
        droppedPin.coordinate = CLLocationCoordinate2D(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude
        )
        droppedPin.title = "You are Here"
        droppedPin.subtitle = "Look it's you!"
        mapView.addAnnotation(droppedPin)
        return mapView
       
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: ViewModel())
    }
}
