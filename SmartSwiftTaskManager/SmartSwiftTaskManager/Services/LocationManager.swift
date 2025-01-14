//
//  LocationManager.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func fetchCurrentLocation(completion: @escaping (CLLocation?) -> Void)
}

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func fetchCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        locationCompletion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCompletion?(locations.last)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(nil)
    }
}
