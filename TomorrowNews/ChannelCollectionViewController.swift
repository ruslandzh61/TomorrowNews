//
//  TestCollectionViewController.swift
//  NFTopMenuController
//
//  Created by Niklas Fahl on 12/17/14.
//  Copyright (c) 2014 Niklas Fahl. All rights reserved.
//

import UIKit
import Alamofire



class ChannelCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "ChannelCollectionViewCell"
    private var params = ["format": "json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.shared.uid != nil {
            params["uid"] = User.shared.uid
        }
        PersonalChannelCatalogAPI.shared.load(params: params, completionHandlerForUI: { () in
            self.collectionView?.reloadData()
        })
        self.collectionView!.register(UINib(nibName: "ChannelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numOfSections = 1
        return numOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PersonalChannelCatalogAPI.shared.get().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ChannelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ChannelCollectionViewCell
        
        // Configure the cell
        let channel = PersonalChannelCatalogAPI.shared.get()[indexPath.row]
        let logoUrl = URL(string: channel.logo)
        cell.backgroundImageView.kf.setImage(with: logoUrl)
        cell.moodTitleLabel.text = channel.name
        
        return cell
    }
}
