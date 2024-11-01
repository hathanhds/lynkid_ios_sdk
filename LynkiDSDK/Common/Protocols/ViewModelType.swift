//
//  ViewModelType.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/02/2024.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
