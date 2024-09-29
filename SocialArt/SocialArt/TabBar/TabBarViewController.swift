//
//  TabBarViewController.swift
//  SocialArt
//
//  Created by Ayca Akman on 15.10.2023.
//

import UIKit
import CoreLocation
import AVFoundation

protocol TabBarControllerInterface: AlertPresentable {
    func addPinToMapView(image: UIImage, location: CLLocation)
}

final class TabBarViewController: UITabBarController {
    let photoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    let global: DispatchQueueInterface = DispatchQueue.global()
    let main: DispatchQueueInterface = DispatchQueue.main

    private lazy var cameraViewControlller: CameraViewController = {
        let avFoundationManager = AVFoundationManager(photoOutput: photoOutput,
                                                      captureSession: captureSession,
                                                      global: global)
        let viewModel = CameraViewModel(avManager: avFoundationManager,
                                        locationManager: LocationManager.shared,
                                        main: DispatchQueue.main)
        let vc = CameraViewController(viewModel: viewModel)
        avFoundationManager.delegate = vc
        viewModel.view = vc
        let item = UITabBarItem(title: nil, image:  UIImage(systemName: "camera.fill"), tag: 0)
        vc.tabBarItem = item
        return vc
    }()

    private lazy var mapViewController: MapViewController = {
        let avFoundationManager = AVFoundationManager(photoOutput: photoOutput,
                                                      captureSession: captureSession,
                                                      global: global)
        let viewModel = MapViewModel(locationManager: LocationManager.shared,
                                     avManager: avFoundationManager,
                                     main: main)
        let vc = MapViewController(viewModel: viewModel)
        viewModel.view = vc
        let item = UITabBarItem(title: nil, image: UIImage(systemName: "map.fill"), tag: 1)
        vc.tabBarItem = item
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.viewControllers = [cameraViewControlller, mapViewController]

        setupSwipeGestures()
    }

    private func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc 
    private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            if selectedIndex < (viewControllers?.count ?? 1) - 1 {
                selectedIndex += 1
                UIView.transition(with: view, duration: 0.3, options: .transitionFlipFromRight, animations: nil)
            }
        default:
            break
        }
    }
}

extension TabBarViewController: TabBarControllerInterface {
    func addPinToMapView(image: UIImage, location: CLLocation) {
        mapViewController.addPin(using: image, location)
        selectedIndex = 1
    }
}
