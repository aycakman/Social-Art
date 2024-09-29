//
//  AVFoundationManagerTests.swift
//  SocialArtTests
//
//  Created by Ayca Akman on 20.11.2023.
//

@testable import SocialArt
import XCTest
import AVFoundation

final class AVFoundationManagerTests: XCTestCase {
    // The mock of  protocols that allow us to perform the test should be given.
    var avCaptureSession: MockAVCaptureSession!
    var avCapturePhotoOutput: MockAVCapturePhotoOutput!
    var avManagerDelegate: MockAVFoundationManagerDelegate!
    var main: MockDispatchQueue!
    var global: MockDispatchQueue!

    // The class I tested
    var avManager: AVFoundationManager!

    override func setUp() {
        super.setUp()
        avCaptureSession = .init()
        avCapturePhotoOutput = .init()
        main = .init()
        global = .init()
        avManager = .init(photoOutput: avCapturePhotoOutput, captureSession: avCaptureSession, global: global)
        avManagerDelegate = .init()
        avManager.delegate = avManagerDelegate
    }

    override func tearDown() {
        avCaptureSession = nil
        avCapturePhotoOutput = nil
        avManager = nil
        avManagerDelegate = nil
        main = nil
        global = nil
        super.tearDown()
    }

    func test_setupCaptureSession_notExistsCaptureDevice_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
        XCTAssertFalse(avManagerDelegate.invokedPrepareCaptureSessionCompleted)

        //when
        avManager.setupCaptureSession()

        //then
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
        XCTAssertTrue(avCaptureSession.stubbedInputs.isEmpty)
        XCTAssertFalse(avManagerDelegate.invokedPrepareCaptureSessionCompleted)
    }

    func test_setupCaptureSession_existsCaptureDevice_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
        XCTAssertFalse(avManagerDelegate.invokedPrepareCaptureSessionCompleted)

        //when
        avManager.setupCaptureSession()

        //then
        XCTAssertTrue(avCaptureSession.invokedCanAddInput)
        XCTAssertTrue(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 1)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 1)
        XCTAssertFalse(avCaptureSession.stubbedInputs.isEmpty)
        XCTAssertTrue(avManagerDelegate.invokedPrepareCaptureSessionCompleted)
    }

    func test_openCamera_whenAuthorized_invokesSetupCaptureSessionMethod() {
        //given
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)

        //when
        avManager.openCamera()

        //then
        XCTAssertTrue(avCaptureSession.invokedCanAddInput)
        XCTAssertTrue(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 1)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 1)
    }

    func test_openCamera_whenNotDeterminedAndGranted_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)

        //when
        avManager.openCamera()

        //then
        XCTAssertTrue(avCaptureSession.invokedCanAddInput)
        XCTAssertTrue(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 1)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 1)
    }

    func test_openCamera_whenNotDeterminedAndNotGranted_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)

        //when
        avManager.openCamera()

        //then

        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
    }

    func test_openCamera_whenDeniedAndRestricted_invokesCameraPermissionDeniedMethod() {
        //given
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)

        //when
        avManager.openCamera()

        //then
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
    }

    func test_handleTakePhoto_notExistsPhotoPreviewType_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCapturePhotoOutput.invokedCapturePhoto)
        XCTAssertEqual(avCapturePhotoOutput.invokedCapturePhotoCount, 0)

        //when
        avManager.handleTakePhoto()

        //then
        XCTAssertFalse(avCapturePhotoOutput.invokedCapturePhoto)
        XCTAssertEqual(avCapturePhotoOutput.invokedCapturePhotoCount, 0)
    }

    func test_handleTakePhoto_existsPhotoPreviewType_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCapturePhotoOutput.invokedCapturePhoto)
        XCTAssertEqual(avCapturePhotoOutput.invokedCapturePhotoCount, 0)

        //when
        avManager.handleTakePhoto()

        //then
        XCTAssertTrue(avCapturePhotoOutput.invokedCapturePhoto)
        XCTAssertEqual(avCapturePhotoOutput.invokedCapturePhotoCount, 1)
    }

    func test_handleSwitchCameraButtonTapped_existsCurrentInput_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCaptureSession.invokedBeginConfiguration)
        XCTAssertEqual(avCaptureSession.invokedBeginConfigurationCount, 0)
        XCTAssertFalse(avCaptureSession.invokedRemoveInput)
        XCTAssertEqual(avCaptureSession.invokedRemoveInputCount, 0)
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
        XCTAssertFalse(avCaptureSession.invokedCommitConfiguration)
        XCTAssertEqual(avCaptureSession.invokedCommitConfigurationCount, 0)

        //when
        avManager.handleSwitchCameraButtonTapped()

        //then
        XCTAssertTrue(avCaptureSession.invokedBeginConfiguration)
        XCTAssertEqual(avCaptureSession.invokedBeginConfigurationCount, 1)
        XCTAssertTrue(avCaptureSession.invokedRemoveInput)
        XCTAssertEqual(avCaptureSession.invokedRemoveInputCount, 1)
        XCTAssertTrue(avCaptureSession.invokedCanAddInput)
        XCTAssertTrue(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 1)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 1)
        XCTAssertTrue(avCaptureSession.invokedCommitConfiguration)
        XCTAssertEqual(avCaptureSession.invokedCommitConfigurationCount, 0)
    }


    func test_handleSwitchCameraButtonTapped_notExistsCurrentInput_invokesRequiredMethods() {
        //given
        XCTAssertFalse(avCaptureSession.invokedBeginConfiguration)
        XCTAssertEqual(avCaptureSession.invokedBeginConfigurationCount, 0)
        XCTAssertFalse(avCaptureSession.invokedRemoveInput)
        XCTAssertEqual(avCaptureSession.invokedRemoveInputCount, 0)
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
        XCTAssertFalse(avCaptureSession.invokedCommitConfiguration)
        XCTAssertEqual(avCaptureSession.invokedCommitConfigurationCount, 0)

        //when
        avManager.handleSwitchCameraButtonTapped()

        //then
        XCTAssertTrue(avCaptureSession.invokedBeginConfiguration)
        XCTAssertEqual(avCaptureSession.invokedBeginConfigurationCount, 1)
        XCTAssertFalse(avCaptureSession.invokedRemoveInput)
        XCTAssertEqual(avCaptureSession.invokedRemoveInputCount, 0)
        XCTAssertFalse(avCaptureSession.invokedCanAddInput)
        XCTAssertFalse(avCaptureSession.invokedAddInput)
        XCTAssertEqual(avCaptureSession.invokedAddInputCount, 0)
        XCTAssertEqual(avCaptureSession.invokedCanAddInputCount, 0)
        XCTAssertTrue(avCaptureSession.invokedCommitConfiguration)
        XCTAssertEqual(avCaptureSession.invokedCommitConfigurationCount, 1)
    }
}
