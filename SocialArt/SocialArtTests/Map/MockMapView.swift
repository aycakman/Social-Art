//
//  MockMapView.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 28.10.2023.
//

import MapKit
@testable import SocialArt

final class MockMapView: MapViewInterface {
    var isPrepareMapViewCalled = false
    func prepareMapView() {
        isPrepareMapViewCalled = true
    }
    
    var isSetupUserTrackingButtonCalled = false
    func setupUserTrackingButton() {
        isSetupUserTrackingButtonCalled = true
    }
    
    var isPrepareTabBarCalled = false
    func prepareTabBar() {
        isPrepareTabBarCalled = true
    }
    
    var isAddAnnotationCalled = false
    var isAddAnnotationCalledWithValue: CustomAnnotation?
    func addAnnotation(using pin: CustomAnnotation) {
        isAddAnnotationCalled = true
        isAddAnnotationCalledWithValue = pin
    }
    
    var isSelectAnnotationCalled = false
    var isSelectAnnotationCalledWithValue: CustomAnnotation?
    func selectAnnotation(using pin: CustomAnnotation) {
        isSelectAnnotationCalled = true
        isSelectAnnotationCalledWithValue = pin
    }
    
    var isPrepareRegionCalled = false
    var prepareRegionCalledWithValue: MKCoordinateRegion?
    func prepareRegion(_ region: MKCoordinateRegion) {
        isPrepareRegionCalled = true
        prepareRegionCalledWithValue = region
    }
}
