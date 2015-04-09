//
//  TimelineTableViewController.swift
//  SwifferApp
//
//  Created by Training on 29/06/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    var timelineData:NSMutableArray! = NSMutableArray()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    @IBAction func loadData(){
        timelineData.removeAllObjects()
        
        var query = PFQuery(className:"Posts")
        query.whereKey("DisplayToday", equalTo:"Yes")
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject!, error: NSError!) -> Void in
            if (error != nil || object == nil) {
            println("The getFirstObject request failed.")
        }
        else {
            // The find succeeded.
            let ID = object["PostID"] as Int
                
                var findTimelineData:PFQuery = PFQuery(className: "Sweets")
                findTimelineData.whereKey("PostID", equalTo:ID)
                findTimelineData.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]!, error:NSError!)->Void in
                    
                    if error == nil{
                        for object in objects{
                            let sweet:PFObject = object as PFObject
                            self.timelineData.addObject(sweet)
                        }
                        
                        let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                        self.timelineData = NSMutableArray(array: array)
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }
        }
    }

        
        
        
       
    }

    override func viewDidAppear(animated: Bool) {
        self.loadData()
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return timelineData.count
    }
    

   override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SweetTableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SweetTableViewCell
    
        let sweet:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
    
    cell.sweetTextView.alpha = 0
    cell.timestampLabel.alpha = 0
    cell.usernameLabel.alpha = 0
    
        cell.sweetTextView.text = sweet.objectForKey("content") as String

    
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        cell.timestampLabel.text = dataFormatter.stringFromDate(sweet.createdAt)
        
        var findSweeter:PFQuery = PFUser.query()
    
        findSweeter.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            if error == nil{
                let user:PFUser = (objects as NSArray).lastObject as PFUser
                cell.usernameLabel.text = user.username
                
                UIView.animateWithDuration(0.5, animations: {
                        cell.sweetTextView.alpha = 1
                        cell.timestampLabel.alpha = 1
                        cell.usernameLabel.alpha = 1
                    })
            }
        }
    
//    if indexPath.row % 2 == 0 {
//    
//        cell.backgroundColor = UIColor.orangeColor()
//    
//    }
//    else{
//        
//        cell.backgroundColor = UIColor.yellowColor()
//    
//    }

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {cell.contentView.backgroundColor=UIColor.clearColor()
        
        var whiteRoundedCornerView:UIView!
        whiteRoundedCornerView=UIView(frame: CGRectMake(5,10,self.view.bounds.width-10,120))
        whiteRoundedCornerView.backgroundColor=UIColor(red: 174/255.0, green: 174/255.0, blue: 174/255.0, alpha: 1.0)
        whiteRoundedCornerView.layer.masksToBounds=false
        
        whiteRoundedCornerView.layer.shadowOpacity = 1.55;
        
        
        
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(1, 0);
        whiteRoundedCornerView.layer.shadowColor=UIColor(red: 53/255.0, green: 143/255.0, blue: 185/255.0, alpha: 1.0).CGColor
        
        
        
        whiteRoundedCornerView.layer.cornerRadius=3.0
        whiteRoundedCornerView.layer.shadowOffset=CGSizeMake(-1, -1)
        whiteRoundedCornerView.layer.shadowOpacity=0.5
        cell.contentView.addSubview(whiteRoundedCornerView)
        cell.contentView.sendSubviewToBack(whiteRoundedCornerView)
        
        
    }
}




