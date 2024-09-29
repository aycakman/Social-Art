//
//  MockCameraView.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 1.11.2023.
//

import UIKit
import AVFoundation
@testable import SocialArt

final class MockCameraView: CameraViewInterface {
    var tabBar: SocialArt.TabBarControllerInterface?
    
    var isPrepareViewCalled = false
    func prepareView() {
        isPrepareViewCalled = true
    }
    
    var isPrepareTabBarCalled = false
    func prepareTabBar() {
        isPrepareTabBarCalled = true
    }
    
    var isDismissViewCalled = false
    func dismissView() {
        isDismissViewCalled = true
    }
    
    var isPrepareUICalled = false
    func prepareUI() {
        isPrepareUICalled = true
    }
    
    var isAddSublayerCalled = false
    var isAddSublayerCalledWithValue: AVCaptureVideoPreviewLayer?
    func addSublayer(_ cameralayer: AVCaptureVideoPreviewLayer) {
        isAddSublayerCalled = true
        isAddSublayerCalledWithValue = cameralayer
    }
    
    var isAddSubviewsCalled = false
    var isAddSubviewsCalledWithValue: UIImage?
    func addSubviews(_ previewImage: UIImage?) {
        isAddSubviewsCalled = true
        isAddSubviewsCalledWithValue = previewImage
    }
    
    var isShowAlertCalled = false
    var isShowAlertCalledWithTitleValue: String?
    var isShowAlertCalledWithMessageValue: String?
    var isShowAlertCalledWithOkAction: (() -> Void)?
    func showAlert(title: String, message: String, okAction: @escaping () -> Void) {
        isShowAlertCalled = true
        isShowAlertCalledWithTitleValue = title
        isShowAlertCalledWithMessageValue = message
        isShowAlertCalledWithOkAction = okAction
    }
}
