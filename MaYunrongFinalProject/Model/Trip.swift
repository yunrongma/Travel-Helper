//
//  Trip.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 3/31/23.
//

import Foundation
import CoreLocation
import UIKit

struct Trip: Codable {
    
    // private var properties of type String
    private var place: String
    private var date: String
    private var description: String
    
    // retrive location
    func getPlace() -> String {
        return place
    }
    // retrieve date
    func getDate() -> String {
        return date
    }
    // retrieve description
    func getDescription() -> String {
        return description
    }
    
    // initializer
    init(place: String, date: String, description: String) {
        self.date = date
        self.place = place
        self.description = description
    }
    
}
