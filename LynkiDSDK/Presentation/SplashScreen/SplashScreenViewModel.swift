//
//  SplashScreenViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import Foundation

protocol SplashScreenViewModelInput {
    func viewDidLoad()
}

protocol SplashScreenViewModelOutput {
    
}

protocol SplashScreenViewModel: SplashScreenViewModelInput, SplashScreenViewModelOutput { }

class DefaultSplashScreenViewModel: SplashScreenViewModel {
    
    // MARK: - OUTPUT

}

// MARK: - INPUT. View event methods
extension DefaultSplashScreenViewModel {
    func viewDidLoad() {
    }
}
