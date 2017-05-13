//
//  ArticleViewController.swift
//  iOSPractice1
//
//  Created by Ruslan D on 24/03/2017.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    weak var currentViewController: UIViewController?
    
    private lazy var webViewController: WebViewController = {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebController")
        viewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.currentViewController = viewController
        print("lazy web")
        return viewController as! WebViewController
    }()
    
    private lazy var smartViewViewController: SmartViewViewController = {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SmartViewController")
        viewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: viewController!)
        print("lazysmart")
        return viewController as! SmartViewViewController
    }()
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegueToReturnBack()
        print("perform segue")
    }
    
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: webViewController)
            self.currentViewController = webViewController
        } else {
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: smartViewViewController)
            self.currentViewController = smartViewViewController
        }
        updateView()
    }
    @IBOutlet weak var containerView: UIView!

    var article: Article!
    
    private var relatedArticlesFeeder = ArticleListAPI(type: .related)
    private var params = ["format": "json", "article": ""]
    private var isWebDataLoaded = false
    private var isSmartViewDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadWebArticle()
    }
    
    private func setupView() {
        self.currentViewController = webViewController
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
    }
    
    private func setupSmartView() {
        if let vc = self.currentViewController as? SmartViewViewController {
            vc.titleLabel.text = self.article.title
            vc.textTextView.isEditable = false
            vc.textTextView.text = self.article.text
            vc.relatedArticlesFeeder = self.relatedArticlesFeeder
            self.params["article"] = String(article.id)
            self.relatedArticlesFeeder.load(params: params) { () in
                vc.setupScrollView()
                vc.loadArticles()
            }
            print("setupSmartView")
            print(self.relatedArticlesFeeder.get().count)
        }
    }
    
    private func loadWebArticle() {
        let request = URLRequest(url: URL(string: self.article.url)!)
        if let vc = self.currentViewController as? WebViewController {
            print("webview")
            vc.webView.loadRequest(request)
            isWebDataLoaded = true
        }
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 &&
            !isWebDataLoaded {
            loadWebArticle()
        } else if segmentedControl.selectedSegmentIndex == 1 &&
            !isSmartViewDataLoaded {
            setupSmartView()
            isSmartViewDataLoaded = true
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
