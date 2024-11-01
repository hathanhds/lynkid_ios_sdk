//
//  GiftCateResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import Foundation

struct GiftDiamondCateResponseModel: Codable {
    var result: GiftDiamondCateResultModel?
}



struct GiftDiamondCateResultModel: Codable {
    var items: [DiamondItem]?
}


struct DiamondItem: Codable {
    let giftCategory: DiamondGiftCategory
}

struct DiamondGiftCategory: Codable {
    let code, name: String
    let description: String?
    let imageLink: ImageLink
}

struct DiamondCategoryDescription: Codable {
    let title: String
    let content: String
}

struct ImageLink: Codable {
    let fullLink: String?
}

extension GiftDiamondCateResponseModel {
    static func from(model: GiftDiamondCateResultModel) -> [GiftCategory] {
        guard let items = model.items else {
            return []
        }
        
        return items.map { item in
            guard let descriptionString = item.giftCategory.description else {
                return GiftCategory(
                    code: item.giftCategory.code,
                    name: item.giftCategory.name,
                    descTitle: nil,
                    descContent: nil,
                    fullLink: item.giftCategory.imageLink.fullLink,
                    categoryTypeCode: nil // Adjust as needed
                )
            }
            
            let descriptionData = descriptionString.data(using: .utf8)
            let decodedDescription = try? JSONDecoder().decode(DiamondCategoryDescription.self, from: descriptionData!)
            
            return GiftCategory(
                code: item.giftCategory.code,
                name: item.giftCategory.name,
                descTitle: decodedDescription?.title, 
                descContent: decodedDescription?.content,
                fullLink: item.giftCategory.imageLink.fullLink,
                categoryTypeCode: nil // Adjust as needed
            )
        }
    }
}
