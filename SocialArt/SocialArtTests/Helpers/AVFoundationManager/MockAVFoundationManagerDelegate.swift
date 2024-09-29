//
//  MockAVFoundationManagerDelegate.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 8.12.2023.
//

@testable import SocialArt
import UIKit

final class MockAVFoundationManagerDelegate: AVFoundationManagerDelegate {

    var invokedParentViewGetter = false
    var invokedParentViewGetterCount = 0
    var stubbedParentView: UIViewController!

    var parentView: UIViewController? {
        invokedParentViewGetter = true
        invokedParentViewGetterCount += 1
        return stubbedParentView
    }

    var invokedDidFinishProcessingPhoto = false
    var invokedDidFinishProcessingPhotoCount = 0
    var invokedDidFinishProcessingPhotoParameters: (image: UIImage, Void)?
    var invokedDidFinishProcessingPhotoParametersList = [(image: UIImage, Void)]()

    func didFinishProcessingPhoto(image: UIImage) {
        invokedDidFinishProcessingPhoto = true
        invokedDidFinishProcessingPhotoCount += 1
        invokedDidFinishProcessingPhotoParameters = (image, ())
        invokedDidFinishProcessingPhotoParametersList.append((image, ()))
    }

    var invokedCameraPermissionDenied = false
    var invokedCameraPermissionDeniedCount = 0

    func cameraPermissionDenied() {
        invokedCameraPermissionDenied = true
        invokedCameraPermissionDeniedCount += 1
    }

    var invokedPrepareCaptureSessionCompleted = false
    var invokedPrepareCaptureSessionCompletedCount = 0

    func prepareCaptureSessionCompleted() {
        invokedPrepareCaptureSessionCompleted = true
        invokedPrepareCaptureSessionCompletedCount += 1
    }
}
