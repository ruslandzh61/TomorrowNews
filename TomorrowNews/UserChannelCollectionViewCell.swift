//
//  UserChannelCollectionViewCell.swift
//  TomorrowNews
//
//  Created by Ruslan D on 15.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

class UserChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var channelmageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!

    var channel: Channel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        let logoUrl = URL(string: (channel?.logo)!)
        channelmageView.kf.setImage(with: logoUrl)
        channelTitleLabel.text = channel?.name
    }
}
