//
//  MapView.swift
//  Landmarks
//
//  Created by Luke Gavin on 11.11.19.
//  Copyright © 2019 Luke Gavin. All rights reserved.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let spanValue = 2.0
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude:-116.166868)
        let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
    
    
}




struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
