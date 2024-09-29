//
//  SocialArtTests.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 14.10.2023.
//

import XCTest
@testable import SocialArt
import CoreLocation

final class MapViewModelTests: XCTestCase {
    var viewModel: MapViewModel! // The class I tested
    var view: MockMapView!

    // The mock of the protocol that allows us to perform the test should be given.
    var locationManager: MockLocationManager!
    var avManager: MockAVFoundationManager!
    var main: MockDispatchQueue!

    override func setUp() {
        super.setUp()
        locationManager = .init()
        avManager = .init()
        main = .init()

        viewModel = MapViewModel(locationManager: locationManager,
                                 avManager: avManager,
                                 main: main)
        view = MockMapView()
        viewModel.view = view
    }
    
    override func tearDown() {
        main = nil
        avManager = nil
        locationManager = nil
        view = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_capturedLocationNotExist_invokesSetMapView() {
        //given
        //prepareMapView is not called
        //setupUserTrackingButton is not called
        //prepareRegion is not called
        XCTAssertFalse(locationManager.isCaptureLocationGetterCalled)
        XCTAssertFalse(view.isPrepareMapViewCalled)
        XCTAssertFalse(view.isSetupUserTrackingButtonCalled)
        XCTAssertFalse(view.isPrepareRegionCalled)
        XCTAssertNil(view.prepareRegionCalledWithValue)
        
        //when
        viewModel.viewDidLoad()
        
        //then
        //prepareMapView is called
        //setupUserTrackingButton is called
        //prepareRegion is not called
        XCTAssertTrue(locationManager.isCaptureLocationGetterCalled)
        XCTAssertTrue(view.isPrepareMapViewCalled)
        XCTAssertTrue(view.isSetupUserTrackingButtonCalled)
        XCTAssertFalse(view.isPrepareRegionCalled)
        XCTAssertNil(view.prepareRegionCalledWithValue)
    }
    
    func test_viewDidLoad_withCapturedLocationExist_invokesSetMapViewAndLocationRegion() {
        //given
        //prepareMapView is not called
        //setupUserTrackingButton is not called
        //prepareRegion is not called
        XCTAssertFalse(locationManager.isCaptureLocationGetterCalled)
        XCTAssertNil(locationManager.capturedLocation)
        XCTAssertFalse(view.isPrepareMapViewCalled)
        XCTAssertFalse(view.isSetupUserTrackingButtonCalled)
        XCTAssertFalse(view.isPrepareRegionCalled)
        XCTAssertNil(view.prepareRegionCalledWithValue)
        
        //when
        locationManager.stubbedCaptureLocation = .init(latitude: 12, longitude: 13)
        viewModel.viewDidLoad()
        
        //then
        //prepareMapView is called
        //setupUserTrackingButton is called
        //prepareRegion is called
        XCTAssertNotNil(locationManager.capturedLocation)
        XCTAssertTrue(locationManager.isCaptureLocationGetterCalled)
        XCTAssertTrue(view.isPrepareMapViewCalled)
        XCTAssertTrue(view.isSetupUserTrackingButtonCalled)
        XCTAssertTrue(view.isPrepareRegionCalled)
        XCTAssertEqual(view.prepareRegionCalledWithValue?.center.latitude, 12)
        XCTAssertEqual(view.prepareRegionCalledWithValue?.center.longitude, 13)
        XCTAssertEqual(view.prepareRegionCalledWithValue?.span.longitudeDelta, 0.1)
        XCTAssertEqual(view.prepareRegionCalledWithValue?.span.latitudeDelta, 0.1)
    }
    
    func test_viewWillAppear_invokesPrepareTabBar() {
        //given
        //prepareTabBar is not called
        XCTAssertFalse(view.isPrepareTabBarCalled)
        
        //when
        viewModel.viewWillAppear()
        
        //then
        //prepareTabBar is called
        XCTAssertTrue(view.isPrepareTabBarCalled)
    }
    
    func test_addPin_invokesAddPin() {
        //given
        //add annotation is not called
        //select annotation is not called
        XCTAssertFalse(view.isAddAnnotationCalled)
        XCTAssertFalse(view.isSelectAnnotationCalled)

        //when
        avManager.stubbedCapturedImage = UIImage(systemName: "car")
        locationManager.stubbedCaptureLocation = .init(latitude: 14, longitude: 15)
        viewModel.addPin(using: avManager.stubbedCapturedImage ?? UIImage(), locationManager.stubbedCaptureLocation ?? CLLocation())

        //then
        //add annotation  called
        //select annotation called
        XCTAssertTrue(view.isAddAnnotationCalled)
        XCTAssertTrue(view.isSelectAnnotationCalled)
        XCTAssertEqual(view.isAddAnnotationCalledWithValue?.coordinate.latitude, 14)
        XCTAssertEqual(view.isAddAnnotationCalledWithValue?.coordinate.longitude, 15)
        XCTAssertEqual(view.isSelectAnnotationCalledWithValue?.coordinate.latitude, 14)
        XCTAssertEqual(view.isSelectAnnotationCalledWithValue?.coordinate.longitude, 15)
    }
}
