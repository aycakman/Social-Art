//
//  MockAVCapturePhotoOutput.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 5.12.2023.
//

import UIKit
import AVFoundation
@testable import SocialArt

final class MockAVCapturePhotoOutput: AVCapturePhotoOutputProtocol {
    
    var invokedCapturePhoto = false
    var invokedCapturePhotoCount = 0
    var invokedCapturePhotoParameters: (settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)?
    var invokedCapturePhotoParametersList = [(settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)]()

    func capturePhoto(with settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        invokedCapturePhoto = true
        invokedCapturePhotoCount += 1
        invokedCapturePhotoParameters = (settings, delegate)
        invokedCapturePhotoParametersList.append((settings, delegate))
    }
}
