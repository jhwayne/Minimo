//
//  ComposeViewController.swift
//  SwifferApp
//
//  Created by Training on 29/06/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var commentTextView: UITextView! = UITextView()
    @IBOutlet weak var charRemainingLabel: UILabel! = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.layer.borderColor = UIColor.blackColor().CGColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.cornerRadius = 5
        commentTextView.delegate = self
        
        commentTextView.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSweet(sender: AnyObject) {
        
        var sweet:PFObject = PFObject(className: "Sweets")
        sweet["content"] = commentTextView.text
        //sweet["sweeter"] = PFUser.currentUser()
        
        sweet.saveInBackgroundWithTarget(nil, selector: nil)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    func textView(textView: UITextView!,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String!) -> Bool{
            
            var newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingChar:Int = 140 - newLength
            
            charRemainingLabel.text = "\(remainingChar)"
            
            return (newLength > 140) ? false : true
    }
    

    
}
