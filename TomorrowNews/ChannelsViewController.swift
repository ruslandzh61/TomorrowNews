//
//  ChannelsViewController.swift
//  TomorrowNews
//
//  Created by Ruslan D on 14.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import Alamofire

class ChannelsViewController: UIViewController {

    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    weak var currentViewController: UIViewController?
    private var isFollowChannelsDataLoaded = false
    private var isSmartViewDataLoaded = false
    private var smartChannels = [Channel]()
    private var systemChannels = [Channel]()
    private var params = ["format": "json", "type": ""]

    private lazy var followChannelViewController: ChannelsCollectionViewController = {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelsCollectionViewController") as! ChannelsCollectionViewController
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.currentViewController = viewController
        print("lazy follow")
        return viewController
    }()
    
    private lazy var smartChannelViewController: ChannelsCollectionViewController = {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChannelsCollectionViewController") as! ChannelsCollectionViewController
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.currentViewController = viewController
        print("lazy smart channel")
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        loadFollowChannels()
    }
    
    private func setupView() {
        self.currentViewController = followChannelViewController
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
    }
    
    private func loadFollowChannels() {
        var urlString = ""
        var systemParams = ["format": "json", "type": "system"]
        systemParams["uid"] = User.shared.uid
        urlString = "http://localhost:8000/newsfeed/api/v1/channels"
        let queue = DispatchQueue(label: "response-queue", qos: .utility, attributes: [.concurrent])
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: systemParams).validate().responseJSON(queue: queue, completionHandler: { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching articles: \(response.result.error)")
                return
            }
            
            if let value = response.result.value {
                if let articleArray = value as? [Any] {
                    print("all categories: \(articleArray)")
                    for articleJSON in articleArray {
                        // access all objects in array
                        let channel = Channel(json: articleJSON as! [String: Any])
                        if channel != nil {
                            self.systemChannels.append(channel!)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                if let vc = self.currentViewController as? ChannelsCollectionViewController {
                    vc.channels = self.systemChannels
                    vc.collectionView?.reloadData()
                    self.isFollowChannelsDataLoaded = true
                }
            }
        })
    }
    
    private func loadSmartChannels() {
        var urlString = ""
        var smartParams = ["format": "json", "type": "smart"]
        smartParams["uid"] = User.shared.uid
        urlString = "http://localhost:8000/newsfeed/api/v1/channels"
        let queue = DispatchQueue(label: "response-queue", qos: .utility, attributes: [.concurrent])
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: smartParams).validate().responseJSON(queue: queue, completionHandler: { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching articles: \(response.result.error)")
                return
            }
            
            if let value = response.result.value {
                if let articleArray = value as? [Any] {
                    print("all categories: \(articleArray)")
                    for articleJSON in articleArray {
                        // access all objects in array
                        let channel = Channel(json: articleJSON as! [String: Any])
                        if channel != nil {
                            self.smartChannels.append(channel!)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                if let vc = self.currentViewController as? ChannelsCollectionViewController {
                    vc.channels = self.smartChannels
                    vc.collectionView?.reloadData()
                    self.isSmartViewDataLoaded = true
                }
            }
        })
    }

    @IBAction func showComponent(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: followChannelViewController)
            self.currentViewController = followChannelViewController
        } else {
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: smartChannelViewController)
            self.currentViewController = smartChannelViewController
        }
        updateView()
    }
    
    private func updateView() {
        if segmentedController.selectedSegmentIndex == 0 &&
            !isFollowChannelsDataLoaded {
            loadFollowChannels()
            print("update follow")
        } else if segmentedController.selectedSegmentIndex == 1 &&
            !isSmartViewDataLoaded {
            loadSmartChannels()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },completion: { finished in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",options: [], metrics: nil, views: viewBindingsDict))
    }

}
