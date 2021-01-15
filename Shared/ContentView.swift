//
//  ContentView.swift
//  Shared
//
//  Created by Will Carrara on 12/20/20.
//

import SwiftUI
import MapKit
import SwiftUICharts

import Alamofire

let nc = NotificationCenter.default

// wrapper for Mapkit to allow long touch action (final?)
class WrappedMap: MKMapView {
    // initilize long press
    var onLongPress: (CLLocationCoordinate2D) -> Void = { _ in }
        
    init() {
        super.init(frame: .zero)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        // set long press time
        gestureRecognizer.minimumPressDuration = 0.5
        
        // add gesture to regognized genstures
        addGestureRecognizer(gestureRecognizer)
    }

    // function to handle long tap
    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        // check if touch occured
        if sender.state == .began {
            // obtain location of touch
            let location = sender.location(in: self)
            let coordinate = convert(location, toCoordinateFrom: self)
            // set value
            onLongPress(coordinate)
            // make sims api call
            makeAPICall(loc: coordinate)
        }
    }
    // required to have...
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}



extension WrappedMap {

    @objc func makeAPICall(loc: CLLocationCoordinate2D) {
    
    // user slected parameters
    let lat = loc.latitude      // latitude
    let lon = loc.longitude     // longitude
    
    let year = 2019             // input year
    let key = "jF6OLunIZm"     // sims api key
    
    // generated url for api query
    let url = URL(string: "http://sims.et/time_series?api_key=\(key)&start_date=\(year)-01-01&end_date=\(year)-12-31&interval=monthly&output_format=json&geometry=\(lon),\(lat)")!
    
    // 1
    let request = AF.request(url)
    // 2
    request.responseJSON { (data) in
        print(url)
        print(data)
        //nc.post(Notification(name: Notification.Name(rawValue: "makeAPICall"),object: data))
    }
  }
}




struct MapViewUIKit: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let mapType : MKMapType
    
    @State private var annotation = MKPointAnnotation()
    func makeUIView(context: Context) -> MKMapView {
        let mapView = WrappedMap()
        mapView.onLongPress = addAnnotation(for:)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
    
        mapView.mapType = mapType           // set map style
        mapView.showsScale = true           // display scale in
        mapView.isRotateEnabled = false     // disable rotate
        
        let center = CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795) // cenetr of usa
        let latMeters = CLLocationDistance(3_000_000)  // up-down
        let longMeters = CLLocationDistance(9_300_000) // left-right
        
        // set geometry
        let coordinateRegion = MKCoordinateRegion(
            center: center,
            latitudinalMeters: latMeters,
            longitudinalMeters: longMeters)
        
        // constrain camera boundry
        let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: coordinateRegion)
        mapView.setCameraBoundary(cameraBoundary, animated: true)
        
        // set min, max zoom levels
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 4000,
                                                            maxCenterCoordinateDistance: 19000000)
        
        // constrain map type
        MKMapView.appearance().mapType = .satellite
        mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0.0, bottom: -60.0, right: 0.0)    // hide logo
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }

    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        
        newAnnotation.coordinate = coordinate
        annotation = newAnnotation
    }
}


struct ContentView: View {
    
    // set initial location
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36, longitude: -119),
                                                   span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    // set initial map
    @State private var mapType: MKMapType = .satellite
    
    @State var showingDetail = false
    
    var body: some View {
        
        ZStack {
            // 3
            MapViewUIKit(region: region, mapType: mapType)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: 10)
                
                Button(action: {self.showingDetail.toggle()}) {
                            Text("Graph")
                            .underline(false)
                            .padding(8)
                            .background(Color.black)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .opacity(0.7)
                }.sheet(isPresented: $showingDetail) { GraphView() }
                
                Spacer()
                
                // add toggle for  map options
                Picker("", selection: $mapType) {
                    Text("Satellite").tag(MKMapType.satellite)
                    Text("Hybrid").tag(MKMapType.hybrid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .offset(y: 15)
                .font(.largeTitle)
                .padding()
            }
        }
    }
}
