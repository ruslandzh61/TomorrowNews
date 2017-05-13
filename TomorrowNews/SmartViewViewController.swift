//
//  SmartViewViewController.swift
//  iOSPractice1
//
//  Created by Ruslan D on 25/03/2017.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import Kingfisher

class SmartViewViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var smartView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var recommendedArticlesScrollView: UIScrollView!
    @IBOutlet weak var featurePageControl: UIPageControl!
    
    var relatedArticlesFeeder = ArticleListAPI(type: .related)
    //var imageHandler: ImageHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendedArticlesScrollView.isPagingEnabled = true
        recommendedArticlesScrollView.delegate = self
        //setupScrollView()
        // Do any additional setup after loading the view.
    }
    
    func setupScrollView() {
        let f = self.view.bounds.width - 30
        recommendedArticlesScrollView.contentSize = CGSize(width: f * CGFloat(relatedArticlesFeeder.get().count), height: 180)
        recommendedArticlesScrollView.showsVerticalScrollIndicator = false
        recommendedArticlesScrollView.showsHorizontalScrollIndicator = false
        print("setupSCrollView")
        //loadArticles()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = recommendedArticlesScrollView.contentOffset.x / scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)
    }
    
    
    
    func loadArticles() {
        print("loadArtiles")
        var index = 0
        for article in relatedArticlesFeeder.get() {
            let recommendedArticleView = Bundle.main.loadNibNamed("RecommendedArticle", owner: self, options: nil)?.first as! RecommendedArticleView
            recommendedArticleView.titleLabel.text = article.title
            recommendedArticleView.summaryLabel.text = article.summary
            
            if let url = URL(string: article.top_image!), let data = NSData (contentsOf: url as URL) {
                //process image
               recommendedArticleView.imageView.kf.setImage(with: url)
                
                // recommendedArticleView.imageView = UIImage(data: data as Data)!
            }
            
            recommendedArticlesScrollView.addSubview(recommendedArticleView)
            recommendedArticleView.frame.size.width = self.recommendedArticlesScrollView.bounds.size.width
            recommendedArticleView.frame.origin.x = CGFloat(index) * self.recommendedArticlesScrollView.bounds.size.width
            
       //     print(recommendedArticleView.frame.
            
            
            index = index + 1
        }
        featurePageControl.numberOfPages = relatedArticlesFeeder.get().count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SmartView View Controller Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("SmartView View Controller Will Disappear")
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
