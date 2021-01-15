//
//  Response.swift
//  sims (iOS)
//
//  Created by Mark Kinoshita on 1/11/21.
//

import Foundation

struct Response: Codable {
    var results: [Result]?
}

struct Result: Codable {
    var time: String
    var ndvi: Double?
    var eto: Double?
    var kcb: Double?
    var etc: Double?
}
