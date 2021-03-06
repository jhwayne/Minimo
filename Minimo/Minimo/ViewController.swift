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
    @IBOutlet weak var button: UIButton!
    
    @IBAction func signOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    

    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() == nil{
            var loginAlert:UIAlertController = UIAlertController(title: "Sign Up / Login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your password"
                textfield.secureTextEntry = true
            })
            
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                PFUser.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextfield.text){
                    (user:PFUser!, error:NSError!)->Void in
                    if user != nil{
                        println("Login successfull")
                    }else{
                        println("Login failed")
                    }
                    
                    
                }
                
                
                
                
            }))
            
            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                var sweeter:PFUser = PFUser()
                sweeter.username = usernameTextfield.text
                sweeter.password = passwordTextfield.text
                
                sweeter.signUpInBackgroundWithBlock{
                    (success:Bool!, error:NSError!)->Void in
                    if error == nil{
                        println("Sign Up successfull")
                    }else{
                        let errorString = error.localizedDescription
                        println(errorString)
                    }
                    
                    
                }
                
                
                
            }))
            
            self.presentViewController(loginAlert, animated: true, completion: nil)
            

        }
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var query = PFQuery(className:"Posts")
//        query.whereKey("objectId", equalTo:"GOJfwKiCAl")
//        query.getFirstObjectInBackgroundWithBlock {
//            (object: PFObject!, error: NSError!) -> Void in
//            if error != nil || object == nil
//            {
//                println("The getFirstObject request failed.")
//            }
//            else
//            {
//                // The find succeeded.
//                self.postOfDay.text = object["content"] as NSString
//                println(object["content"])
//            }
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func circleTapped(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
