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
    
    var body: some View {
        ZStack {
            MapView(annotations: annotationsArray)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button("Add address") {
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
                    Button("Route") {}
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .opacity(isLocked ? 1.0 : 0.0)
                    Spacer()
                    Button("Reset") {}
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
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(annotations, animated: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
