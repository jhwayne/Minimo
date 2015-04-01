//
//  StoryViewController.swift
//  SwifferApp
//
//  Created by Justin Platz on 3/30/15.
//  Copyright (c) 2015 Training. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
   
    @IBOutlet weak var postOfDay: UITextView!
    
    override func viewDidAppear(animated: Bool) {
        var query = PFQuery(className:"Posts")
        query.whereKey("DisplayToday", equalTo:"Yes")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        self.postOfDay.text = object["content"] as NSString
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
    }

}
