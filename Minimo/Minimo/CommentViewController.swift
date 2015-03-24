//
//  ViewController.swift
//  Minimo
//
//  Created by Justin Platz and Jake Wayne on 3/20/15.
//  Copyright (c) 2015 Team Mo. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func circleTapped(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
