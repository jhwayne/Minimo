//
//  ViewController.swift
//  Minimo
//
//  Created by Justin Platz and Jake Wayne on 3/20/15.
//  Copyright (c) 2015 Team Mo. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var postOfDay: UITextView!
    
    @IBAction func signOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFQuery(className:"Posts")
        query.whereKey("objectId", equalTo:"GOJfwKiCAl")
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject!, error: NSError!) -> Void in
            if error != nil || object == nil{
            println("The getFirstObject request failed.")
        } else {
            // The find succeeded.
            self.postOfDay.text = object["content"] as NSString
            println(object["content"])
            
        }
    }
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}
