//
//  CameraViewModel.swift
//  SocialArt
//
//  Created by Ayca Akman on 24.10.2023.
//

import Foundation

protocol CameraViewModelInterface: PhotoPreviewDelegate {
    var view: CameraViewInterface? { get set }
    var previewDelegate: PhotoPreviewDelegate? { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func openCamera()
    func handleCancelButtonTapped()
    func handleTakePhoto()
    func handleSwitchCameraButtonTapped()
    func handleCameraPermissionDenied()
    func prepareCaptureSessionCompleted()
}

final class CameraViewModel {

    weak var view: CameraViewInterface?
    
    private let locationManager: LocationManagerInterface
    private let avManager: AVFoundationManagerInterface
    private let main: DispatchQueueInterface
    
    init(avManager: AVFoundationManagerInterface,
         locationManager: LocationManagerInterface,
         main: DispatchQueueInterface) {
        self.avManager = avManager
        self.locationManager = locationManager
        self.main = main
    }
}

//MARK: - CameraViewModelInterface
extension CameraViewModel: CameraViewModelInterface {
    var previewDelegate: PhotoPreviewDelegate? { self }
    
    func viewDidLoad() {
        view?.prepareView()
    }
    
    func viewWillAppear() {
        view?.prepareTabBar()
    }
    
    func openCamera() {
        avManager.openCamera()
    }
    
    func handleCancelButtonTapped() {
        main.async {
            self.view?.dismissView()
        }
    }
    
    func handleTakePhoto() {
        avManager.handleTakePhoto()
    }
    
    func handleSwitchCameraButtonTapped() {
        avManager.handleSwitchCameraButtonTapped()
    }

    func handleCameraPermissionDenied() {
        view?.showAlert(title: "Warning", message: "You should give permission to take photo.", okAction: {
            self.view?.dismissView()
        })
    }

    func prepareCaptureSessionCompleted() {
        view?.prepareUI()
    }
}

extension CameraViewModel: PhotoPreviewDelegate {
    func didTapNextButton() {
        guard let capturedImage = avManager.capturedImage,
              let location = locationManager.capturedLocation else { return }
        
        view?.showAlert(title: "Art Page", message: "Would you like to see the picture you took on the map?", okAction: {
            self.view?.tabBar?.addPinToMapView(image: capturedImage,
                                               location: location)
        })
    }
}
