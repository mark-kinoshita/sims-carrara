//
//  GraphView.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import SwiftUI
import SwiftUICharts

struct GraphView: View {
        
    @State var ndvi: [Double] = (0..<12).map { _ in .random(in: 0...1) }
    @State var eto: [Double] = (0..<12).map { _ in .random(in: 0...0.5) }
    @State var kcb: [Double] = (0..<12).map { _ in .random(in: 0...1.5) }
    @State var etc: [Double] = (0..<12).map { _ in .random(in: 0...10) }
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Almond Timeseries")
                    .font(.title)
                    .padding()
                
                ScrollView(.vertical) {
                    VStack(spacing: 300) {
                        LineView(data: ndvi, legend: "                                      NDVI")
                    
                        LineView(data: eto, legend: "                                        ETo")
             
                        LineView(data: kcb, legend: "                                        Kcb")
                        
                        LineView(data: etc, legend: "                                        ETc")
        
                        Spacer()
                        
                    }.padding()
                }
            }
        }
    }
}
