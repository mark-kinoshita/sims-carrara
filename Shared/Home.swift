//
//  Home.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                NavigationLink(destination: DataExplorer(showGraph: false)) {
                    ScreenCard(label: "Data Explorer", reversed: true)
                        .shadow(radius: 5)
                }
                NavigationLink(destination: About()) {
                    ScreenCard(label: "About", reversed: false)
                        .shadow(radius: 5)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
