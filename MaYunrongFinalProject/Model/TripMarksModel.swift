//
//  MapMarkModel.swift
//  MaYunrongFinalProject
//
//  Created by Apple on 2023/4/28.
//

import Foundation

// store locations and marks
class TripMarksModel {
    var markJson = [TripMark]()
   
    // singleton
    static let sharedInstance = TripMarksModel()
    
    let markFilePath: URL
    
    var currentTripId: Int = -1
    var curIndex: Int = -1
    
    init() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        markFilePath = URL(string: "\(documentsDirectory)/marksArray.json")!

        print("\(markFilePath)")
    }
    
    func getMarksArray(tripId: Int) -> [TripLocation] {

        var tripMarks = [TripLocation]()
       
        for mark in markJson[curIndex].tripLocations
        {
            tripMarks.append(mark)
        }
        
        return tripMarks
    }
    
    func removeMark(latitude: Double,longitude: Double){
        for index in 0 ..< markJson[curIndex].tripLocations.count {
            if(markJson[curIndex].tripLocations[index].latitude == latitude && markJson[curIndex].tripLocations[index].longitude == longitude)
            {
                markJson[curIndex].tripLocations.remove(at: index)
                save()
                break
            }
        }
    }
    
    func insertMark(latitude: Double,longitude: Double) {
        var flg = 0
        for location in markJson[curIndex].tripLocations
        {
            if(location.latitude == latitude && location.longitude == longitude)
            {
                flg = 1
                break
            }
        }
        if(flg == 0)
        {
            let location = TripLocation(latitude: latitude,longitude: longitude)
            markJson[curIndex].tripLocations.append(location)
            save()
        }
    }
    // Write -> saving to disk
    func save() {
        // Codable API
        // 1. Data you want to save needs to conform to "Codable" Protocol
        // 2. Use a custom encoder to encode to file system
//        let flg = 0
        
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(markJson)
            
            let jsonString = String(data: data, encoding: .utf8)!
            

            try jsonString.write(to: markFilePath, atomically: true, encoding: .utf8)
            

        } catch {
            print(error)
        }
    }

    // Read -> reading from disk
    func load() {
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: markFilePath)
            let decodedMarks = try decoder.decode(Array<TripMark>.self, from: data)

            markJson = decodedMarks
            
            var flg = 0
            for index in 0 ..< markJson.count {
                if(markJson[index].tripId == currentTripId)
                {
                    curIndex = index
                    flg = 1
                    break
                }
            }
            if(flg == 0)
            {
                let mark = TripMark()
                mark.tripId = currentTripId
                mark.tripLocations = []
                curIndex = markJson.count
                markJson.append(mark)
                
                print("add new mark trip \(currentTripId)")
            }
            
        } catch {
            let mark = TripMark()
            mark.tripId = currentTripId
            mark.tripLocations = []
            curIndex = 0
            markJson.append(mark)
            print("load error,create new array:\(error)")
        }

    }
}
