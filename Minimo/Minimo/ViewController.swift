//
//  ViewController.swift
//  Minimo
//
//  Created by Justin Platz on 3/20/15.
//  Copyright (c) 2015 Team Mo. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    
    @IBAction func loginVerifyButton(sender: AnyObject) {
        
        var usrEntered = usernameTextField.text
        var pwdEntered = passwordTextField.text
        var emlEntered = emailTextField.text
        
        if usrEntered != "" && pwdEntered != "" && emlEntered != "" {
            userSignUp()
        }
        else {
            self.messageLabel.text = "All Fields Required"
        }
        
    }
    
    func userSignUp() {
        var usrEntered = usernameTextField.text
        var pwdEntered = passwordTextField.text
        var emlEntered = emailTextField.text
        
        var user = PFUser()
        
        user.username = usrEntered
        user.password = pwdEntered
        user.email = emlEntered
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                self.messageLabel.text = "User Signed Up";
            } else {
                // Show the errorString somewhere and let the user try again.
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        
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
