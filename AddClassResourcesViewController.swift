//
//  AddClassResourcesViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class AddClassResourcesViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    var resourceArray = NSArray()

    @IBOutlet var zoomView: UIView!
   
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var descriptionTxtview: UITextView!
    @IBOutlet var titleTxtfield: UITextField!
    
    var resourceIdStr = NSString()
    var showEditResourceBool = Bool()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if showEditResourceBool == true
        {
            Getresourcedatabeforeedit ()
            descriptionTxtview.textColor = UIColor.blackColor()
            
        }
        
        descriptionTxtview.delegate = self
        
        titleTxtfield.delegate = self 
       
        
        descriptionTxtview.layer.borderWidth = 0.5
        descriptionTxtview.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        descriptionTxtview.layer.cornerRadius = 3
        
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
        titleTxtfield.resignFirstResponder()
        descriptionTxtview.resignFirstResponder()
        
    }

    //MARK:- TextView Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.text == "Description"
        {
            textView.text = ""
        }
       
        textView.textColor = UIColor.blackColor()
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView)
    {
        
        if textView.text == ""
        {
            textView.text = "Description"
        }
        
        
        if textView.text ==  "Description"
        {
            textView.textColor = UIColor.lightGrayColor()
        }
            
        else
            
        {
            textView.textColor = UIColor.blackColor()
        }

    }

    //MARK:- Back Button
    
    
    @IBAction func backbtn(sender: AnyObject)
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
    
    //MARK:- Add Resource Api
    
    
    
    func addResourceApi()
        
    {
        
        if titleTxtfield.text == ""  || descriptionTxtview.text == "" || descriptionTxtview.text == "Description"
        {
            
            let alert = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
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
                
               // //(descriptionTxtview.attributedText)
//                
//                 let str = descriptionTxtview.valueForKey("Hello")
//                //(str)
                
                
                let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
                let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
                let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
                
               
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                var post = NSString()
                
                
                if saveBtn.titleLabel?.text == "Update"
                {
                    post = NSString(format:"userid=%@&cid=%@&title=%@&desc=%@&schid=%@&res_id=%@",cls_createdby_userID,cla_classid_eid,titleTxtfield.text!, descriptionTxtview.text!,schID,resourceIdStr)
                }
                    
                else
                {
                    
                    post = NSString(format:"userid=%@&cid=%@&title=%@&desc=%@&schid=%@",cls_createdby_userID,cla_classid_eid,titleTxtfield.text!, descriptionTxtview.text!,schID)
                }
                
                
                
                print(post)
                
                var dataModel = NSData()
                
                let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/resource.php")
                
                
                
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
                            print(jsonResults)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                
                                
                                
                                let success = jsonResults?.valueForKey("success") as! Bool
                                let data = jsonResults?.valueForKey("data") as! String
                                
                                if success
                                {
                                    resourceListApiBool = true
                                    
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

    
    //MARK:- Get resource data before edit 
    
    func Getresourcedatabeforeedit ()
    {
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"userid=%@&edit_res_id=%@",cls_createdby_userID,resourceIdStr)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/resource.php")
            
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
                            
                            
                            if success
                            {
                                self.saveBtn.setTitle("Update", forState: .Normal)
                                
                                self.resourceArray = jsonResults?.valueForKey("data") as! NSArray
                                
                                
                                self.titleTxtfield.text = ""
                                
                                if let tit = self.resourceArray[0].valueForKey("title")
                                {
                                    self.titleTxtfield.text = tit as? String
                                }
                                
                                self.descriptionTxtview.text = ""
                                
                                if  let desc = self.resourceArray[0].valueForKey("desc")
                                {
                                    self.descriptionTxtview.text = desc as? String
                                }
                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message: "No data", delegate: self, cancelButtonTitle: "OK")
                                
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

    //MARK:- Save Button
    
    @IBAction func savebtn(sender: AnyObject)
    {
      addResourceApi()
    }
    
    
    //MARK:- PreView Button
    
    @IBAction func preViewBtn(sender: AnyObject)
    {
        if titleTxtfield.text == ""  || descriptionTxtview.text == "" || descriptionTxtview.text == "Description"
        {
            
            let alert = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
            
        else
            
        {
            
            let viewClassResource = storyboard?.instantiateViewControllerWithIdentifier("viewClassResource") as! ViewClassResourceViewController
            
            viewClassResource.decStr = descriptionTxtview.text
            viewClassResource.titleNavigation = titleTxtfield.text!
            
            self.navigationController?.pushViewController(viewClassResource, animated: true)

            
        }
        

        
    }
    
    
}
