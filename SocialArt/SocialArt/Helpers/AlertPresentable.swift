//
//  AlertPresentable.swift
//  SocialArt
//
//  Created by Ayca Akman on 21.10.2023.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String, message: String, okAction: @escaping () -> Void)
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String, message: String, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            okAction()
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
}
