//
//  UserCollectionCollectionViewCell.swift
//  TomorrowNews
//
//  Created by Ruslan D on 14.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

class UserCollectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionImageView: UIImageView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var collectionTitleLabel: UILabel!
    
    var collection: UserCollection? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        let logoUrl = URL(string: (collection?.logo)!)
        collectionImageView.kf.setImage(with: logoUrl)
        collectionTitleLabel.text = collection?.name
    }
}
