//
//  MapView.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import SwiftUI
import MapKit
import SwiftUICharts


struct MapView: UIViewRepresentable {
    
    @Binding var showGraph: Bool
    var locationManager = CLLocationManager()
    @State private var annotation = MKPointAnnotation()
    let mapType: MKMapType

    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        let mapView = SIMSMap()
        mapView.frame = UIScreen.main.bounds
        mapView.onLongPress = addAnnotation(for:)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 4000,
                                                            maxCenterCoordinateDistance: 19000000)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = mapType
        mapView.showsScale = true
        mapView.isRotateEnabled = false
        MKMapView.appearance().mapType = .satellite
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0.0, bottom: -60.0, right: 0.0)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordinate
        annotation = newAnnotation
        showGraph.toggle()
    }
}

class SIMSMap: MKMapView {
    
    let api = NetworkManager()
    var onLongPress: (CLLocationCoordinate2D) -> Void = { _ in }
        
    init() {
        super.init(frame: .zero)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gestureRecognizer.minimumPressDuration = 0.5
        addGestureRecognizer(gestureRecognizer)
    }

    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self)
            let coordinate = convert(location, toCoordinateFrom: self)
            onLongPress(coordinate)
            api.fetchLocationData(loc: coordinate)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
