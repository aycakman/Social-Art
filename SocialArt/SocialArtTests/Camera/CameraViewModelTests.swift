//
//  CameraViewModelTests.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 1.11.2023.
//

import XCTest
@testable import SocialArt

final class CameraViewModelTests: XCTestCase {
    
    var viewModel: CameraViewModel! // The class I tested
    var view: MockCameraView!

    // The mock of the protocol that allows us to perform the test should be given.
    var avManager: MockAVFoundationManager!
    var locationManager: MockLocationManager!
    var main: MockDispatchQueue!
    
    override func setUp() {
        super.setUp()        
        locationManager = .init()
        avManager = .init()
        main = .init()
        
        viewModel = CameraViewModel(avManager: avManager,
                                    locationManager: locationManager,
                                    main: main)
        view = MockCameraView()
        viewModel.view = view
    }
    
    override func tearDown() {
        avManager = nil
        locationManager = nil
        view = nil
        viewModel = nil
        main = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_invokesPrepareView() {
        //given
        XCTAssertFalse(view.isPrepareViewCalled)
        
        //when
        viewModel.viewDidLoad()
        
        //then
        XCTAssertTrue(view.isPrepareViewCalled)
    }
    
    func test_viewWillAppear_invokesPrepareTabBar() {
        //given
        XCTAssertFalse(view.isPrepareTabBarCalled)
        
        //when
        viewModel.viewWillAppear()
        
        //then
        XCTAssertTrue(view.isPrepareTabBarCalled)
    }
    
    func text_openCamera_invokesOpenCamera() {
        //given
        XCTAssertFalse(avManager.isOpenCameraCalled)

        //when
        viewModel.openCamera()
        
        //then
        XCTAssertTrue(avManager.isOpenCameraCalled)

    }

    func test_handleTakePhoto_invokesHandleTakePhotoMethod() {
        //given
        XCTAssertFalse(avManager.isHandleTakePhotoCalled)
        
        //when
        viewModel.handleTakePhoto()
        
        //then
        XCTAssertTrue(avManager.isHandleTakePhotoCalled)
    }
    
    func test_handleSwitchCameraButtonTapped_invokesHandleSwitchCameraButton() {
        //given
        XCTAssertFalse(avManager.isHandleSwitchCameraButtonTappedCalled)

        //when
        viewModel.handleSwitchCameraButtonTapped()
        
        //then
        XCTAssertTrue(avManager.isHandleSwitchCameraButtonTappedCalled)
    }
    
    func test_prepareCaptureSessionCompleted_invokesPrepareUI() {
        //given
        XCTAssertFalse(view.isPrepareUICalled)
        
        //when
        viewModel.prepareCaptureSessionCompleted()
        
        //then
        XCTAssertTrue(view.isPrepareUICalled)
    }
    
    func test_didTapNextButton_withCapturedImageAndCapturedLocationNotExist_invokesShowAlert() {
        //given
        XCTAssertFalse(avManager.isCaptureImageGetterCalled)
        XCTAssertNil(avManager.stubbedCapturedImage)
        XCTAssertFalse(locationManager.isCaptureLocationGetterCalled)
        XCTAssertNil(locationManager.capturedLocation)
        XCTAssertFalse(view.isShowAlertCalled)
        XCTAssertNil(view.isShowAlertCalledWithTitleValue)
        XCTAssertNil(view.isShowAlertCalledWithMessageValue)
        XCTAssertNil(view.isShowAlertCalledWithOkAction)
        
        //when
        viewModel.didTapNextButton()

        //then
        XCTAssertTrue(avManager.isCaptureImageGetterCalled)
        XCTAssertNil(avManager.stubbedCapturedImage)
        XCTAssertTrue(locationManager.isCaptureLocationGetterCalled)
        XCTAssertNil(locationManager.capturedLocation)
        XCTAssertFalse(view.isShowAlertCalled)
        XCTAssertNil(view.isShowAlertCalledWithTitleValue)
        XCTAssertNil(view.isShowAlertCalledWithMessageValue)
        XCTAssertNil(view.isShowAlertCalledWithOkAction)
    }

    func test_didTapNextButton_withCapturedImageAndCapturedLocationExist_invokesShowAlert() {
        //given
        XCTAssertFalse(avManager.isCaptureImageGetterCalled)
        XCTAssertFalse(locationManager.isCaptureLocationGetterCalled)
        XCTAssertFalse(view.isShowAlertCalled)
        XCTAssertNil(view.isShowAlertCalledWithTitleValue)
        XCTAssertNil(view.isShowAlertCalledWithMessageValue)
        XCTAssertNil(view.isShowAlertCalledWithOkAction)

        //when
        locationManager.stubbedCaptureLocation = .init(latitude: 12, longitude: 13)
        avManager.stubbedCapturedImage = .init()
        viewModel.didTapNextButton()
        view.isShowAlertCalledWithOkAction?()
        
        //then
        XCTAssertTrue(avManager.isCaptureImageGetterCalled)
        XCTAssertTrue(locationManager.isCaptureLocationGetterCalled)
        XCTAssertTrue(view.isShowAlertCalled)
        XCTAssertEqual(view.isShowAlertCalledWithTitleValue,"Art Page")
        XCTAssertEqual(view.isShowAlertCalledWithMessageValue, "Would you like to see the picture you took on the map?")
        XCTAssertNotNil(view.isShowAlertCalledWithOkAction)
    }
}
