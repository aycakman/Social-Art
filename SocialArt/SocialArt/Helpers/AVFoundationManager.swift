//
//  AVFoundationManager.swift
//  SocialArt
//
//  Created by Ayca Akman on 28.10.2023.
//

import AVFoundation
import UIKit
import OSLog

protocol AVCapturePhotoOutputProtocol {
    func capturePhoto(with settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)
}

protocol AVCaptureSessionProtocol {
    var inputs: [AVCaptureInput] { get }

    func addInput(_ input: AVCaptureInput)
    func canAddInput(_ input: AVCaptureInput) -> Bool
    func addOutput(_ output: AVCaptureOutput)
    func canAddOutput(_ output: AVCaptureOutput) -> Bool
    func beginConfiguration()
    func removeInput(_ input: AVCaptureInput)
    func commitConfiguration()
    func startRunning()
}

protocol AVFoundationManagerInterface {
    var capturedImage: UIImage? { get }

    func openCamera()
    func handleTakePhoto()
    func handleSwitchCameraButtonTapped()
}

protocol AVFoundationManagerDelegate: AnyObject {
    var parentView: UIViewController? { get }

    func didFinishProcessingPhoto(image: UIImage)
    func cameraPermissionDenied()
    func prepareCaptureSessionCompleted()
}

final class AVFoundationManager: NSObject {

    weak var delegate: AVFoundationManagerDelegate?

    private let photoOutput: AVCapturePhotoOutputProtocol
    private let captureSession: AVCaptureSessionProtocol
    private let global: DispatchQueueInterface
    private let main: DispatchQueueInterface? = nil
    private let captureDevice: AVCaptureDevice?
    var capturedImage: UIImage?

    init(photoOutput: AVCapturePhotoOutputProtocol, captureSession: AVCaptureSessionProtocol, global: DispatchQueueInterface, captureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)) {
        self.photoOutput = photoOutput
        self.captureSession = captureSession
        self.global = global
        self.captureDevice = captureDevice
    }

    func setupCaptureSession() {
        if let captureDevice = captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("failed to set input device: \(error)")
            }

            if captureSession.canAddOutput(photoOutput as! AVCaptureOutput) {
                captureSession.addOutput(photoOutput as! AVCaptureOutput)
            }

            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession as! AVCaptureSession)
            cameraLayer.frame = delegate?.parentView?.view.bounds ?? .zero
            cameraLayer.videoGravity = .resizeAspectFill
            delegate?.parentView?.view.layer.addSublayer(cameraLayer)

            global.async {
                self.captureSession.startRunning()
            }

            delegate?.prepareCaptureSessionCompleted()
        }
    }

    func setCameraPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position).devices

        return availableDevices.first
    }
}

extension AVFoundationManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let previewImage = UIImage(data: imageData) else { return }
       
       // UserDefaults.standard.setValue(imageData, forKey: "image")
        capturedImage = previewImage
        delegate?.didFinishProcessingPhoto(image: previewImage)
    }
}

//MARK: - AVFoundationManagerInterface
extension AVFoundationManager: AVFoundationManagerInterface {
    func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    print("the user has granted to access the camera")
                    self?.main?.async {
                        self?.setupCaptureSession()
                    }
                } else {
                    print("the user has not granted to access the camera")
                    self?.delegate?.cameraPermissionDenied()
                }
            }
        case .denied:
            print("denied")
            delegate?.cameraPermissionDenied()
        case .restricted:
            print("restricted")
            delegate?.cameraPermissionDenied()
        @unknown default:
            break
        }
    }

    func handleTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        guard let  photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first else { return }
        photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    func handleSwitchCameraButtonTapped() {
        captureSession.beginConfiguration()

        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            captureSession.removeInput(currentInput)

            let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back

            if let newCamera = setCameraPosition(position: newPosition), let newInput = try? AVCaptureDeviceInput(device: newCamera) {
                if captureSession.canAddInput(newInput) == true {
                    captureSession.addInput(newInput)
                }
            }
        }

        captureSession.commitConfiguration()
    }
}

extension AVCapturePhotoOutput: AVCapturePhotoOutputProtocol { }

extension AVCaptureSession: AVCaptureSessionProtocol { }
