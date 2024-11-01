//
//  UserInfoViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import Foundation

protocol UserInfoViewModelInput {
    func viewDidLoad()
}

protocol UserInfoViewModelOutput {
    
}

protocol UserInfoViewModel: UserInfoViewModelInput, UserInfoViewModelOutput { }

class DefaultUserInfoViewModel: UserInfoViewModel {
    
    init() {
        
    }
    
    // MARK: - OUTPUT

}

// MARK: - INPUT. View event methods
extension DefaultUserInfoViewModel {
    func viewDidLoad() {
        
        
    }
}
