//
//  LoadingManageer.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/12/2024.
//

import UIKit

class LoadingManager {
    static let shared = LoadingManager()

    private var loadingView: UIView?

    private init() { }

    func showLoading(in view: UIView, color: UIColor? = .mainColor, message: String? = nil) {
        // If a loading view already exists, return
        guard loadingView == nil else { return }

        // Create a semi-transparent overlay
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        // Create the activity indicator
        var activityIndicator: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }

        activityIndicator.color = color
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(activityIndicator)

        // Add constraints for centering the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
            ])

        // Optionally add a message below the spinner
        if let message = message {
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            overlay.addSubview(label)

            // Add constraints for the label
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
                label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor)
                ])
        }

        // Add the overlay to the target view
        view.addSubview(overlay)

        // Store the overlay for later removal
        loadingView = overlay
    }

    func hideLoading() {
        // Remove the loading view
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
