//
//  TripModel.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/1/23.
//

import Foundation
import UIKit

class TripsModel {
    // array containing Trip objects
    private var tripsArray: [Trip]
    
    // keep track of current trip
    private var tripId: Int?
    
    // singleton
    static let sharedInstance = TripsModel()
    
    let tripsFilePath: URL
    
    init() {
        self.tripsArray = []
        
        self.tripsArray.append(Trip(place: "New Place", date: "MM/dd/yyyy", description: "New Description"))
        
        // Initialize the currentIndex to 0
        self.tripId = 0
        
        // add data persistence by saving a json file to app’s Documents folder containing all of the model’s data
        // Finder -> command-shift-g -> enter flashcardsFilePath
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        tripsFilePath = URL(string: "\(documentsDirectory)/tripsArray.json")!

        print("\(tripsFilePath)")
        
        load()
        
    }
    
    // Return number of trips in model
    func numberOfTrips() -> Int {
        return tripsArray.count
    }
    
    // Returns a trip at a given index
    func getTrip(at index: Int) -> Trip? {
        if (index < numberOfTrips() && index >= 0) {
            return tripsArray[index]
        }
        return nil
    }
    
    // 
    
    // Insert
    func insertTrip(place: String, date: String, description: String, at index: Int) {
        
        if (index >= 0 && index < numberOfTrips()) {
            tripsArray.insert(Trip(place: place, date: date, description: description), at: index);
            
            // Inserting at index before or at currentIndex should increment currentIndex
            if (tripId != nil && index <= tripId!) {
                tripId! += 1;
            }
        }
        
        else if (index == numberOfTrips() || tripsArray.isEmpty || tripId == nil) {
            tripsArray.append(Trip(place: place, date: date, description: description))
            tripId = 0;
        }
        
        save()
    
    }
    
    // Remove
    func removeTrip(at index: Int) {

        if (numberOfTrips() == 0) {
            tripId = nil;
        }
        
        else {
            if (index >= 0 && index < numberOfTrips()) {
                tripsArray.remove(at: index);
                
                // no cards left after remove
                if (numberOfTrips() == 0) {
                    tripId = nil;
                }
                
                // if removing before currentIndex,
                // or if the currentIndex is the index of the last card and it is deleted,
                // both should decrement currentIndex
                else if ((index < tripId!) || (index == tripId! && tripId! == numberOfTrips()-1)) {
                    tripId! -= 1;
                }
            }
        }
        
        save()
    }
    
    // rearrange
    func rearrageTrips(from: Int, to: Int) {
        var place: String!
        var date: String!
        var description: String!
        
        if numberOfTrips() != 0 {
            if from >= 0 && from < numberOfTrips() {
                place = tripsArray[from].getPlace()
                date = tripsArray[from].getDate()
                description = tripsArray[from].getDescription()
            }
            
            else if from == numberOfTrips() {
                place = tripsArray[from].getPlace()
                date = tripsArray[from-1].getDate()
                description = tripsArray[from-1].getDescription()
            }
            
            removeTrip(at: from)
            insertTrip(place: place, date: date, description: description, at: to)
        }
        
        save()
    }
    
    // check if the trip has already been entered
    func checkEnteredTrips(potentialDate: String, potentialPlace: String) -> Bool {
        for trip in tripsArray {
            let date: String = trip.getDate().lowercased()
            let place: String = trip.getPlace().lowercased()
            if date == potentialDate.lowercased() && place == potentialPlace.lowercased() {
                return true;
            }
        }
        return false;
    }
    
    
    // Write -> saving to disk
    func save() {
        // Codable API
        // 1. Data you want to save needs to conform to "Codable" Protocol
        // 2. Use a custom encoder to encode to file system
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(tripsArray)

            let jsonString = String(data: data, encoding: .utf8)!

            try jsonString.write(to: tripsFilePath, atomically: true, encoding: .utf8)

        } catch {
            print(error)
        }
    }

    // Read -> reading from disk
    func load() {
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: tripsFilePath)
            let decodedTrips = try decoder.decode(Array<Trip>.self, from: data)

            tripsArray = decodedTrips
        } catch {
            print(error)
        }

    }
    
    
}
