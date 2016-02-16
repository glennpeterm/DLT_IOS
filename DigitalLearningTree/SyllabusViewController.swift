//
//  SyllabusViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class SyllabusViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate
{
    
    var editSyllabusArray = NSArray()
    var syllabusId = NSString()
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var descriptionTxtfield: RichTextEditor!
    @IBOutlet var titleTxtField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getSyllabus()
        self.navigationController?.navigationBarHidden = false
        
        descriptionTxtfield.delegate = self
        
        titleTxtField.delegate = self
        
        
        
        
        descriptionTxtfield.layer.borderWidth = 0.5
        descriptionTxtfield.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionTxtfield.layer.cornerRadius = 3
        
        
        saveBtn.layer.borderWidth = 1.5
        saveBtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
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
        titleTxtField.resignFirstResponder()
        descriptionTxtfield.resignFirstResponder()
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
        if textView == descriptionTxtfield
        {
            UIView.animateWithDuration(0.2, animations: {
                
                
                
                self.view.frame.origin.y -= self.view.frame.height/6
            })
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        
        if textView.text == "Description"
        {
            textView.text = ""
        }
        
        textView.textColor = UIColor.blackColor()
        
    }
    
    
    
    
    
    
    func textViewDidEndEditing(textView: UITextView)
    {
        
        if textView == descriptionTxtfield
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/6
            })
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        
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
    
    //MARK:- Delete Button
    
    @IBAction func deleteBtn(sender: AnyObject)
    {
        deleteSyllabusApi()
    }
    
    
    //MARK:- Save Button
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        addSyllabusApi()
        
    }
    
    // MARK:- Add Syllabus Api
    
    
    func addSyllabusApi()
    {
        
        
        
        if titleTxtField.text == ""
        {
            let alertFillRequired = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alertFillRequired.show()
            
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
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                var post = NSString()
                if saveBtn.titleLabel?.text == "Update"
                {
                    post = NSString(format:"cid=%@&userid=%@&title=%@&desc=%@&sy_id=%@",cla_classid_eid,cls_createdby_userID,titleTxtField.text!,descriptionTxtfield.text!,syllabusId)
                    
                }
                    
                else
                {
                    
                    post = NSString(format:"cid=%@&userid=%@&title=%@&desc=%@",cla_classid_eid,cls_createdby_userID,titleTxtField.text!,descriptionTxtfield.text!)
                    
                }
                
                //(post)
                
                var dataModel = NSData()
                
                dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/cls_syllabus.php")
                
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
                                let message = jsonResults?.valueForKey("data") as? String
                                
                                if success
                                {
                                    for controller in self.navigationController!.viewControllers as Array
                                    {
                                        if controller.isKindOfClass(ClassListingViewController)
                                        {
                                            self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                                            break
                                        }
                                    }
                                    
                                    
                                    CNDSyllabusOptionStr = self.titleTxtField.text!
                                    CNDSyllabusOptionBool = true
                                    
                                    spinningIndicator.hide(true)
                                    
                                    
                                    
                                }
                                else
                                    
                                {
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
    
    
    // MARK:- Get Syllabus Api
    
    
    func getSyllabus()
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
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"clsid=%@&userid=%@",cla_classid_eid,cls_createdby_userID)
            
            
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/cls_syllabus.php")
            
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
                                
                                self.editSyllabusArray = jsonResults?.valueForKey("data") as! NSArray
                                
                                self.titleTxtField.text = ""
                                
                                if let title = self.editSyllabusArray[0].valueForKey("title") as? String
                                {
                                    self.titleTxtField.text = title
                                    self.deleteBtn.hidden = false
                                    
                                    self.saveBtn.setTitle("Update", forState: UIControlState.Normal)
                                }
                                
                                self.descriptionTxtfield.text = ""
                                
                                if let syllabus = self.editSyllabusArray[0].valueForKey("syllabus") as? String
                                {
                                    self.deleteBtn.hidden = false
                                    
                                    self.saveBtn.setTitle("Update", forState: UIControlState.Normal)
                                    
                                    let encodedData = syllabus.dataUsingEncoding(NSUTF8StringEncoding)!
                                    
                                    let attributedOptions : [String: AnyObject] =
                                    [
                                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                                    ]
                                    
                                    do
                                    {
                                        
                                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                                        
                                        
                                        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                                        
                                        self.descriptionTxtfield.text  = decodedString
                                        
                                        //(decodeStr)
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }
                                    
                                    
                                    if self.descriptionTxtfield.text != "Description"
                                    {
                                        self.descriptionTxtfield.textColor = UIColor.blackColor()
                                    }
                                    
                                    ////(self.descriptionTxtfield.attributedText)
                                }
                                
                                self.syllabusId = ""
                                
                                if let syid = self.editSyllabusArray[0].valueForKey("sy_id") as? String
                                    
                                {
                                    self.syllabusId = syid
                                }
                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                let alert = UIAlertView(title: "Alert", message: "No Data", delegate: self, cancelButtonTitle: "OK")
                                
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
    
    
    
    // MARK:- Delete Syllabus Api
    
    
    func deleteSyllabusApi()
    {
        
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
            
        }
            
        else
            
        {
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"sydid=%@",syllabusId)
            
            
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/cls_syllabus.php")
            
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
                                
                                let data = jsonResults?.valueForKey("data") as! String
                                let alert = UIAlertView(title: "Alert", message: data, delegate: self, cancelButtonTitle: "OK")
                                CNDSyllabusOptionStr = self.titleTxtField.text!
                                CNDSyllabusOptionBool = true
                                self.titleTxtField.text = ""
                                self.descriptionTxtfield.text = ""
                                
                                alert.show()
                                
                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                let alert = UIAlertView(title: "Alert", message: "No Data", delegate: self, cancelButtonTitle: "OK")
                                
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
