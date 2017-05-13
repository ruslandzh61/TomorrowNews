//
//  TestCollectionViewController.swift
//  NFTopMenuController
//
//  Created by Niklas Fahl on 12/17/14.
//  Copyright (c) 2014 Niklas Fahl. All rights reserved.
//

import UIKit
import Alamofire

let reuseIdentifier = "ChannelCollectionViewCell"

class ChannelCollectionViewController: UICollectionViewController {
    
    var backgroundPhotoNameArray : [String] = ["mood1.jpg", "mood2.jpg", "mood3.jpg", "mood4.jpg", "mood5.jpg", "mood6.jpg", "mood7.jpg", "mood8.jpg"]
    var photoNameArray : [String] = ["relax.png", "playful.png", "happy.png", "adventurous.png", "wealthy.png", "hungry.png", "loved.png", "active.png"]
    
    private var params = ["format": "json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.shared.uid != nil {
            params["uid"] = User.shared.uid
        }
        ChannelCatalogAPI.shared.load(params: params, completionHandlerForUI: { () in
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
        return ChannelCatalogAPI.shared.get().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ChannelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ChannelCollectionViewCell
        
        // Configure the cell
        cell.backgroundImageView.image = UIImage(named: backgroundPhotoNameArray[indexPath.row%backgroundPhotoNameArray.count])
        cell.moodTitleLabel.text = ChannelCatalogAPI.shared.get()[indexPath.row].name
        cell.moodIconImageView.image = UIImage(named: photoNameArray[indexPath.row%photoNameArray.count])
        
        return cell
    }
}
