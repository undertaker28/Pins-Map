//
//  ContentView.swift
//  Pins Map
//
//  Created by Pavel on 4.08.22.
//

import SwiftUI
import UIKit
import CoreLocation
import MapKit

struct ContentView: View {
    @State private var showingAlert = false
    @State private var address: String = ""
    
    var body: some View {
        ZStack {
            MapView()
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button("Add address") {
                        alertAddAddress(title: "Add address", placeholder: "Add address") { (text) in
                            print(text)
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
                    Button("Route", action: route)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .hidden()
                    Spacer()
                    Button("Reset", action: reset)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .hidden()
                }
                .padding()
            }
        }
    }
}

func addAddress() {
    print("Add address")
}

func route() {
    print("Route")
}

func reset() {
    print("Reset")
}

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
