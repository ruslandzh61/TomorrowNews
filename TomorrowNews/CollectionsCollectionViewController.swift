//
//  CollectionsCollectionViewController.swift
//  TomorrowNews
//
//  Created by Ruslan D on 14.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import Alamofire

class CollectionsCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "UserCollectionCell"
    private var params = ["uid": ""]
    private var collections = [UserCollection]()
    
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heighthAdjustment: CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let width = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heighthAdjustment)
        self.title = "Collections"
        params["uid"] = User.shared.uid
        load()
        print("load collections")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numOfSections = 1
        return numOfSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = c as? UserCollectionCollectionViewCell {
            cell.collection = self.collections[indexPath.row]
        }
                
        return c
    }
    
    func load() {
        var urlString = ""
        urlString = "http://localhost:8000/newsfeed/api/v1/collections"
        let queue = DispatchQueue(label: "response-queue", qos: .utility, attributes: [.concurrent])
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: params).validate().responseJSON(queue: queue, completionHandler: { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching articles: \(response.result.error)")
                return
            }
            
            if let value = response.result.value {
                if let articleArray = value as? [Any] {
                    print("all categories: \(articleArray)")
                    for articleJSON in articleArray {
                        // access all objects in array
                        let channel = UserCollection(json: articleJSON as! [String: Any])
                        if channel != nil {
                            self.collections.append(channel!)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
