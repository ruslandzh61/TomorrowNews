//
//  WebViewController.swift
//  iOSPractice1
//
//  Created by Ruslan D on 25/03/2017.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

final class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    /*@IBAction func backButton(_ sender: Any) {
        self.performSegueToReturnBack()
        print("perform segue")
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Summary View Controller Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Summary View Controller Will Disappear")
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