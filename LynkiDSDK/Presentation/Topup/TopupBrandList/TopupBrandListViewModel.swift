//
//  TopupBrandListViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/08/2024.
//

import Foundation

class TopupBrandListViewModel {
    
    typealias SelectedBrandAction = ((_ brand: TopupBrandItem) -> Void)?
        
    let brandList: [TopupBrandModel]
    private let selectedBrandAction: SelectedBrandAction
    let currentBrand: TopupBrandItem?
    
    init(selectedBrandAction: SelectedBrandAction, currentBrand: TopupBrandItem?, brandList: [TopupBrandModel]) {
        self.brandList = brandList
        self.selectedBrandAction = selectedBrandAction
        self.currentBrand = currentBrand
    }
    
    func onSelectedBrand(_ brand: TopupBrandItem) {
        self.selectedBrandAction?(brand)
    }
}
