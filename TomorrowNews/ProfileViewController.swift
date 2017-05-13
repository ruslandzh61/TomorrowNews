//
//  ProfileViewController.swift
//  NewsFusion
//
//  Created by Ruslan D on 11/12/2016.
//  Copyright © 2016 Ruslan D. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import Alamofire

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out")
        profileImage.image = UIImage(named: "profilePlaceholder")
        profileName.text = ""
        profileName.isHidden = true
        if User.shared.uid != nil {
            User.shared.isChanged = true
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Succesfully logged in with Facebook")
        
        performLogin()
        /*if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }*/
    }
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        User.shared.uid = "6jKNcXYvIPUjXnsLvabsvBKySot2"
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        if (FBSDKAccessToken.current()) != nil {
            profileName.isHidden = false
        } else {
            profileName.isHidden = true
        }
    }
    
    func performLogin() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        print("access token: \(accessTokenString)")
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        var uid = ""
        var data = ("", "", "")
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            if user?.uid == nil {
                return
            }
            uid = user!.uid
            print("user id inside auth \(user!.uid)")
            print("Successfully logged in with our user: ", user ?? "")
            data = self.fetchProfile(uid: uid)
            
            let ref = FIRDatabase.database().reference(fromURL: "https://fir-project-37b1b.firebaseio.com/")
            
            let usersReference = ref.child("users").child(uid)
            let values = ["name": data.0, "email": data.1, "picture": data.2]
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err ?? "")
                    return
                }
                
                print("Saved user successfully into Firebase db")
                self.createUserInDatabase(uid: uid, name: data.0, email: data.1, picture: data.2)
            })
            
        })
    }
    
    func createUserInDatabase(uid: String, name: String, email: String, picture: String) {
        let params = ["uid": uid, "name": name, "email": email, "picture": picture]
        Alamofire.request(URL(string: "http://localhost:8000/newsfeed/api/v1/users")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
        User.shared.update(uid: uid, name: name, email: email, picture: picture)
    }
    
    func fetchProfile(uid: String) -> (String, String, String) {
        var userName = ""
        var userEmail = ""
        var userPicture = ""
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start (completionHandler: { (connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            var res = result as? NSDictionary
            if let email = res?["email"] as? String {
                userEmail = email
            }
            
            if let first_name = res?["first_name"] as? String, let last_name = res?["last_name"] as? String {
                self.profileName.text = first_name + " " + last_name
                self.profileName.isHidden = false
                userName = first_name + " " + last_name
            } else {
                self.profileName.text = ""
            }
            
            if let picture = res?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let urlString = data["url"] as? String {
                print(urlString)
                if let url = URL(string: urlString), let urlContent = NSData(contentsOf: url as URL) {
                    self.profileImage.image = UIImage(data: urlContent as Data)
                }
                userPicture = urlString
            }
        })
        return (userName, userEmail, userPicture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


