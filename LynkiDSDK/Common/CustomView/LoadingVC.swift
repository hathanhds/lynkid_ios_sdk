//
//  LoadingVC.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/12/2024.
//

import UIKit

class LoadingViewController: UIViewController {
    
    static let loadingVC = LoadingViewController()
    private var activityIndicator: UIActivityIndicatorView!



    private let loadingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        // Set background color
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = .lightGray
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        // Configure Activity Indicator
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        // Configure Loading Label
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = .white
        loadingLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingLabel)

        // Add Constraints
        NSLayoutConstraint.activate([
            // Center the activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            // Place the label below the activity indicator
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])

        // Start animating the activity indicator
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        dismiss(animated: true)
    }
}
