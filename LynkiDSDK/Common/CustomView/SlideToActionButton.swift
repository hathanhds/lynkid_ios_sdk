//
//  SlideToActionButton.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import Foundation
import UIKit

struct Colors {
    static let background = UIColor.mainColor
    static let draggedBackground = UIColor.white
    static let tint = UIColor.mainColor
}

protocol SlideToActionButtonDelegate: AnyObject {
    func didFinish()
}

class SlideToActionButton: UIView {

    let padding = 2.0

    let handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.draggedBackground
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0
        view.layer.borderColor = Colors.tint?.cgColor
        return view
    }()

    let handleViewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.image = UIImage(systemName: "chevron.right.2", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40, weight: .bold)))?.withRenderingMode(.alwaysTemplate)
        view.image = .iconArrowToSwipe
        view.contentMode = .scaleAspectFit
        view.tintColor = Colors.tint
        return view
    }()

    let draggedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.draggedBackground
        view.layer.cornerRadius = 24
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        // TODO: add custom font for label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Slide me!"
        return label
    }()

    private var leadingThumbnailViewConstraint: NSLayoutConstraint?
    private var panGestureRecognizer: UIPanGestureRecognizer!

    weak var delegate: SlideToActionButtonDelegate?

    private var xEndingPoint: CGFloat {
        return (bounds.width - handleView.bounds.width - padding)
    }

    private var isFinished = false

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        backgroundColor = Colors.background
        layer.cornerRadius = 24
        addSubview(titleLabel)
        addSubview(draggedView)
        addSubview(handleView)
        handleView.addSubview(handleViewImage)

        //MARK: - Constraints

        leadingThumbnailViewConstraint = handleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2)

        NSLayoutConstraint.activate([
            leadingThumbnailViewConstraint!,
            handleView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            handleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            handleView.widthAnchor.constraint(equalToConstant: 44.0),
            draggedView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            draggedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            draggedView.centerYAnchor.constraint(equalTo: handleView.centerYAnchor),
            draggedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            draggedView.trailingAnchor.constraint(equalTo: handleView.trailingAnchor, constant: -padding),
            handleViewImage.topAnchor.constraint(equalTo: handleView.topAnchor),
            handleViewImage.bottomAnchor.constraint(equalTo: handleView.bottomAnchor),
            handleViewImage.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        handleView.addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished { return }
        let translatedPoint = sender.translation(in: self).x
        switch sender.state {
        case .changed:
            if translatedPoint <= 0 {
                updateHandleXPosition(0)
            } else if translatedPoint >= xEndingPoint {
                updateHandleXPosition(xEndingPoint)
            } else {
                updateHandleXPosition(translatedPoint)
            }
        case .ended:
            if translatedPoint >= xEndingPoint {
                self.updateHandleXPosition(xEndingPoint)
                isFinished = true
                delegate?.didFinish()
            } else {
                UIView.animate(withDuration: 1) {
                    self.reset()
                }
            }
        default:
            break
        }
    }

    private func updateHandleXPosition(_ x: CGFloat) {
        leadingThumbnailViewConstraint?.constant = x < 2 ? 2 : x
        let width = self.bounds.width
        titleLabel.alpha = 1 - (x - padding) / width
    }

    func reset() {
        isFinished = false
        updateHandleXPosition(0)
    }
}
