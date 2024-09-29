//
//  MapViewModel.swift
//  SocialArt
//
//  Created by Ayca Akman on 28.10.2023.
//

import UIKit
import struct MapKit.MKCoordinateRegion
import struct MapKit.MKCoordinateSpan
import CoreLocation

protocol MapViewModelInterface {
    var view: MapViewInterface? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func addPin(using image: UIImage, _ location: CLLocation)
}

final class MapViewModel {

    weak var view: MapViewInterface?

    private let locationManager: LocationManagerInterface
    private let avManager: AVFoundationManagerInterface
    private let main: DispatchQueueInterface

    init(locationManager: LocationManagerInterface,
         avManager: AVFoundationManagerInterface,
         main: DispatchQueueInterface) {
        self.locationManager = locationManager
        self.avManager = avManager
        self.main = main
    }
}

//MARK: - MapViewModelInterface
extension MapViewModel: MapViewModelInterface {
    func viewDidLoad() {
        view?.prepareMapView()
        view?.setupUserTrackingButton()
       
        guard let location = locationManager.capturedLocation else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        view?.prepareRegion(region)
    }
    
    func viewWillAppear() {
        view?.prepareTabBar()
    }
    
    func addPin(using image: UIImage, _ location: CLLocation) {
        let imageSize = CGSize(width: 40, height: 40)
        let resizedImage = image.resized(to: imageSize)
        let pin = CustomAnnotation(coordinate: location.coordinate, title: nil, image: resizedImage)

        main.async {
            self.view?.addAnnotation(using: pin)
            self.view?.selectAnnotation(using: pin)
        }
    }
}
