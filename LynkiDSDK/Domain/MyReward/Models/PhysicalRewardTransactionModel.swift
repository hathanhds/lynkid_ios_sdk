//
//  PhysicalTransactionModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/05/2024.
//

import Foundation

struct PhysicalRewardTransactionModel {
    var title: String
    var stepNumber: Int
    var isCurrentStep: Bool
    var isLeftLineActive: Bool
    var isRightLineActive: Bool

    init(title: String, stepNumber: Int, isCurrentStep: Bool, isLeftLineActive: Bool, isRightLineActive: Bool) {
        self.title = title
        self.stepNumber = stepNumber
        self.isCurrentStep = isCurrentStep
        self.isLeftLineActive = isLeftLineActive
        self.isRightLineActive = isRightLineActive
    }
}
