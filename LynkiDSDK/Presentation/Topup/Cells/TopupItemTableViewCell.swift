//
//  TopupItemTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import UIKit

class TopupItemTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var group: TopupGroupModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCellFromNib(ofType: TopupPhoneCollectionViewCell.self)
        collectionView.registerCellFromNib(ofType: TopupDataCollectionViewCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataForCell(group: TopupGroupModel) {
        self.group = group
    }
    
}

extension TopupItemTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group?.gifts.count ?? 0
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let phoneCell = collectionView.dequeueCell(ofType: TopupPhoneCollectionViewCell.self, for: indexPath)
        let dataCell = collectionView.dequeueCell(ofType: TopupDataCollectionViewCell.self, for: indexPath)
        return phoneCell
    }
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
