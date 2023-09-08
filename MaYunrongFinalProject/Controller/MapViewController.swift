//
//  MapViewController.swift
//  MaYunrongFinalProject
//
//  Created by Apple on 2023/4/18.
//


import Foundation

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

struct MyLocations{
    var pos: CLLocationCoordinate2D
    var markData: Date? //MM-dd-yyyy HH:mm
    var title: String?
    init(pos: CLLocationCoordinate2D, markData: Date? = nil, title: String? = nil)
    {
        self.pos = pos
        self.markData = markData
        self.title = title
    }
}


class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var addMark: UIButton!
    @IBOutlet weak var delMark: UIButton!
    
    @IBOutlet weak var zoomOut: UIButton!
    @IBOutlet weak var zoomIn: UIButton!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    var addButtonStatus = 0
    var delButtonStatus = 0;
    var myMark: [MyLocations] = []
    var polyLines: GMSPolyline!
    
    var tripMarksModel = TripMarksModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMark.backgroundColor = UIColor.green
        delMark.backgroundColor = UIColor.green
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        
        // Create a map
        // Create a GMSCameraPosition object that specifies the center and zoom level of the map
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        // Create and instantiate a GMSMapView class using the GMSMapView mapWithFrame: method.
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        mapView.delegate = self
        //  self.view = mapView
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
        
        mapView.addSubview(self.addMark)
        
        mapView.addSubview(self.delMark)
        
        mapView.addSubview(self.zoomOut)
        mapView.addSubview(self.zoomIn)
        
      
        self.tripMarksModel.load()
        myMark = [MyLocations]()
        let marksArray = self.tripMarksModel.getMarksArray(tripId: self.tripMarksModel.currentTripId)
        for mark in marksArray
        {
            AddMarker(title: "test", snippet: "test", latitude: mark.latitude, longitude: mark.longitude)
        }
    }
    
    @IBAction func ZoomInTapped(_ sender: UIButton) {
        guard let mapView = self.mapView
        else {
            print("Set mapView variable")
            return
        }
        let zoomOutValue = mapView.camera.zoom + 1.0
        mapView.animate(toZoom: zoomOutValue)
    }
    
    
    @IBAction func zoomOutTapped(_ sender: UIButton) {
        guard let mapView = self.mapView
        else {
            print("Set mapView variable")
            return
        }
        // Change the current zoom level by 1.0
        let zoomInValue = mapView.camera.zoom - 1.0
        mapView.animate(toZoom: zoomInValue)
    }
    
    @IBAction func addButtonDidTapped(_ sender: UIButton) {
        if(addButtonStatus == 0)
        {
            addButtonStatus = 1
            addMark.backgroundColor = UIColor.lightGray
            
        }
        else
        {
            addButtonStatus = 0
            addMark.backgroundColor = UIColor.green
        }
        if(delButtonStatus == 1)
        {
            delButtonStatus = 0;
            delMark.backgroundColor = UIColor.green
        }
        
    }
    
    @IBAction func deleteButtonDidTapped(_ sender: UIButton) {
        if(delButtonStatus == 0)
        {
            delButtonStatus = 1
            delMark.backgroundColor = UIColor.lightGray
            
        }
        else
        {
            delButtonStatus = 0
            delMark.backgroundColor = UIColor.green
        }
        
        if(addButtonStatus == 1)
        {
            addButtonStatus = 0;
            addMark.backgroundColor = UIColor.green
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        if(addButtonStatus == 0)
        {
            return
        }
        
        AddMarker(title: "test", snippet: "test", latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        self.tripMarksModel.insertMark(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        if(addButtonStatus == 1)
        {
            addButtonStatus = 0
            addMark.backgroundColor = UIColor.green
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool{
        if(delButtonStatus == 0)
        {
            return true
        }
        
        for i in 0...myMark.count
        {
            if myMark[i].pos.latitude == marker.position.latitude
                && myMark[i].pos.longitude == marker.position.longitude
            {
                myMark.remove(at: i)
                marker.map = nil
                self.tripMarksModel.removeMark(latitude: marker.position.latitude, longitude: marker.position.longitude)
                break
            }
        }
        RemoveLines()
        DrawLines()
        
        self.tripMarksModel.removeMark(latitude: marker.position.latitude, longitude: marker.position.longitude)
        if(delButtonStatus == 1)
        {
            delButtonStatus = 0
            delMark.backgroundColor = UIColor.green
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        if(addButtonStatus == 0)
        {
            return
        }
        
        AddMarker(title: placeID, snippet: name, latitude: location.latitude, longitude: location.longitude)
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        if(addButtonStatus == 1)
        {
            addButtonStatus = 0
            addMark.backgroundColor = UIColor.green
        }
    }
    private func RemoveLines()
    {
        if polyLines != nil
        {
            polyLines.map = nil
        }
        
    }
    private func DrawLines()
    {
        if polyLines != nil
        {
            polyLines.map = nil
        }
        let rectanglePath = GMSMutablePath()
        for _mark in myMark
        {
            rectanglePath.add(_mark.pos)
        }
        
        polyLines = GMSPolyline(path: rectanglePath)
        polyLines.strokeWidth = 8.0
        polyLines.strokeColor = UIColor.blue
        polyLines.geodesic = true
        polyLines.map = mapView
        
    }
    
    private func AddMarker(title:String , snippet:String  , latitude:Double , longitude:Double){
        
        var bounds =  GMSCoordinateBounds()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
        bounds = bounds.includingCoordinate(marker.position)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: update)
        
        let myLocation = MyLocations(pos: marker.position)
        myMark.append(myLocation)
        
        DrawLines()
        
        
    }
}

// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
    
    // Handle incoming location events.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
//        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: mapView.camera.zoom)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
}
