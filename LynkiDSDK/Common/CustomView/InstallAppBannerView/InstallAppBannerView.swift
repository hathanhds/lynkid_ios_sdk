//
//  InstallAppBanner.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 22/01/2024.
//

import UIKit

//@IBDesignable
class InstallAppBannerView: UIView, NibLoadable {

    @IBOutlet weak var installButton: UIButton!
    @IBOutlet var view: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    func configureUI() {
        installButton.setInstallAppButtonGradient()
        view.setCommonGradient()
    }

    @IBAction func installAppAction(_ sender: Any) {
        UtilHelper.openLynkiDAPP()
    }

}
