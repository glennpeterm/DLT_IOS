//
//  CreateClassViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var artDoneBool = Bool()
var CreateClasstopicOptionString = NSString()
var CreateClassclassTypeOptionString = NSString()
var createClassDescriptionString = NSString()
var CreateClassOtherTxtString  = NSString()
var createClassBool = Bool()
class CreateClassViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var descriptionOption: UILabel!
    @IBOutlet var topicOption: UILabel!
    @IBOutlet var classTypeoption: UILabel!
    
    var instructorBool = Bool()
    var blendedBool = Bool()
    var selfpacedBool = Bool()
    
  
    var classTypeID = Int()
   
    
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var descriptionTxtView: UITextView!
   
    @IBOutlet var titleTxtField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        //descriptionTxtView.delegate = self
    
        
        titleTxtField.delegate = self
        
        saveBtn.layer.borderWidth = 1.5
        saveBtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor
        
        CreateClasstopicOptionString = ""
        CreateClassclassTypeOptionString = ""
        createClassDescriptionString = ""
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        //(createClassDescriptionString)
        if createClassDescriptionBool == true
        {
            descriptionOption.text = createClassDescriptionString as String
        }
        
        else
        {
            descriptionOption.text = ""
        }
        if createClassclassTypeCheckBool == true
        {
             classTypeoption.text =  CreateClassclassTypeOptionString as String
            
            if classTypeoption.text == "Instructor"
            {
                classTypeID = 1
            }
            
            else if classTypeoption.text == "Blended"
            {
                classTypeID = 2
                
            }
            
            else
            
            {
                classTypeID = 3
            }
        }
        
        else
        
        {
            classTypeoption.text = ""
        }
        
        
        if CreatetopicCheckBool == true
        {
            topicOption.text = CreateClasstopicOptionString as String
            
        }
        
        else
        
        {
            topicOption.text = ""
        }
        
        
    }
    
    //MARK:- Topic Button
    
    @IBAction func topicBtn(sender: AnyObject)
    {
        let topic = storyboard?.instantiateViewControllerWithIdentifier("topic") as! TopicViewController
        createClassBool = true
        self.navigationController?.pushViewController(topic, animated: true)
    }
    
    //MARK:- Description Button
    
    
    @IBAction func descriptionBtn(sender: AnyObject)
    {
        let Desc = storyboard?.instantiateViewControllerWithIdentifier("Desc") as! CreateClassDescriptionViewController
        createClassBool = true
        self.navigationController?.pushViewController(Desc, animated: true)
    }
    
    //MARK:- ClassType Button
    
    
    @IBAction func classTypeBtn(sender: AnyObject)
    {
        let classType = storyboard?.instantiateViewControllerWithIdentifier("classType") as! ClassTypeViewController
        createClassBool = true
        self.navigationController?.pushViewController(classType, animated: true)
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

        //descriptionTxtView.resignFirstResponder()
       
    }
    
    
    //MARK:- Back Button
    
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    
     
    
    //MARK:- Create Class Api
    
    
    
    func createCLassApi()
        
    {
        
        if titleTxtField.text == "" || classTypeoption.text == "" || topicOption.text == "" || descriptionOption.text == ""
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
                let topicID = NSUserDefaults.standardUserDefaults().valueForKey("topicID") as! String
                
                //(topicID)
                
                
                let classTypeIDStr = String(classTypeID) as String
                
                let memschID = NSUserDefaults.standardUserDefaults().valueForKey("loginapiMemSchId") as! String
                let userID = NSUserDefaults.standardUserDefaults().valueForKey("loginapiSchMemId") as! String
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                let post = NSString(format:"userid=%@&memschid=%@&classname=%@&style=%@&topic=%@&desc=%@&othertopicdata=%@",userID,memschID,titleTxtField.text!, classTypeIDStr ,topicID, createClassDescriptionString,CreateClassOtherTxtString)
                
                print(post)
                
                var dataModel = NSData()
                
               
                    let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!
                    
                    
                    let postLength = String(dataModel.length)
                    
                    let url = NSURL(string:"http://digitallearningtree.com/digitalapi/create_class.php?")
                    
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
                                        
                                        let classListView = self.storyboard?.instantiateViewControllerWithIdentifier("classListView") as! ClassListingViewController
                                        self.navigationController?.pushViewController(classListView, animated: false)
                                        
                                        spinningIndicator.hide(true)
                                        
                                        
                                    }
                                    else
                                        
                                    {
                                        
                                        let alert = UIAlertView(title: "Alert", message: "Data Missing", delegate: self, cancelButtonTitle: "OK")
                                        
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
                    
                //}
                

                }
            
        }
        }
    
    
   //MARK:- Save Button
    
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        createCLassApi()
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



