//
//  LoginViewController.swift
//  TouchID
//
//  Created by Simon Ng on 24/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var loginView:UIView!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    @IBAction func authenticateWithPassword() {
        if emailTextField.text == "hi@appcoda.com" && passwordTextField.text == "1234" {
        performSegueWithIdentifier("showHomeScreen", sender: nil)
        }else {
        // Shake to indicate wrong login ID/password 
        loginView.transform = CGAffineTransformMakeTranslation(25, 0)
        UIView.animateWithDuration(0.5, delay: 0.0,
        usingSpringWithDamping: 0.15, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: {
        self.loginView.transform = CGAffineTransformIdentity
        }, completion: nil) }
    }
    
    private var imageSet = ["coffee"]
    
    func authenticateWithTouchID(){
        
        //Get the local authentication context.
        let localAuthContext = LAContext()
        let reasonText = "Authentication is required to login to Brew"
        var authError: NSError?
        
        if !localAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            println(authError?.localizedDescription)
            
            // Display the login dialog when Touch ID is not available (e.g. in simulator)
            showLoginDialog()
            
            return
        }
        // Perform the Touch ID authentication
        localAuthContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText, reply: { (success: Bool, error: NSError!) -> Void in
                
                if success {
            
                println("Successfully authenticated")
                NSOperationQueue.mainQueue().addOperationWithBlock({
                self.performSegueWithIdentifier("showHomeScreen", sender: nil)
            })
            
            } else {
                switch error.code {
            case LAError.AuthenticationFailed.rawValue:
                println("Authentication failed")
            case LAError.PasscodeNotSet.rawValue:
                println("Passcode not set")
            case LAError.SystemCancel.rawValue:
                println("Authentication was canceled by system") case LAError.UserCancel.rawValue:
                println("Authentication was canceled by the user") case LAError.TouchIDNotEnrolled.rawValue:
                println("Authentication could not start because Touch ID has no enrolled fingers.") case LAError.TouchIDNotAvailable.rawValue:
                println("Authentication could not start because Touch ID is not available.") case LAError.UserFallback.rawValue:
                println("User tapped the fallback button (Enter Password).")
            default: println(error.localizedDescription)
            }
            
            // Fallback to password authentication
            NSOperationQueue.mainQueue().addOperationWithBlock({
            self.showLoginDialog() })
            
        } })
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(0))
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
//        let blurEffect = UIBlurEffect(style: .Dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        backgroundImageView.addSubview(blurEffectView)
        
        loginView.hidden = true
        
        authenticateWithTouchID()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoginDialog() {
        // Move the login view off screen
        loginView.hidden = false
        loginView.transform = CGAffineTransformMakeTranslation(0, -700)

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            
            self.loginView.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
    }

}
