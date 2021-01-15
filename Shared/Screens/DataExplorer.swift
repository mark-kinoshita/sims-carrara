//
//  DataExplore.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import SwiftUI
import MapKit

struct DataExplorer: View {
 
    @State private var mapType: MKMapType = .satellite
    @State var showGraph: Bool
    var body: some View {
        ZStack {
            MapView(showGraph: $showGraph, mapType: mapType)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Picker("", selection: $mapType) {
                    Text("Satellite").tag(MKMapType.satellite)
                    Text("Hybrid").tag(MKMapType.hybrid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .offset(y: 15)
                .font(.largeTitle)
                .padding()
            }.sheet(isPresented: $showGraph) { GraphView() }

        }
    }
}

