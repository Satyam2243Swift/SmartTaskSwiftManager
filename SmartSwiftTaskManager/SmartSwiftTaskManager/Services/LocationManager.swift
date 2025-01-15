//
//  LocationManager.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//

import Foundation
import CoreLocation
import UIKit

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

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCompletion?(locations.last)
        locationManager.stopUpdatingLocation()
    }

    func fetchCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        locationCompletion = completion
        
        // Check authorization status
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Request permission and start updating location
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            // Inform the user to enable location services
            locationCompletion?(nil)
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Start updating location if permission is granted
            locationManager.startUpdatingLocation()
            
        @unknown default:
            // Handle unexpected cases
            print("Unknown authorization status.")
            locationCompletion?(nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied by user.")
                // Inform user to enable location services
            case .locationUnknown:
                print("Location currently unknown. Retrying...")
                // Retry after some delay (optional)
            case .network:
                print("Network error. Check your connection.")
            default:
                print("Unhandled error: \(clError.localizedDescription)")
            }
        } else {
            print("Unexpected error: \(error.localizedDescription)")
        }
        locationCompletion?(nil)
    }
}
