//
//  AddStudentViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/7/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController,UITextFieldDelegate
{
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!

    
    
    
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var pwdTxtField: UITextField!
    @IBOutlet var lastNameTxtField: UITextField!
    @IBOutlet var firstNameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var inviteTypeTxtField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        emailTxtField.delegate = self
        firstNameTxtField.delegate = self
        lastNameTxtField.delegate = self
        pwdTxtField.delegate = self
        
        
        saveBtn.layer.borderWidth = 1.5
        saveBtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor
        


       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- TextField Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    //MARK:- TouchEvent Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        emailTxtField.resignFirstResponder()
        firstNameTxtField.resignFirstResponder()
        lastNameTxtField.resignFirstResponder()
        pwdTxtField.resignFirstResponder()
        
       
        
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // //ln("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

   //MARK:- Back Button
   
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Zoom In Zoom Out
    
    @IBAction func zoomIn(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, animations: {
            self.zoomView.transform = CGAffineTransformScale(self.zoomView.transform, 1.25, 1.25)
            
            self.zoomScrollView.contentSize.height = self.zoomView.frame.height
            self.zoomScrollView.contentSize.width = self.zoomView.frame.width
            
            
            
            self.zoomView.frame.origin.x = 0
            self.zoomView.frame.origin.y = 0
            
        })
        
        
        //(zoomView.frame.height)
        //(zoomView.frame.width)
        
        
        
        
    }
    
    @IBAction func zoomOut(sender: AnyObject)
    {
        
        
        
        if   zoomView.frame.size.height <= self.view.frame.size.height ||  zoomView.frame.size.width <= self.view.frame.size.width
        {
            zoomView.frame.size.height = self.view.frame.size.height
            zoomView.frame.size.width = self.view.frame.size.width
            
        }
            
            
            
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.zoomView.transform = CGAffineTransformScale(self.zoomView.transform, 0.8, 0.8)
                
                self.zoomScrollView.contentSize.height = self.zoomView.frame.height
                self.zoomScrollView.contentSize.width = self.zoomView.frame.width
                
                self.zoomView.frame.origin.x = 0
                self.zoomView.frame.origin.y = 0
                
            })
            
        }
        
        //(zoomView.frame.height)
        //(zoomView.frame.width)
        
        
        
    }
    

    //MARK:- Add Student api
    
    func addStudentApi()
    {
        
        
        
        let date = NSDate()
        
        let requestedComponents: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day
        ]
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(requestedComponents, fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        
        let createdDate = "\(year)-\(month)-\(day)"
        
       
        
        
        if firstNameTxtField.text == ""  || lastNameTxtField.text == "" || pwdTxtField.text == "" || emailTxtField.text == ""
        {
            
            let alert = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
            
        else if !isValidEmail(emailTxtField.text!)
            
        {
            let alert = UIAlertView(title: "Alert", message: "Incorrect email", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else
        {
            
            if Reachability.isConnectedToNetwork() == false
            {
                let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else
            {
                
                let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
                let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
                let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                var post = NSString()
                post = NSString(format:"userid=%@&classid=%@&schid=%@&first_name=%@&last_name=%@&email=%@&password=%@&created_date=%@",cls_createdby_userID,cla_classid_eid,schID,firstNameTxtField.text!,lastNameTxtField.text!,emailTxtField.text!,pwdTxtField.text!,createdDate)
                
                //(post)
                var dataModel = NSData()
                dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/student.php")
                let urlRequest = NSMutableURLRequest(URL: url!)
                urlRequest.HTTPMethod = "POST"
                urlRequest.HTTPBody = dataModel
                urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                    
                    //(data)
                    
                    //(response)
                    
                    if (error != nil)
                    {
                        let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                        
                        alert.show()
                        //("\(error?.localizedDescription)")
                        dispatch_async(dispatch_get_main_queue(), {
                            spinningIndicator.hide(true)
                        })
                    }
                        
                    else
                    {
                        var jsonResults : NSDictionary?
                        do
                        {
                            jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            // success ...
                            //(jsonResults)
                            dispatch_async(dispatch_get_main_queue(), {
                                let success = jsonResults?.valueForKey("success") as! Bool
                                let data = jsonResults?.valueForKey("data") as! String
                                
                                if success
                                {
                                   
                                    
//                                    let alert = UIAlertView(title: "Alert", message: data, delegate: self, cancelButtonTitle: "OK")
//                                    
//                                    alert.show()
                                    
                                    self.navigationController?.popViewControllerAnimated(true)
                                    spinningIndicator.hide(true)
                                }
                                else
                                {
                                    let alert = UIAlertView(title: "Alert", message: data, delegate: self, cancelButtonTitle: "OK")
                                    alert.show()
                                    spinningIndicator.hide(true)
                                }
                            })
                            
                            
                            
                        }
                        catch
                        {
                            
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
                                    
                                    alert.show()
                                    spinningIndicator.hide(true)
                            })
                            //("Fetch failed: \((error as NSError).localizedDescription)")
                        }
                        
                        
                        
                    }
                    
                    
                })
                task.resume()
            }
            
        }

        
        
    }
    
    //MARK:- Save Button
    
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        addStudentApi()
    }

}
