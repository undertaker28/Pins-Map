//
//  ContentView.swift
//  Pins Map
//
//  Created by Pavel on 4.08.22.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @State private var annotationsArray = [MKPointAnnotation]()
    @State private var isLocked = false
    @State private var isRoute = false
    
    var body: some View {
        ZStack {
            MapView(annotations: annotationsArray, isRoute: isRoute, isReset: !isLocked)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button("Add address") {
                        isRoute = false
                        alertAddAddress(title: "Add address", placeholder: "Add address") { [self] (text) in
                            setupPlacemark(addressPlace: text)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
                Spacer()
                HStack {
                    Button("Route") {
                        isRoute = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(isLocked ? 1.0 : 0.0)
                    Spacer()
                    Button("Reset") {
                        annotationsArray = [MKPointAnnotation]()
                        isRoute = false
                        isLocked = false
                    }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .opacity(isLocked ? 1.0 : 0.0)
                }
                .padding()
            }
        }
    }
    
    private func setupPlacemark(addressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressPlace) { [self] (placemarks, error) in
            if let error = error {
                print(error)
                alertError(title: "Error", message: "Try again!")
                return
            }
            
            guard let placemarks = placemarks else {
                return
            }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = addressPlace
            
            guard let placemarkLocation = placemark?.location else {
                return
            }
            annotation.coordinate = placemarkLocation.coordinate
            annotationsArray.append(annotation)
            
            if annotationsArray.count > 2 {
                isLocked = true
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    var annotations = [MKPointAnnotation]()
    let isRoute: Bool
    let isReset: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if isRoute {
            for index in 0...annotations.count - 2 {
                let startLocation = MKPlacemark(coordinate: annotations[index].coordinate)
                let destinationLocation = MKPlacemark(coordinate: annotations[index + 1].coordinate)
                
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: startLocation)
                request.destination = MKMapItem(placemark: destinationLocation)
                request.transportType = .walking
                request.requestsAlternateRoutes = true
                
                let direction = MKDirections(request: request)
                direction.calculate { (response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let response = response else {
                        self.alertError(title: "Error", message: "Try again!")
                        return
                    }
                    
                    var minRoute = response.routes[0]
                    for route in response.routes {
                        minRoute = (route.distance < minRoute.distance) ? route : minRoute
                    }
                    
                    uiView.addOverlay(minRoute.polyline)
                }
            }
        }
        if isReset {
            uiView.removeOverlays(uiView.overlays)
            uiView.removeAnnotations(uiView.annotations)
        }
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(annotations, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
