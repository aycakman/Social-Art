//
//  LocationManagerTests.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 20.11.2023.
//

@testable import SocialArt
import XCTest
import CoreLocation

final class LocationManagerTests: XCTestCase {
    
    var locationManager: LocationManager! // The class I tested
    var clManager: MockCLLocationManagerProtocol! // The mock of the protocol that allows us to perform the test should be given.

    override func setUp() {
        super.setUp()
        clManager = .init()
        locationManager = LocationManager(clManager: clManager)
    }
    
    override func tearDown() {
        locationManager = nil
        clManager = nil
        super.tearDown()
    }
    
    func test_didUpdateLocations_invokesCapturedLocation() {
        //given
        XCTAssertNil(locationManager.capturedLocation)
        
        //when
        locationManager.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation(latitude: 12, longitude: 12)])
        
        //then
        XCTAssertEqual(locationManager.capturedLocation?.coordinate.latitude, 12)
        XCTAssertEqual(locationManager.capturedLocation?.coordinate.longitude, 12)
    }
    
    func test_getCurrentLocation_invokesRequestLocation() {
        clManager = .init() // The initialization call overrides and resets the setup functions
        //given
        XCTAssertFalse(clManager.invokedDelegateSetter)
        XCTAssertEqual(clManager.invokedDelegateSetterCount, 0)
        XCTAssertFalse(clManager.invokedDesiredAccuracySetter)
        XCTAssertEqual(clManager.invokedDesiredAccuracySetterCount, 0)
        XCTAssertFalse(clManager.invokedRequestWhenInUseAuthorization)
        XCTAssertEqual(clManager.invokedRequestWhenInUseAuthorizationCount, 0)
        XCTAssertFalse(clManager.invokedRequestLocation)
        XCTAssertEqual(clManager.invokedRequestLocationCount, 0)

        //when
        locationManager = LocationManager(clManager: clManager)
        
        //then
        XCTAssertTrue(clManager.invokedDesiredAccuracySetter)
        XCTAssertEqual(clManager.invokedDesiredAccuracySetterCount, 1)
        XCTAssertTrue(clManager.invokedDelegateSetter)
        XCTAssertEqual(clManager.invokedDelegateSetterCount, 1)
        XCTAssertTrue(clManager.invokedRequestWhenInUseAuthorization)
        XCTAssertEqual(clManager.invokedRequestWhenInUseAuthorizationCount, 1)
        XCTAssertTrue(clManager.invokedRequestLocation)
        XCTAssertEqual(clManager.invokedRequestLocationCount, 1)
    }
}
