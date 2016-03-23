//
//  ProfileViewController.swift
//  SlideOut
//
//  Created by Marco Tabacchino on 03/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, PFLogInViewControllerDelegate {
    
    @IBOutlet weak var profilePic: PFImageView!
    
    @IBOutlet weak var NameLab: UILabel!
    
    @IBOutlet weak var LastNameLab: UILabel!
    
    
    
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        let myLogPage = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        let myLogPageNav = UINavigationController(rootViewController: myLogPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = myLogPageNav
        
        PFUser.logOut()
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = PFUser.currentUser()
        if let name = object?["first_name"] as? String {
            NameLab.text = name
        }
        if let lastName = object?["last_name"] as? String {
            LastNameLab.text = lastName
        }
        let initialThumbnail = UIImage(named: "qthumb")
        profilePic.image = initialThumbnail
        if let thumbnail = object?["profile_picture"] as? PFFile {
            profilePic.file = thumbnail
            profilePic.loadInBackground()
        }
        
        
        
        
    }
    
    
}



