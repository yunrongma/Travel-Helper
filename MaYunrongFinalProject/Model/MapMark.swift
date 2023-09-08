//
//  MapMark.swift
//  MaYunrongFinalProject
//
//  Created by Apple on 2023/4/28.
//

import Foundation
import GoogleMaps
import CoreLocation

struct TripLocation: Codable{
    var latitude: Double
    var longitude: Double
    
    init(){
        latitude = -1
        longitude = -1
    }
    init(latitude: Double,longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class TripMark: Codable {
    var tripId: Int
    var tripLocations: [TripLocation]
    
    init()
    {
        self.tripId = -1;
        self.tripLocations = [TripLocation]()
    }
}
