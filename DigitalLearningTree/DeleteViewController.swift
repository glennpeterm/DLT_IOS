//
//  DeleteViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController,UITextFieldDelegate
{
    var kbHeight: CGFloat!
    
    @IBOutlet var zoomScrollView: UIScrollView!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var deletebtn: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var changePictureBtn: UIButton!
    @IBOutlet var EditBtn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false

        // imageView.image = ClassListAndChangeImage
        
        let imageData = NSUserDefaults.standardUserDefaults().objectForKey("ClassListAndChangeImage") as! NSData
        
        imageView.image = UIImage(data: imageData)

        passwordTextField.delegate = self
        
        deletebtn.layer.borderWidth = 1.5
        deletebtn.layer.borderColor = UIColor.redColor().CGColor
        
        EditBtn.layer.borderWidth = 0.5
        EditBtn.layer.borderColor = UIColor.whiteColor().CGColor
        EditBtn.layer.cornerRadius = 3
        
        changePictureBtn.layer.borderWidth = 0.5
        changePictureBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        deleteBtn.layer.borderWidth = 0.5
        deleteBtn.layer.borderColor = UIColor.whiteColor().CGColor
        deleteBtn.layer.cornerRadius = 3
        
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.lightGrayColor().CGColor

       
    }
    
    override func viewWillAppear(animated:Bool)
    {
        super.viewWillAppear(animated)
        
      
    }
    override func viewDidDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
       
        
        
        
        
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
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        
        if textField == passwordTextField
        {
            UIView.animateWithDuration(0.2, animations: {
                
                
                
                self.view.frame.origin.y -= self.view.frame.height/2.5
            })
         
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
        if textField == passwordTextField
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/2.5
            })
            
            
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        
    }

    
    
    //MARK:- TouchEvent Method
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        passwordTextField.resignFirstResponder()
        
    }
    
    
    
    
    
    
    //MARK:- EDIT CHANGE PICTURE BUTTON
    
    @IBAction func editBtn(sender: AnyObject)
    {
        let editView = storyboard?.instantiateViewControllerWithIdentifier("editView") as! EditClassViewController
        
        self.navigationController?.pushViewController(editView, animated: false)
        
    }
    
    @IBAction func changePictureBtn(sender: AnyObject)
    {
        let changePicture = storyboard?.instantiateViewControllerWithIdentifier("changePicture") as! ChangePictureViewController
        
        self.navigationController?.pushViewController(changePicture, animated: false)
    }
    
    
    
    
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    
    {
        if backfromEditDeleteChngePicBool == true
        {
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(ClassNameAndDetailViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
            
        }
            
        else
        {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(ClassListingViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
        }
    }
    
    
    //MARK:- Delete Class Api
    
    
    func deleteClassApi()
    {
        
        if passwordTextField.text == ""
        {
            let alert = UIAlertView(title: "Alert", message: "Please Enter your Password", delegate: self, cancelButtonTitle: "OK")
            
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
            
            let post = NSString(format:"cid=%@&userid=%@&schid=%@&password=%@",cla_classid_eid,cls_createdby_userID,schID,passwordTextField.text!)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_delete.php")
            
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
                        //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                
                                let isDeleted = ModelManager.getInstance().deleteClassData(cla_classid_eid)
                                if isDeleted
                                {
                                    //   GetFilePath.invokeAlertMethod("", strBody: "Record deleted successfully.", delegate: nil)
                                } else {
                                    // GetFilePath.invokeAlertMethod("", strBody: "Error in deleting record.", delegate: nil)
                                }

                                
                                let classListView = self.storyboard?.instantiateViewControllerWithIdentifier("classListView") as! ClassListingViewController
                                
                                self.navigationController?.pushViewController(classListView, animated: false)
                                spinningIndicator.hide(true)
                                
                                
                            }
                            else
                                
                            {
                                let message = jsonResults?.valueForKey("data") as! String
                                
                                let alert = UIAlertView(title: "Alert", message: message, delegate: self, cancelButtonTitle: "OK")
                                
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
    
    //MARK:- Delete Button
    
    @IBAction func deletebtn(sender: AnyObject)
    {
        deleteClassApi()
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
