//
//  CollectionViewLoadMoreFooterCollectionView.swift
//  LinkIDApp
//
//  Created by PTA on 29/06/2024.
//

import UIKit

class LoadMoreFooterCollectionView: UICollectionReusableView{
 
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
       
    }
    // Add any views or initialization code here
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
        
}
