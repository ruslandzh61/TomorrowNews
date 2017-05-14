//
//  ChannelsViewController.swift
//  TomorrowNews
//
//  Created by Ruslan D on 14.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {

    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    weak var currentViewController: UIViewController?
    private var isFollowChannelsDataLoaded = false
    private var isSmartViewDataLoaded = false
    
    private lazy var followChannelViewController: ChannelCollectionViewController = {
        let viewController = ChannelCollectionViewController(nibName: "ChannelCollectionViewController", bundle: nil)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.currentViewController = viewController
        print("lazy follow")
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
        //let request = URLRequest(url: URL(string: self.article.url)!)
        if let vc = self.currentViewController as? ChannelCollectionViewController {
            //print("webview")
            //vc.webView.loadRequest(request)
            isFollowChannelsDataLoaded = true
        }
    }

    @IBAction func showComponent(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: followChannelViewController)
            self.currentViewController = followChannelViewController
        }else {
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
            //setupSmartView()
            isSmartViewDataLoaded = true
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