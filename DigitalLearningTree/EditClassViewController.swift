//
//  EditClassViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/7/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var boolDIctFeatures = Dictionary<String,String>()
var EditClassDescrptionString = NSString()
var feturesStrArrayEdit = NSArray()
var EditClassBool = Bool()
var editClassClassTypeString = NSString()
var editClassTopicString = NSString()
var EditClassOtherTxtString = NSString()

var  EditdataShowGetBackTopicBool = Bool()
var  EditdataShowGetBackClassTypeBool = Bool()
var  EditdataShowGetBackFeaturesBool = Bool()
var  EditdataShowGetBackDescriptionBool = Bool()


class EditClassViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    var TempArray = NSMutableArray()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var featuresOption: UILabel!
    
    @IBOutlet var editDescritionOption: UILabel!
    
    var alertFillRequired  = UIAlertView()
    var edittopicID = NSString()
    
    var dropDownKeypad = Int()
    var switchCount = Int()
    var createdBy = NSString()
    var schoolid = NSString()
    
    var classData = NSArray()
    
    @IBOutlet var topicOption: UILabel!
    @IBOutlet var classTypeoption: UILabel!
    
    var classTypeID = String()
    
    @IBOutlet var swicth: UISwitch!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var changePictureBtn: UIButton!
    @IBOutlet var EditBtn: UIButton!
    @IBOutlet var savebtn: UIButton!
    @IBOutlet var sourceCodeTxtField: UITextField!
    @IBOutlet var semesterTxtField: UITextField!
    
    
    
    @IBOutlet var enrollementTxtField: UITextField!
    @IBOutlet var titleTxtField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        editApi()
        dropDownKeypad = 1
        
        EditdataShowGetBackTopicBool = true
        EditdataShowGetBackClassTypeBool = true
        EditdataShowGetBackFeaturesBool = true
        EditdataShowGetBackDescriptionBool = true
        
        switchCount = 0
        swicth.transform = CGAffineTransformMakeScale(0.75, 0.75);
        
        
        
        scrollView.contentSize.height = savebtn.frame.origin.y + savebtn.frame.size.height
        
        
        
        self.navigationController?.navigationBarHidden = false
        
        
        EditBtn.layer.borderWidth = 0.5
        EditBtn.layer.borderColor = UIColor.whiteColor().CGColor
        EditBtn.layer.cornerRadius = 3
        
        changePictureBtn.layer.borderWidth = 0.5
        changePictureBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        deleteBtn.layer.borderWidth = 0.5
        deleteBtn.layer.borderColor = UIColor.whiteColor().CGColor
        deleteBtn.layer.cornerRadius = 3
        
        
        
        
        
        titleTxtField.delegate = self
        enrollementTxtField.delegate = self
        sourceCodeTxtField.delegate = self
        semesterTxtField.delegate = self
        
        savebtn.layer.borderWidth = 1.5
        savebtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor
        scrollView.delegate = self
        
    }
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        //(EditClassDescrptionString)
        //(boolDIctFeatures)
        
        
        
        
        if EditdataShowGetBackFeaturesBool == false
        {
            
            if editClassFeaturesBool == true
            {
                let stringRepresentation = feturesStrArrayEdit.valueForKey("description").componentsJoinedByString(",")
                
                //(stringRepresentation)
                
                featuresOption.text = stringRepresentation
                
            }
                
            else
                
            {
                featuresOption.text = ""
            }
        }
        
        if EditdataShowGetBackDescriptionBool == false
            
        {
            
            if editClassDescriptionBool == true
            {
                
                
                editDescritionOption.text = EditClassDescrptionString as String
            }
                
            else
                
                
            {
                editDescritionOption.text = ""
            }
        }
        
        if EditdataShowGetBackClassTypeBool == false
            
        {
            
            if editClassClassTypeCheckBool == true
            {
                classTypeoption.text =  editClassClassTypeString as String
                
                if classTypeoption.text == "Instructor"
                {
                    classTypeID = "1"
                }
                    
                else if classTypeoption.text == "Blended"
                {
                    classTypeID = "2"
                    
                }
                    
                else
                    
                {
                    classTypeID = "3"
                }
            }
                
            else
                
            {
                classTypeoption.text = ""
            }
            
        }
        
        if EditdataShowGetBackTopicBool == false
        {
            
            if editClasstopicCheckBool == true
            {
                topicOption.text = editClassTopicString as String
                
            }
                
            else
                
            {
                topicOption.text = ""
            }
        }
        
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
        
        if textField == semesterTxtField || textField == sourceCodeTxtField
        {
            UIView.animateWithDuration(0.2, animations: {
                
                
                
                self.view.frame.origin.y -= self.view.frame.height/2.5
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
        
        if textField == semesterTxtField || textField == sourceCodeTxtField
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/2.5
            })
            
            dropDownKeypad = 3
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        
    }
    
    //MARK:- AlertView Delegate
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView == alertFillRequired
        {
            if buttonIndex == 0
            {
                if dropDownKeypad == 3
                {
                    UIView.animateWithDuration(0.2, animations: {
                        self.view.frame.origin.y -= self.view.frame.height/2.5
                    })
                    
                    dropDownKeypad = 2
                }
                
            }
            
        }
        
    }
    
    
    //MARK:- TouchEvent Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        
        
        titleTxtField.resignFirstResponder()
        enrollementTxtField.resignFirstResponder()
        sourceCodeTxtField.resignFirstResponder()
        semesterTxtField.resignFirstResponder()
        
    }
    
    
    
    
    
    //MARK:- CHANGE PICTURE DELETE BUTTON
    
    @IBAction func changePictureBtn(sender: AnyObject)
    {
        let changePicture = storyboard?.instantiateViewControllerWithIdentifier("changePicture") as! ChangePictureViewController
        
        self.navigationController?.pushViewController(changePicture, animated: false)
        
    }
    
    @IBAction func deleteBtn(sender: AnyObject)
    {
        let deleteView = storyboard?.instantiateViewControllerWithIdentifier("deleteView") as! DeleteViewController
        
        self.navigationController?.pushViewController(deleteView, animated: false)
    }
    
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
//        if backfromEditDeleteChngePicBool == true
//        {
//            
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKindOfClass(ClassNameAndDetailViewController) {
//                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
//                    break
//                }
//            }
//            
//        }
//            
//        else
//        {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(ClassListingViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
       // }
        
    }
    
    
    //MARK:- ClassType Button
    
    @IBAction func classTypeBtn(sender: AnyObject)
    {
        
        let classType = storyboard?.instantiateViewControllerWithIdentifier("classType") as! ClassTypeViewController
        EditClassBool = true
        self.navigationController?.pushViewController(classType, animated: true)
        
        
    }
    
    
    //MARK:- Topic Button
    
    @IBAction func topicBtn(sender: AnyObject)
    {
        let topic = storyboard?.instantiateViewControllerWithIdentifier("topic") as! TopicViewController
        EditClassBool = true
        self.navigationController?.pushViewController(topic, animated: true)
        
    }
    
    //Description Button
    
    
    @IBAction func descriptionBtn(sender: AnyObject)
    {
        let desc = storyboard?.instantiateViewControllerWithIdentifier("Desc") as! CreateClassDescriptionViewController
        desc.showEditDescriptionStr = editDescritionOption.text!
        EditClassBool = true
        self.navigationController?.pushViewController(desc, animated: true)
    }
    
    
    
    //MARK:- Edit Api
    
    func editApi()
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
            
            let post = NSString(format:"eid=%@&userid=%@&schid=%@",cla_classid_eid,cls_createdby_userID, schID)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/edit_class.php")
            
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
                                
                                
                                
                                self.classData = jsonResults?.valueForKey("data") as! NSArray
                                
                                
                                self.titleTxtField.text = ""
                                
                                if let className = self.classData[0].valueForKey("classname")
                                {
                                    self.titleTxtField.text = className as? String
                                }
                                
                                self.topicOption.text = ""
                                
                                if let topic = self.classData[0].valueForKey("topic_name")
                                {
                                    self.topicOption.text = topic as? String
                                }
                                
                                self.classTypeoption.text = ""
                                
                                if let ClassTypeidEdit = self.classData[0].valueForKey("style")
                                {
                                    self.classTypeID = ClassTypeidEdit as! String
                                    if ClassTypeidEdit as! String == "1"
                                    {
                                        self.classTypeoption.text = "Instructor"
                                        
                                    }
                                        
                                    else if ClassTypeidEdit as! String == "2"
                                    {
                                        self.classTypeoption.text = "Blended"
                                    }
                                        
                                    else if ClassTypeidEdit as! String == "3"
                                        
                                    {
                                        self.classTypeoption.text = "Self-Paced"
                                    }
                                    
                                }
                                
                                self.enrollementTxtField.text == ""
                                
                                if let enrollPasscode = self.classData[0].valueForKey("classid")
                                {
                                    self.enrollementTxtField.text = enrollPasscode as? String
                                    
                                }
                                
                                self.createdBy = ""
                                
                                if let createid = self.classData[0].valueForKey("createdby")
                                {
                                    self.createdBy = createid as! NSString
                                }
                                
                                self.schoolid = ""
                                
                                if let schid = self.classData[0].valueForKey("schoolid")
                                {
                                    self.schoolid = schid as! NSString
                                }
                                
                                self.edittopicID = ""
                                
                                if let topicid = self.classData[0].valueForKey("topic_id")
                                {
                                    self.edittopicID = topicid as! String
                                    
                                    //(self.edittopicID)
                                }
                                
                                self.editDescritionOption.text = ""
                                
                                
                                if let desc = self.classData[0].valueForKey("desc")
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
                                                
                                                self.editDescritionOption.text  = decodedString
                                                
                                                //(decodeStr)
                                                
                                            }
                                                
                                            catch
                                            {
                                                
                                                print("Fetch failed: \((error as NSError).localizedDescription)")
                                                
                                            }
                                            

                                   // self.editDescritionOption.text = desc as? String
                                }
                                
                                
                                if let dictfeat = self.classData[0].valueForKey("Cls_Features")
                                    
                                {
                                    
                            
                                    let dict = dictfeat as? NSDictionary
                                    
                                    if let cal = dict?.valueForKey("enable_calendar") as? String
                                    {
                                        calendarBool = cal
                                    }
                                    
                                    if let cht = dict?.valueForKey("enable_chat") as? String
                                    {
                                        chatBool = cht
                                    }
                                    
                                    if let grad = dict?.valueForKey("enable_grades") as? String
                                    {
                                        gradeBool = grad
                                    }
                                    
                                    if let sttab = dict?.valueForKey("enable_students_tab") as? String
                                    {
                                        studentTabBool = sttab
                                    }
                                    
                                    
                                    
                                    var featureAppend = [String]()
                                    
                                    
                                    if calendarBool == "true"
                                    {
                                        featureAppend.append("Calendar")
                                    }
                                    
                                    if chatBool == "true"
                                        
                                    {
                                        featureAppend.append("Chat")
                                    }
                                    
                                    if gradeBool == "true"
                                    {
                                        featureAppend.append("Grades")
                                    }
                                    
                                    if studentTabBool == "true"
                                        
                                    {
                                        featureAppend.append("Student Tab")
                                    }
                                    
                                    feturesStrArrayEdit = featureAppend
                                   
                                    
                                    let stringRepr = feturesStrArrayEdit.valueForKey("description").componentsJoinedByString(",")
                                    
                                    self.featuresOption.text! =  stringRepr
                                    
                                    //(self.featuresOption.text)
                                    //(calendarBool)
                                    //(chatBool)
                                    //(gradeBool)
                                    //(studentTabBool)
                                    
                                }
                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                                
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
    
    
    // MARK:- Update Class Api
    
    
    func updateClassApi()
    {
        
        if dropDownKeypad == 2
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/2.5
            })
            
            dropDownKeypad = 3
            
        }
        
        
        if titleTxtField.text == "" || classTypeoption.text == "" || topicOption.text == "" 
        {
            alertFillRequired = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
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
                let switchCountStr  = String(switchCount) as String
                //(switchCountStr)
                
                if let topicID =   NSUserDefaults.standardUserDefaults().valueForKey("edittopicID") as? String
                {
                    edittopicID = topicID
                }
                let withoutPlus = titleTxtField.text!.stringByReplacingOccurrencesOfString("'", withString: "")
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                
                
                let post = NSString(format:"classid=%@&createdby=%@&schoolid=%@&classname=%@&style=%@&topic=%@&desc=%@&show_links=%@&semester=%@&coursecode=%@&othertopicdata=%@&enable_calendar=%@&enable_students_tab=%@&enable_chat=%@&enable_grades=%@",enrollementTxtField.text!,createdBy, schoolid,withoutPlus ,classTypeID,edittopicID,editDescritionOption.text!,switchCountStr,semesterTxtField.text!,sourceCodeTxtField.text!,EditClassOtherTxtString,calendarBool,studentTabBool,chatBool,gradeBool)
                
                print(post)
                
                var dataModel = NSData()
                
                let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/update_class.php")
                
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
                                    for controller in self.navigationController!.viewControllers as Array
                                    {
                                        if controller.isKindOfClass(ClassListingViewController)
                                        {
                                            self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                                            break
                                        }
                                    }

                                    
                                    spinningIndicator.hide(true)
                                    
                                }
                                else
                                    
                                {
                                    
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
        updateClassApi()
    }
    
    
    //MARK:- Switch Action
    
    @IBAction func swictch(sender: AnyObject)
    {
        if swicth.on
        {
            switchCount = 1
            
            //(switchCount)
            
        }
        else
            
        {
            switchCount = 0
            //(switchCount)
            
        }
    }
    
    
    
    //MARK:- Zoom In Zoom Out
    
    @IBAction func zoomIn(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, animations: {
            self.zoomView.transform = CGAffineTransformScale(self.zoomView.transform, 1.25, 1.25)
            
            self.zoomScrollView.contentSize.height = self.zoomView.frame.height
            self.zoomScrollView.contentSize.width = self.zoomView.frame.width
            
            self.scrollView.contentSize.height = self.savebtn.frame.origin.y + self.savebtn.frame.size.height+10
            
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
            self.scrollView.contentSize.height = self.savebtn.frame.origin.y + self.savebtn.frame.size.height+10
        }
            
            
            
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.zoomView.transform = CGAffineTransformScale(self.zoomView.transform, 0.8, 0.8)
                
                self.zoomScrollView.contentSize.height = self.zoomView.frame.height
                self.zoomScrollView.contentSize.width = self.zoomView.frame.width
                self.scrollView.contentSize.height = self.savebtn.frame.origin.y + self.savebtn.frame.size.height+10
                self.zoomView.frame.origin.x = 0
                self.zoomView.frame.origin.y = 0
                
            })
            
        }
        
        //(zoomView.frame.height)
        //(zoomView.frame.width)
        
        
        
    }
    
    
    
}




