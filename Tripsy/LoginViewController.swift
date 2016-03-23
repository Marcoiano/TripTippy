//
//  LoginViewController.swift
//  Main
//
//  Created by Marco Tabacchino on 29/09/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Foundation
import ParseUI
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // set our custom background image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
            
            if(error != nil)
            {
                //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
                return
            }
            
            
            let requestParameters = ["fields": "id, email, first_name, last_name"]
            let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
            
            userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
                
                
                
                if(FBSDKAccessToken.currentAccessToken() != nil) {
                    
                    print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
                    
                    print("Current user id= \(FBSDKAccessToken.currentAccessToken().userID)")
                    
                    
                    if(error != nil)
                    {
                        print("\(error.localizedDescription)")
                        return
                    }
                    
                    if(result != nil)
                    {
                        
                        let userId:String = result["id"] as! String
                        let userFirstName:String? = result["first_name"] as? String
                        let userLastName:String? = result["last_name"] as? String
                        let userEmail:String? = result["email"] as? String
                        
                        
                        print("First name= \(userFirstName!)")
                        print("Last name= \(userLastName!)")
                        print("email= \(userEmail!)")
                        
                        
                        let myUser: PFUser = PFUser.currentUser()!
                        
                        //Salvataggio dati utente in parse
                        
                        // Save first name
                        if(userFirstName != nil)
                        {
                            myUser.setObject(userFirstName!, forKey: "first_name")
                            
                        }
                        
                        //Save last name
                        if(userLastName != nil)
                        {
                            myUser.setObject(userLastName!, forKey: "last_name")
                        }
                        
                        // Save email address
                        if(userEmail != nil)
                        {
                            myUser.setObject(userEmail!, forKey: "email")
                        }
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            
                            // Get Facebook profile picture
                            let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                            
                            let profilePictureUrl = NSURL(string: userProfile)
                            
                            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                            
                            if(profilePictureData != nil)
                            {
                                let profileFileObject = PFFile(data:profilePictureData!)
                                
                                myUser.setObject(profileFileObject, forKey: "profile_picture")
                            }
                            
                            
                            myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                                
                                if(success)
                                {
                                    print("User details are now updated")
                                }
                                
                            })
                            
                        }
                    }
                }
            }
        })
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = ContainerViewController()
        
    }
    
    
    @IBAction func twitterLogin(sender: AnyObject) {
        PFTwitterUtils.logInWithBlock { (user, error) -> Void in
            if (user == nil) {
                
                print(user)
                print("Uh oh. The user cancelled the Twitter login.")
                return;
                
            } else if ((user?.isNew) != nil) {
                print("User signed up and logged in with Twitter!")
            } else {
                print("User logged in with Twitter!")
            }
            
            if PFTwitterUtils.isLinkedWithUser(user){
                //copy data to parse user.
                let screenName = PFTwitterUtils.twitter()?.screenName!
                
                let verify = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
                let request = NSMutableURLRequest(URL: verify!)
                PFTwitterUtils.twitter()!.signRequest(request)
                var response: NSURLResponse?
                //let error: NSError?
                
                do {
                    let data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                    
                    if error == nil {
                        do {
                            let result: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            //let names: String! = result?.objectForKey("name") as! String
                            //let separatedNames: [String] = names.componentsSeparatedByString(" ")
                            //var firstName = separatedNames.first!
                            //var lastName = separatedNames.last!
                            let urlString = result?.objectForKey("profile_image_url_https") as! String
                            
                            
                            let hiResUrlString = urlString.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            let twitterPhotoUrl = NSURL(string: hiResUrlString)
                            let imageData = NSData(contentsOfURL: twitterPhotoUrl!)
                            
                            if (screenName != nil){
                                user!.setObject(screenName!, forKey: "username")
                            }
                            
                            if(imageData != nil) {
                                let profileFileObject = PFFile(data:imageData!)
                                user!.setObject(profileFileObject, forKey: "profile_picture")
                            } else {
                                print ("no")
                            }
                            
                            user!.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                                if(success) {
                                    //println("User details are now updated")
                                    user!.pinInBackgroundWithBlock({ (pinUserSuccess:Bool, pinUserError:NSError?) -> Void in
                                        if (pinUserSuccess){
                                            print("User successfully pinned in twitter")
                                        }else {
                                            print("Error in pining the user")
                                        }
                                    })
                                    
                                }
                            })
                            
                            
                            
                        } catch {
                            print (error)
                        }
                    }
                    
                } catch {
                    print (error)
                }
                
            }
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = ContainerViewController()
            
            
        }
    }
}




    