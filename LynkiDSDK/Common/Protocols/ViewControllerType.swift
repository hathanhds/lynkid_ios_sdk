//
//  ViewControllerType.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/02/2024.
//

import UIKit.UIViewController

protocol ViewControllerType where Self: UIViewController {
    associatedtype ViewModel: ViewModelType
    static func create (with navigator: Navigator, viewModel: ViewModel) -> Self
}
