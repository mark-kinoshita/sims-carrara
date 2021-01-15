//
//  NetworkManager.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import Foundation
import MapKit

class NetworkManager: ObservableObject {
    
    var results = [Result]()
    var response = Response()
    
    
    func fetchLocationData(loc: CLLocationCoordinate2D) {
        print(loc)
        let lat = loc.latitude
        let lon = loc.longitude
        
        let year = 2019
        let key = "jF6OLunIZm"
        
        guard let url = URL(string: "http://sims.et/time_series?api_key=\(key)&start_date=\(year)-01-01&end_date=\(year)-12-31&interval=monthly&output_format=json&geometry=\(lon),\(lat)") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse
                    }
                    print(self.response)
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
    
}
