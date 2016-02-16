//
//  AddCurriculumViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/25/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var addCurrciculumBool = Bool()
var addCurriculumTopicStr = NSString()
var addCurriculumDescriptionStr = NSString()
var addCurriculumLibraryStr = NSString()

var addCurriculumGradeFromStr = NSString()
var addCurriculumGradeToStr = NSString()

var addCurriculumCountryStr = NSString()

var countryIndex = NSString()
var lo_ageIndex = NSString()
var hig_ageIndex = NSString()

var CurriculumDataShowTopicBool = Bool()
var CurriculumDataShowCountryBool = Bool()
var CurriculumDataShowDescriptionBool = Bool()
var CurriculumDataShowLibraryBool = Bool()
var CurriculumDataShowGradeFromBool = Bool()
var CurriculumDataShowGradeToBool = Bool()

class AddCurriculumViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet var deleteBtn: UIButton!
    var countryArray = NSMutableArray()
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var gradeToOption: UILabel!
    @IBOutlet var gradeFromOption: UILabel!
    @IBOutlet var libraryOption: UILabel!
    @IBOutlet var descriptionOption: UILabel!
    @IBOutlet var countryoption: UILabel!
    @IBOutlet var topicOption: UILabel!
    @IBOutlet var stateTxtField: UITextField!
    @IBOutlet var organiztionalTxtField: UITextField!
    @IBOutlet var titleTxtField: UITextField!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    
    var currId = NSString()
    
    var libraryCount = NSString()
    
    var curriculumData = NSArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        countryApi()
        
        
        CurriculumDataShowTopicBool = true
        CurriculumDataShowCountryBool = true
        CurriculumDataShowDescriptionBool = true
        CurriculumDataShowLibraryBool = true
        CurriculumDataShowGradeFromBool = true
        CurriculumDataShowGradeToBool = true
        
        scrollView.contentSize.height = saveBtn.frame.origin.y + saveBtn.frame.size.height + 10
        
        titleTxtField.delegate = self
        stateTxtField.delegate = self
        organiztionalTxtField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if CurriculumDataShowTopicBool == false
        {
        
        if addCurriculumTopicCheckBool == true
        {
            topicOption.text = addCurriculumTopicStr as String
        }
            
        else
            
        {
            topicOption.text = ""
        }
        }
        
        if CurriculumDataShowDescriptionBool == false
        
        {
        
        
        if addCurriculumDescriptionBool == true
        {
            descriptionOption.text = addCurriculumDescriptionStr as String
        }
            
        else
        {
            descriptionOption.text = ""
        }
            
        }
        
        if CurriculumDataShowLibraryBool == false
        
        {
        
        if addCurriculumLibraryBool == true
        {
            libraryOption.text = addCurriculumLibraryStr as String
        }
            
        else
        {
            libraryOption.text = ""
        }
            
        }
        
        
        
        if CurriculumDataShowGradeFromBool == false
        {
        
        if gradeFromBool == true
        {
            gradeFromOption.text = addCurriculumGradeFromStr as String
        }
            
        else
            
        {
            gradeFromOption.text = ""
        }
        }
        
        
        
        if CurriculumDataShowGradeToBool == false
        
        {
        
        if gradeToBool == true
        {
            gradeToOption.text = addCurriculumGradeToStr as String
            
        }
            
        else
            
        {
            gradeToOption.text = ""
        }
            
        }
        
        
        if CurriculumDataShowCountryBool == false
        
        {
        
        if addCurriculumCountryBool == true
        {
            countryoption.text = addCurriculumCountryStr as String
        }
            
        else
            
        {
            countryoption.text = ""
            
        }
           
        }
        
    }
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    //MARK:- Save button
    
    @IBAction func savebtn(sender: AnyObject)
    {
        addCurriculumApi()
    }
    
    //MARK:- Description Button
    
    @IBAction func descriptionBtn(sender: AnyObject)
    {
        let Desc = storyboard?.instantiateViewControllerWithIdentifier("Desc") as! CreateClassDescriptionViewController
        Desc.showCurriculumDescriptionStr = descriptionOption.text!
        addCurrciculumBool = true
        self.navigationController?.pushViewController(Desc, animated: true)
    }
    
    
    
    //MARK:- Topic Button
    
    @IBAction func topicBtn(sender: AnyObject)
    {
        let topic = storyboard?.instantiateViewControllerWithIdentifier("topic") as! TopicViewController
        addCurrciculumBool = true
        
        if topicOption.text != ""
        {
           topic.checkTopicOption = topicOption.text!
           topic.checkTopicOptionBool = true
        }
        self.navigationController?.pushViewController(topic, animated: true)
    }
    
    //MARK:- Grade Button
    
    @IBAction func gradeFromBtn(sender: AnyObject)
    {
        let gradeCurriCUlum = storyboard?.instantiateViewControllerWithIdentifier("gradeCurriCUlum") as! AddCuuriculumGradeViewController
        
        gradeCurriCUlum.gradeBool = true
        
        self.navigationController?.pushViewController(gradeCurriCUlum, animated: true)
    }
    
    
    @IBAction func gradeToBtn(sender: AnyObject)
    {
        let gradeCurriCUlum = storyboard?.instantiateViewControllerWithIdentifier("gradeCurriCUlum") as! AddCuuriculumGradeViewController
        
        gradeCurriCUlum.gradeBool = false
        
        self.navigationController?.pushViewController(gradeCurriCUlum, animated: true)
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
        stateTxtField.resignFirstResponder()
        organiztionalTxtField.resignFirstResponder()
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
    
    
    //MARK:- Add Curriculum Api
    
    func  addCurriculumApi()
    {
        
        if titleTxtField.text == "" || libraryOption.text == "" || topicOption.text == "" || gradeFromOption.text == "" || gradeToOption.text == "" || descriptionOption.text == ""
            
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
                
                if libraryOption.text == "Personal"
                {
                    libraryCount = "1"
                }
                
                if libraryOption.text == "School"
                {
                    libraryCount = "2"
                }
                
                if libraryOption.text == "Community"
                {
                    libraryCount = "3"
                }
                
                
                
                
                let topicID = NSUserDefaults.standardUserDefaults().valueForKey("addCurriculumtopicID") as! String
                
                
                
                
                //(topicID)
                //(lo_ageIndex)
                //(hig_ageIndex)
                
                
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
                let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
                
                var urlRequest = NSMutableURLRequest()
                
                if saveBtn.titleLabel?.text == "Update"
                {
                    let post = NSString(format:"cid=%@&userid=%@&title=%@&topic=%@&desc=%@&library=%@&lo_age=%@&hi_age=%@&organization=%@&country=%@&state=%@&curr_edit_id=%@",cla_classid_eid,cls_createdby_userID,titleTxtField.text!, topicID ,descriptionOption.text!, libraryCount,lo_ageIndex,hig_ageIndex,organiztionalTxtField.text!,countryIndex,stateTxtField.text!,currId)
                    
                    //(post)
                    
                    var dataModel = NSData()
                    
                    let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                    
                    
                    let postLength = String(dataModel.length)
                    
                    let url = NSURL(string:"http://digitallearningtree.com/digitalapi/curriculum_add.php")
                    
                    urlRequest = NSMutableURLRequest(URL: url!)
                    
                    urlRequest.HTTPMethod = "POST"
                    urlRequest.HTTPBody = dataModel
                    urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
                    
                }
                
                else
                
                {
                
                let post = NSString(format:"cid=%@&userid=%@&title=%@&topic=%@&desc=%@&library=%@&lo_age=%@&hi_age=%@&organization=%@&country=%@&state=%@",cla_classid_eid,cls_createdby_userID,titleTxtField.text!, topicID ,descriptionOption.text!, libraryCount,lo_ageIndex,hig_ageIndex,organiztionalTxtField.text!,countryIndex,stateTxtField.text!)
                
                //(post)
                
                var dataModel = NSData()
                
                let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/curriculum_add.php")
                
                 urlRequest = NSMutableURLRequest(URL: url!)
                
                urlRequest.HTTPMethod = "POST"
                urlRequest.HTTPBody = dataModel
                urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
                
                }
                
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
                                    
                                    for controller in self.navigationController!.viewControllers as Array
                                    {
                                        if controller.isKindOfClass(ClassListingViewController)
                                        {
                                            self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                                            break
                                        }
                                    }

                                    CNDCurriculumOptionStr = self.titleTxtField.text!
                                    CNDCurriculumOptionBool = true
                                    
                                    spinningIndicator.hide(true)
                                    
                                    
                                    
                                }
                                else
                                    
                                {
                                    
                                    
                                    let alert = UIAlertView(title: "Alert", message:data, delegate: self, cancelButtonTitle: "OK")
                                    
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
    
    
    //MARK:- Show Curriculum Data Api
    
    func showCurriculumData()
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
            
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            let post = NSString(format:"classid=%@&userid=%@",cla_classid_eid,cls_createdby_userID)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/curriculum_add.php")
            
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
                        
                        
                        //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            
                            if success
                            {
                                self.deleteBtn.hidden = false
                                
                                self.scrollView.contentSize.height = self.deleteBtn.frame.origin.y + self.deleteBtn.frame.size.height + 10
                                
                                self.saveBtn.setTitle("Update", forState: .Normal)
                                
                                self.curriculumData = jsonResults?.valueForKey("data") as! NSArray
                                
                                self.titleTxtField.text = ""
                                
                                if let title = self.curriculumData[0].valueForKey("title")
                                {
                                    self.titleTxtField.text = title as? String
                                }
                                
                                self.stateTxtField.text = ""
                                if let state = self.curriculumData[0].valueForKey("state")
                                {
                                        self.stateTxtField.text = state as? String
                                }
                                
                                self.descriptionOption.text = ""
                                
                                if let desc = self.curriculumData[0].valueForKey("desc")
                                {
                                    
                                    
                                    let encodedData = desc.dataUsingEncoding(NSUTF8StringEncoding)!
                                    
                                    let attributedOptions : [String: AnyObject] =
                                    [
                                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                                    ]
                                    
                                    do
                                    {
                                        
                                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                                        
                                        
                                        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                                        
                                        self.descriptionOption.text  = decodedString
                                        
                                        //(decodeStr)
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }
                                    

                                }
                                
                                self.countryoption.text = ""
                                
                                if let country = self.curriculumData[0].valueForKey("country")
                                
                                {
                                    countryIndex = country as! String
                                    let index = (country).integerValue
                                    
                                    //(index)
                                    
                                    self.countryoption.text = self.countryArray[index] as? String
                                    
                                }
                                
                                self.libraryOption.text = ""
                                
                                if let library = self.curriculumData[0].valueForKey("library")
                                {
                                    self.libraryCount = library as! NSString
                                    
                                    if  self.libraryCount as String == "1"
                                    {
                                        self.libraryOption.text = "Personal"
                                    }
                                    
                                    if  self.libraryCount as String == "2"
                                    {
                                        self.libraryOption.text = "School"
                                    }
                                    
                                    if  self.libraryCount as String == "3"
                                    {
                                        self.libraryOption.text = "Community"
                                    }
                                }
                                
                                let gradeArray:NSArray = ["Other","K","1","2","3","4","5","6","7","8","9","10","11","12","HigherEd"]
                                
                                
                                self.gradeFromOption.text = ""
                                
                                if let lo_age = self.curriculumData[0].valueForKey("lo_age")
                                {
                                    lo_ageIndex = lo_age as! String
                                    
                                    let index = (lo_age).integerValue
                                    
                                    self.gradeFromOption.text = gradeArray[index] as? String
                                    
                                }
                                
                                self.gradeToOption.text = ""
                                
                                if let hi_age = self.curriculumData[0].valueForKey("hi_age")
                                {
                                    hig_ageIndex = hi_age as! String
                                    let index = (hi_age).integerValue
                                    
                                    self.gradeToOption.text = gradeArray[index] as? String
                                    
                                }

                                self.topicOption.text = ""
                                
                                if let topic = self.curriculumData[0].valueForKey("topic_name")
                                {
                                    self.topicOption.text = topic as? String
                                }
                                
                                
                                if let toId = self.curriculumData[0].valueForKey("topic_id")
                                {
                                       NSUserDefaults.standardUserDefaults().setValue(toId, forKey: "addCurriculumtopicID")
                                }
                                
                                
                                self.currId = self.curriculumData[0].valueForKey("curid") as! NSString
                                
                                
                                self.organiztionalTxtField.text = ""
                                
                                if let org = self.curriculumData[0].valueForKey("organisation")
                                {
                                    
                                    self.organiztionalTxtField.text = org as? String
                                }
                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message:"No Data", delegate: self, cancelButtonTitle: "OK")
                                
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
    
    
    //MARK:- Country Api
    
    
    func countryApi()
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
            
            let url = NSURL(string:"http://www.digitallearningtree.com/digitalapi/country.php")
            
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            urlRequest.HTTPMethod = "POST"
            
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
                                
                                self.countryArray = ["Select Country"]
                                
                                let array = (jsonResults?.valueForKey("data")) as! NSArray
                                
                                self.countryArray.addObjectsFromArray(array as [AnyObject])
                                
                                
                                
                                
                                self.showCurriculumData()
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                let alert = UIAlertView(title: "Alert", message: " Data Missing", delegate: self, cancelButtonTitle: "OK")
                                
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

    //MARK:- Delete Api
    
    func currDeleteApi()
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
            
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            
            
            let post = NSString(format:"del_currid=%@&userid=%@",currId,cls_createdby_userID)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/curriculum_add.php")
            
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
                        
                        
                        //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            let data = jsonResults?.valueForKey("data") as! String
                            
                            if success
                            {
                                
                                self.titleTxtField.text = ""
                                self.stateTxtField.text = ""
                                self.organiztionalTxtField.text = ""
                                self.topicOption.text = ""
                                self.countryoption.text = ""
                                self.descriptionOption.text = ""
                                self.libraryOption.text = ""
                                self.gradeFromOption.text = ""
                                self.gradeToOption.text = ""
                                
                                CNDCurriculumOptionStr = self.titleTxtField.text!
                                CNDCurriculumOptionBool = true
                                let alert = UIAlertView(title: "Alert", message:data, delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message:data, delegate: self, cancelButtonTitle: "OK")
                                
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
    
    //MARK:- Delete Button
    
    @IBAction func deleteBtn(sender: AnyObject)
    {
        currDeleteApi()
        
    }
    
    
}
