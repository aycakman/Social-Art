//
//  MockAVManager.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 1.11.2023.
//

@testable import SocialArt
import UIKit
import CoreLocation

final class MockAVFoundationManager: AVFoundationManagerInterface {
    
    var stubbedDelegate: AVFoundationManagerDelegate?
    
    var stubbedCapturedImage: UIImage?
    var isCaptureImageGetterCalled = false
    var capturedImage: UIImage? {
        isCaptureImageGetterCalled = true
        return stubbedCapturedImage
    }
    
    var isOpenCameraCalled = false
    func openCamera() {
        isOpenCameraCalled = true
    }
    
    var isHandleTakePhotoCalled = false
    func handleTakePhoto() {
        isHandleTakePhotoCalled = true
    }
    
    var isHandleSwitchCameraButtonTappedCalled = false
    func handleSwitchCameraButtonTapped() {
        isHandleSwitchCameraButtonTappedCalled = true
    }
}
