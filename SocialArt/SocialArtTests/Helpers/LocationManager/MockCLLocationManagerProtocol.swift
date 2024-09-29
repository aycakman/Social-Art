//
//  MockCLLocationManager.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 23.11.2023.
//

@testable import SocialArt
import CoreLocation

final class MockCLLocationManagerProtocol: CLLocationManagerProtocol {

    var invokedDesiredAccuracySetter = false
    var invokedDesiredAccuracySetterCount = 0
    var invokedDesiredAccuracy: CLLocationAccuracy?
    var invokedDesiredAccuracyList = [CLLocationAccuracy]()
    var invokedDesiredAccuracyGetter = false
    var invokedDesiredAccuracyGetterCount = 0
    var stubbedDesiredAccuracy: CLLocationAccuracy!

    var desiredAccuracy: CLLocationAccuracy {
        set {
            invokedDesiredAccuracySetter = true
            invokedDesiredAccuracySetterCount += 1
            invokedDesiredAccuracy = newValue
            invokedDesiredAccuracyList.append(newValue)
        }
        get {
            invokedDesiredAccuracyGetter = true
            invokedDesiredAccuracyGetterCount += 1
            return stubbedDesiredAccuracy
        }
    }

    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: CLLocationManagerDelegate?
    var invokedDelegateList = [CLLocationManagerDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: CLLocationManagerDelegate!  // ! unwrap *

    var delegate: CLLocationManagerDelegate? {
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
    }

    var invokedRequestWhenInUseAuthorization = false
    var invokedRequestWhenInUseAuthorizationCount = 0

    func requestWhenInUseAuthorization() {
        invokedRequestWhenInUseAuthorization = true
        invokedRequestWhenInUseAuthorizationCount += 1
    }

    var invokedRequestLocation = false
    var invokedRequestLocationCount = 0

    func requestLocation() {
        invokedRequestLocation = true
        invokedRequestLocationCount += 1
    }
}
