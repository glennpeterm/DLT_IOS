//
//  ViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/5/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate,UIAlertViewDelegate
{
    @IBOutlet var checkUncheckBtn: UIButton!
    
    @IBOutlet var logoImageView: UIImageView!
     var kbHeight: CGFloat!
    
    var dropDownKeypad = Int()
    var imageLogo = UIImage()
    
    var StudentAndTeacherLoginBool = Bool()
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var schoolName: UILabel!
    var checkUnckeckBool = Bool()
    @IBOutlet var pwdImage: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var pwdTxtField: UITextField!
    @IBOutlet var userNameTxtField: UITextField!
    
    override func viewDidLoad()
    {
        dropDownKeypad = 1
        super.viewDidLoad()
        
        
        let imageData = NSUserDefaults.standardUserDefaults().objectForKey("image") as! NSData
        
        logoImageView.image = UIImage(data: imageData)
        
        schoolName.text = NSUserDefaults.standardUserDefaults().valueForKey("schoolsName") as? String
        
        checkUnckeckBool = true
        
        pwdTxtField.delegate = self
        userNameTxtField.delegate = self
        
        userNameTxtField.layer.borderColor = UIColor(red: 55/255.0, green: 54/255.0, blue: 54/255.0, alpha: 1.0).CGColor
        userNameTxtField.layer.borderWidth = 0.5
        
        pwdTxtField.layer.borderColor = UIColor(red: 55/255.0, green: 54/255.0, blue: 54/255.0, alpha: 1.0).CGColor
        pwdTxtField.layer.borderWidth = 0.5
        
        let paddingViewpwd = UIView(frame: CGRectMake(0, 0, pwdImage.frame.size.width+5, pwdTxtField.frame.size.height))
        pwdTxtField.leftView = paddingViewpwd
        pwdTxtField.leftViewMode = UITextFieldViewMode.Always
        
        let paddingViewUserName = UIView(frame: CGRectMake(0, 0, userImage.frame.size.width+5, userNameTxtField.frame.size.height))
        userNameTxtField.leftView = paddingViewUserName
        userNameTxtField.leftViewMode = UITextFieldViewMode.Always
        
        if StudentAndTeacherLoginBool == true
        {
            self.navigationItem.title = "Teacher Login"
        }
        
        else
        
        {
            self.navigationItem.title = "Student Login"
        }
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(animated: Bool)
    {
//        let arrayMTClassList = NSMutableArray()
//         NSUserDefaults.standardUserDefaults().setObject(arrayMTClassList, forKey: "arrayTClassList")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
    }
    //MARK:- TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
       
        if textField == userNameTxtField || textField == pwdTxtField
        {
            UIView.animateWithDuration(0.2, animations: {
                
                
                
                self.view.frame.origin.y -= self.view.frame.height/3
            })
            
            dropDownKeypad = 2
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
       
        if textField == userNameTxtField || textField == pwdTxtField
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/3
            })
            
            dropDownKeypad = 1
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        
    }

    
    //MARK:- Touch Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        userNameTxtField.resignFirstResponder()
        pwdTxtField.resignFirstResponder()
        
    }
    
    //MARK:- AlertView Delegate
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 0
        {
            if dropDownKeypad == 3
            {
                UIView.animateWithDuration(0.2, animations: {
                    self.view.frame.origin.y -= self.view.frame.height/3
                })
                
                dropDownKeypad = 2
            }
            
        }
        
    }
    
    //MARK:- Login Button
    
    @IBAction func loginBtn(sender: AnyObject)
    {
        
        
       if dropDownKeypad == 2
       {
        UIView.animateWithDuration(0.2, animations: {
            self.view.frame.origin.y += self.view.frame.height/3
        })

          dropDownKeypad = 3
        
        }
        
        
        
        if userNameTxtField.text == "" || pwdTxtField.text == ""
        {
            
            
            let alert = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
            
        else if userNameTxtField.text?.lowercaseString != userNameTxtField.text
            
        {
            let alert = UIAlertView(title: "Alert", message: "username or password invalid", delegate: self, cancelButtonTitle: "OK")
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
                
                if StudentAndTeacherLoginBool == true
                
                
                {
                let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
                
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                let post = NSString(format:"username=%@&password=%@&logid=%@",userNameTxtField.text!,pwdTxtField.text!, schID)
                
                //(post)
                
                var dataModel = NSData()
                
                dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/login.php")
                
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
                        
                        //("\(error?.localizedDescription)")
                        dispatch_async(dispatch_get_main_queue(),
                            
                            
                            {
                                let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                            spinningIndicator.hide(true)
                        })
                    }
                        
                    else
                    {
                        
                        //let error:NSError?
                        
                        var jsonResults : NSDictionary?
                        
                        
                        do
                        {
                            jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            
                            // success ...
                            print(jsonResults)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                
                                
                                let success = jsonResults?.valueForKey("success") as! Bool
                                
                                if success
                                {
                                    
                                let user_type = jsonResults?.valueForKey("user_type") as! String

                                    if user_type == "Teacher"
                                        
                                    {

                                    self.userNameTxtField.resignFirstResponder()
                                    self.pwdTxtField.resignFirstResponder()
                                    
                                    spinningIndicator.hide(true)
                                    
                                    if self.checkUnckeckBool == false
                                    {
                                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Login")
                                        
                                    }
                                    
                                    let arr = jsonResults?.valueForKey("Mem_Name") as! String
                                    //(arr)
                                    
                                    NSUserDefaults.standardUserDefaults().setValue(arr, forKey: "Mem_NameTeacher")
                                    let classListing = self.storyboard!.instantiateViewControllerWithIdentifier("classListView") as! ClassListingViewController
                                    NSUserDefaults.standardUserDefaults().setValue(self.userNameTxtField.text, forKey: "Username")
                                    NSUserDefaults.standardUserDefaults().setValue(self.pwdTxtField.text, forKey: "Password")
                                    
                            
        
                                    self.navigationController?.pushViewController(classListing, animated: true)
                                    
                                    
                                    
                                }
                                    
                                    
                                    else
                                    {
                                        
                                        
                                        let alert = UIAlertView(title: "Alert", message: "Invalid Credentials", delegate: self, cancelButtonTitle: "OK")
                                        alert.show()
                                        
                                        spinningIndicator.hide(true)
                                    }

                                }
                                else
                                    
                                {
                                    
                                    let alert = UIAlertView(title: "Alert", message: "Username or Password Invalid", delegate: self, cancelButtonTitle: "OK")
                                    
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
                
                
                
                else
                {
                    let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
                    
                    
                    let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    spinningIndicator.labelText = "Loading"
                    
                    let post = NSString(format:"username=%@&password=%@&logid=%@",userNameTxtField.text!,pwdTxtField.text!, schID)
                    
                    //(post)
                    
                    var dataModel = NSData()
                    
                    dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
                    
                    let postLength = String(dataModel.length)
                    
                    let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_students.php")
                    
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
                            
                            //("\(error?.localizedDescription)")
                            dispatch_async(dispatch_get_main_queue(),
                                
                                
                                {
                                    let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                                    
                                    alert.show()
                                    spinningIndicator.hide(true)
                            })
                        }
                            
                        else
                        {
                            
                            //let error:NSError?
                            
                            var jsonResults : NSDictionary?
                            
                            
                            do
                            {
                                jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                                
                                // success ...
                                print(jsonResults)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    let success = jsonResults?.valueForKey("success") as! Bool
                                    
                                    if success
                                    {
                                        let user_type = jsonResults?.valueForKey("user_type") as! String
                                        if user_type == "Student"
                                        {

                                        self.userNameTxtField.resignFirstResponder()
                                        self.pwdTxtField.resignFirstResponder()
                                        
                                        spinningIndicator.hide(true)
                                        
                                        if self.checkUnckeckBool == false
                                        {
                                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "StudentLogin")
                                        }
                                        
                                        let arr = jsonResults?.valueForKey("Mem_Name") as! String
                                        //(arr)
                                        
                                        NSUserDefaults.standardUserDefaults().setValue(arr, forKey: "Mem_Name")
                                        let storyBoardStudent = UIStoryboard(name: "Student", bundle: nil)
                                        
                                        let studentClassListView = storyBoardStudent.instantiateViewControllerWithIdentifier("studentClassListView") as! StudentClassViewController
                                        NSUserDefaults.standardUserDefaults().setValue(self.userNameTxtField.text, forKey: "Username")
                                        NSUserDefaults.standardUserDefaults().setValue(self.pwdTxtField.text, forKey: "Password")
                                        self.navigationController?.pushViewController(studentClassListView, animated: true)
                                        
                                        
                                        }
                                        
                                        else
                                        {
                                            let alert = UIAlertView(title: "Alert", message: "Invalid Credentials", delegate: self, cancelButtonTitle: "OK")
                                            
                                            alert.show()
                                            
                                            
                                            spinningIndicator.hide(true)
                                        }

                                        
                                    }
                                    else
                                        
                                    {
                                        
                                        let alert = UIAlertView(title: "Alert", message: "Username or Password Invalid", delegate: self, cancelButtonTitle: "OK")
                                        
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
        
    }
    
    //MARK:- CheckUnCheck Button
    
    @IBAction func checkUncheckBtn(sender: AnyObject)
    {
        if checkUnckeckBool == true
        {
            checkUncheckBtn.setBackgroundImage(UIImage(named: "check.png"), forState: UIControlState.Normal)
            
            checkUnckeckBool = false
            
        }
            
        else
        {
            checkUncheckBtn.setBackgroundImage(UIImage(named: "un-check.png"), forState: UIControlState.Normal)
            
            checkUnckeckBool = true
            
        }
        
        
    }
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        if loginbacktoschoolBool == true
        
        {
            let schoolsDetail = storyboard?.instantiateViewControllerWithIdentifier("schoolsDetail") as! SchoolsViewController
            self.navigationController?.pushViewController(schoolsDetail, animated: false)
        }
        
        else
        {
            
        self.navigationController?.popViewControllerAnimated(true)
            
        }
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
    

   
    
}

