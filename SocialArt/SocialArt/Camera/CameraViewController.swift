//
//  CameraViewController.swift
//  SocialArt
//
//  Created by Ayca Akman on 15.10.2023.
//

import UIKit
import AVFoundation
import CoreLocation

protocol CameraViewInterface: AnyObject, AlertPresentable {
    var tabBar: TabBarControllerInterface? { get }
    
    func prepareView()
    func prepareTabBar()
    func dismissView()
    func prepareUI()
    func addSublayer(_ cameralayer: AVCaptureVideoPreviewLayer)
}

final class CameraViewController: UIViewController {

    private var viewModel: CameraViewModelInterface
    
    init(viewModel: CameraViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var switchCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        button.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(takeCameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func openCamera() {
        viewModel.openCamera()
    }
    
    @objc private func cancelButtonTapped() {
        viewModel.handleCancelButtonTapped()
    }
    
    @objc private func takeCameraButtonTapped() {
        viewModel.handleTakePhoto()
    }
    
    @objc private func switchCameraButtonTapped() {
        viewModel.handleSwitchCameraButtonTapped()
    }
}

//MARK: - CameraViewInterface
extension CameraViewController: CameraViewInterface {
    var tabBar: TabBarControllerInterface? {
        tabBarController as? TabBarControllerInterface
    }
    
    func prepareView() {
        openCamera()
    }
    
    func prepareTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func prepareUI() {
        self.view.addSubviews(cancelButton, takePhotoButton, switchCameraButton)
        
        takePhotoButton.makeConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 15, width: 80, height: 80)
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cancelButton.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, topMargin: 15, leftMargin: 10, rightMargin: 0, bottomMargin: 0, width: 80, height: 80)

        switchCameraButton.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 80, height: 80)
    }
    
    func addSublayer(_ cameraLayer: AVCaptureVideoPreviewLayer) {
        cameraLayer.frame = self.view.frame
        cameraLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(cameraLayer)
    }
}

extension CameraViewController: AVFoundationManagerDelegate {
    var parentView: UIViewController? { self }
    
    func didFinishProcessingPhoto(image: UIImage) {
        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame,
                                                     image: image,
                                                     delegate: viewModel.previewDelegate)
        self.view.addSubviews(photoPreviewContainer)
    }
    
    func cameraPermissionDenied() {
        viewModel.handleCameraPermissionDenied()
    }
    
    func prepareCaptureSessionCompleted() {
        viewModel.prepareCaptureSessionCompleted()
    }
}
