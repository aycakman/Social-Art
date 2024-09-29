//
//  MapViewController.swift
//  SocialArt
//
//  Created by Ayca Akman on 15.10.2023.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewInterface: AnyObject {
    func prepareMapView()
    func setupUserTrackingButton()
    func prepareTabBar()
    func addAnnotation(using pin: CustomAnnotation)
    func selectAnnotation(using pin: CustomAnnotation)
    func prepareRegion(_ region: MKCoordinateRegion)
}

final class MapViewController: UIViewController {

    private let viewModel: MapViewModelInterface
    
    init(viewModel: MapViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    func addPin(using image: UIImage, _ location: CLLocation) {
        viewModel.addPin(using: image, location)
    }
}

//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation {
            let annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: "customPin")
            annotationView.image = customAnnotation.image
            annotationView.canShowCallout = true
            return annotationView
        }

        return nil
    }
}

//MARK: - MapViewInterface
extension MapViewController: MapViewInterface {
    func prepareMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func setupUserTrackingButton() {
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.backgroundColor = .clear
        userTrackingButton.layer.borderColor = UIColor.lightGray.cgColor
        userTrackingButton.tintColor = .lightGray
        userTrackingButton.layer.borderWidth = 2
        userTrackingButton.layer.cornerRadius = 12
        userTrackingButton.clipsToBounds = true
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            userTrackingButton.widthAnchor.constraint(equalToConstant: 44),
            userTrackingButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func prepareTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
    
    func addAnnotation(using pin: CustomAnnotation) {
        mapView.addAnnotation(pin)
    }
    
    func selectAnnotation(using pin: CustomAnnotation) {
        mapView.selectAnnotation(pin, animated: true)
    }
    
    func prepareRegion(_ region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}
