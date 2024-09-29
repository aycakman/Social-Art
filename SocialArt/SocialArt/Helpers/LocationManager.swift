//
//  LocationManager.swift
//  SocialArt
//
//  Created by Ayca Akman on 21.10.2023.
//

import CoreLocation

protocol LocationManagerInterface {
    var capturedLocation: CLLocation? { get }
}

protocol CLLocationManagerProtocol {
    var desiredAccuracy: CLLocationAccuracy { get set }
    var delegate: CLLocationManagerDelegate? { get set }
    
    func requestWhenInUseAuthorization()
    func requestLocation()
}

final class LocationManager: NSObject {

    static let shared: LocationManagerInterface = LocationManager()

    var clManager: CLLocationManagerProtocol
    var capturedLocation: CLLocation?
    
    init(clManager: CLLocationManagerProtocol = CLLocationManager()) {
        self.clManager = clManager
        super.init()
        self.clManager.desiredAccuracy = kCLLocationAccuracyBest
        self.clManager.delegate = self
        getCurrentLocation()
    }
    
    private func getCurrentLocation() {
        clManager.requestWhenInUseAuthorization()
        clManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        capturedLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - LocationManagerInterface
extension LocationManager: LocationManagerInterface {}

extension CLLocationManager: CLLocationManagerProtocol {}
