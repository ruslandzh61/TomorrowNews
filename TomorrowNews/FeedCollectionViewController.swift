//
//  FeedCollectionViewController.swift
//  iOSPractice1
//
//  Created by Ruslan D on 19/03/2017.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import Alamofire
import Kingfisher
import AVFoundation

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var publisherLogoImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var text = ""
    var utterance = AVSpeechUtterance()    
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func audioButtonClicked(_ sender: UIButton) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        } else if synthesizer.isSpeaking {
            print("pause")
            synthesizer.pauseSpeaking(at: .word)
        } else {
            synthesizer.speak(utterance)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(date: Date?, title: String, summary: String, publisherName: String, text: String) {
        dateLabel.text = date?.timeAgoDisplay() ?? ""
        titleLabel.text = title
        summaryLabel.text = summary
        publisherNameLabel.text = publisherName
        self.text = text
        utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
    }
}

class FeedCollectionViewController: UICollectionViewController {
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)? = (PageAttributesAnimator(), true, 1, 1)
    var direction: UICollectionViewScrollDirection = .vertical
    
   // var imageHandler: ImageHandler = ImageHandler()
    var feeder = ArticleListAPI(type: .channel)
    var channel_id = 0
    let cellIdentifier = "ArticleCollectionViewCell"
    var params = ["format": "json", "category": ""]
    var personalizedParams = ["format": "json", "channel": ""]
    var indexPathSelected = 0
    
    override func viewDidLoad() {
        self.collectionView?.allowsSelection = true
        collectionView?.isPagingEnabled = true
        
        super.viewDidLoad()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = "Sports"
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        //titleLabel.text = "Sports"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
         // Turn on the paging mode for auto snaping support.
        
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
        //collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        if User.shared.uid == nil {
            print("user is nil")
            params["category"] = String(channel_id)
            feeder.load(params: params, isPersonalized: false,
                                completionHandlerForUI: { () in
                self.collectionView?.reloadData()
                print("reload")
            })
        } else {
            personalizedParams["channel"] = String(channel_id)
            feeder.load(params: personalizedParams, isPersonalized: true,
                                completionHandlerForUI: { () in
                self.collectionView?.reloadData()
            })
        }
        print("\(self.channel_id) feed collection view loaded")
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("perform segue1")
        indexPathSelected = indexPath.row
        self.performSegue(withIdentifier: "showArticle", sender: self)
    }
    
    
//    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        self.performSegue(withIdentifier: "showArticle", sender: self)
//        print("perform segue")
//    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "showArticle":
                var destinationViewController = segue.destination
                if let navigationController = destinationViewController as? UINavigationController {
                    destinationViewController = navigationController.visibleViewController ?? destinationViewController
                }
                
                if let vc = destinationViewController as? ArticleViewController {
                    //print(feeder.articles[indexPathSelected].title)
                    vc.article = feeder.get()[indexPathSelected%feeder.get().count]
                    //vc.imageHandler = self.imageHandler
                    if User.shared.uid != nil {
                        performUserArticleInteractionRequest(article: vc.article.id)
                    }
                    //print(vc.article.title)
                    //print("showArticle")
                    
                }
            default: break
            }
        }
    }
    
    private func performUserArticleInteractionRequest(article: Int) {
        let params = ["user": User.shared.uid!, "article": String(article)]
        Alamofire.request(URL(string: "http://localhost:8000/newsfeed/api/v1/userarticleinteraction")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
    }
}


extension FeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Int16.max)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("cellForItemAt \(indexPath.item)")
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let cell = c as? ArticleCollectionViewCell {
            if feeder.get().count > 0 {
                cell.clipsToBounds = animator?.1 ?? true
                let i = indexPath.row % feeder.get().count
                let a = feeder.get()[i]
                if a.top_image == nil {
                    return cell
                }
                
                let url = URL(string: a.top_image!)
                if a.publisherLogo != nil {
                    let publisherLogoRUL = URL(string: a.publisherLogo!)
                    cell.publisherLogoImageView.kf.setImage(with: publisherLogoRUL)
                }
                cell.itemImageView.kf.setImage(with: url)
                cell.setup(date: a.date, title: a.title, summary: a.summary, publisherName: a.publisherName, text: a.text)
            }
        }
        
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let animator = animator else { return view.bounds.size }
        return CGSize(width: view.bounds.width / CGFloat(animator.2), height: view.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
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
