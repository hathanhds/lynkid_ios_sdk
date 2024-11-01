//
//  GiftGroupTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/02/2024.
//

import UIKit

class GiftGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    var didOpenListGift: (() -> Void)?
    var didOpenGift: ((_ giftId: String, _ giftInfo: GiftInfoItem) -> Void)?
    var giftGroupItem = GiftGroupItem ()

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCellFromNib(ofType: GiftCollectionViewCell.self)
    }

    func setDatForCell(giftGroupItem: GiftGroupItem) {
        self.giftGroupItem = giftGroupItem
        self.groupNameLabel.text = giftGroupItem.giftGroup?.name

        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func openListGiftAction(_ sender: Any) {
        didOpenListGift?()
    }

}

extension GiftGroupTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.giftGroupItem.gifts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: GiftCollectionViewCell.self, for: indexPath)
        if let gift = giftGroupItem.gifts?[indexPath.row] {
            cell.setDataForCell(gift: gift)
        }
        return cell
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = giftGroupItem.gifts?[indexPath.row]
        let giftId = "\(group?.giftInfo?.id ?? 0)"
        didOpenGift?(giftId, GiftInfoItem(giftInfor: group?.giftInfo))
    }

    // MARK: - Flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 2.0
        let height = 170.0

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    }

}


