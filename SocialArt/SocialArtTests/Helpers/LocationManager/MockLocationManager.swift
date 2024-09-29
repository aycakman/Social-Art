//
//  MockLocationManager.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 28.10.2023.
//

@testable import SocialArt
import CoreLocation

final class MockLocationManager: LocationManagerInterface {
    
    var isCaptureLocationGetterCalled = false
    var stubbedCaptureLocation: CLLocation?
    
    var capturedLocation: CLLocation? {
        isCaptureLocationGetterCalled = true
        return stubbedCaptureLocation
    }
}
