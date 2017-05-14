//
//  ViewController.swift
//  PageMenuDemoMenuItemWidthBasedOnTitleText
//
//  Created by Niklas Fahl on 12/20/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit
import PageMenu

class ViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    private var params = ["format": "json", "type": "all"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        User.shared.uid = "6jKNcXYvIPUjXnsLvabsvBKySot2"
        // MARK: - UI Setup
        
        //self.title = "PAGE MENU"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 230/255.0, green: 32.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        params["uid"] = User.shared.uid
        ChannelCatalogAPI.shared.load(params: params, completionHandlerForUI: { () in
            self.setup()
        })
    }
    
    func setup() {
        print("setup")
        var controllerArray : [UIViewController] = []
        print(ChannelCatalogAPI.shared.get())
        for channel in ChannelCatalogAPI.shared.get() {
            /*let controller : channelCollectionViewController = channelCollectionViewController(nibName: "channelCollectionViewController", bundle: nil)*/
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeedCollectionViewController") as! FeedCollectionViewController
            controller.title = channel.name
            controller.channel_id = channel.id
            controllerArray.append(controller)
        }
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor(red: 230/255.0, green: 32/255.0, blue: 31/255.0, alpha: 1.0)),
            .addBottomMenuHairline(false),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 35.0)!),
            .menuHeight(50.0),
            .selectionIndicatorHeight(0.0),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor(red: 230/255.0, green: 32/255.0, blue: 31/255.0, alpha: 1.0)),
            CAPSPageMenuOption.centerMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
}

