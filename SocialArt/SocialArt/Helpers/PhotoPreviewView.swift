//
//  PhotoPreviewView.swift
//  SocialArt
//
//  Created by Ayca Akman on 15.10.2023.
//

import UIKit
import Photos
import OSLog

protocol PhotoPreviewDelegate: AnyObject {
    func didTapNextButton()
}

final class PhotoPreviewView: UIView {
    
    weak private var delegate: PhotoPreviewDelegate?

    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right.square"), for: .normal)
        button.addTarget(self, action: #selector(showNextPage), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    init(frame: CGRect, image: UIImage?, delegate: PhotoPreviewDelegate?) {
        super.init(frame: frame)
        
        addSubviews(photoImageView, cancelButton, savePhotoButton, nextButton)
        
        photoImageView.makeConstraints(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 0, width: 0, height: 0)
        
        cancelButton.makeConstraints(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: nil, bottom: nil, topMargin: 15, leftMargin: 10, rightMargin: 0, bottomMargin: 0, width: 80, height: 80)

        savePhotoButton.makeConstraints(top: nil, left: nil, right: rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 80, height: 80)
        savePhotoButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        
        nextButton.makeConstraints(top: nil, left: nil, right: safeAreaLayoutGuide.rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 15, bottomMargin: 15, width: 80, height: 80)

        photoImageView.image = image
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func handleCancel() {
        DispatchQueue.main.async { 
            self.removeFromSuperview()
        }
    }
    
    @objc private func showNextPage() {
        delegate?.didTapNextButton()
    }
    
    @objc private func handleSavePhoto() {
        guard let previewImage = self.photoImageView.image else { return }

        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                        print("Photo has saved in library.")
                    }
                } catch let error {
                    print("failed to save photo in library: \(error)")
                }
            } else {
                print("Something went wrong with permission.")
            }
        }
    }
}
