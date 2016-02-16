//
//  ClassNameAndDetailViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit


var CNDCurriculumOptionStr = NSString()
var CNDSyllabusOptionStr = NSString()
var CNDScheduleOptionStr = NSString()

var CNDScheduleOptionBool = Bool()
var CNDSyllabusOptionBool = Bool()
var CNDCurriculumOptionBool = Bool()

var ClassListAndChangeImage = UIImage()

class ClassNameAndDetailViewController: UIViewController
{

   
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scheduleOption: UILabel!
    @IBOutlet var syllabusOption: UILabel!
    @IBOutlet var curriculumOption: UILabel!
    @IBOutlet var grayView: UIView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var enrollPasscodeLbl: UILabel!
    @IBOutlet var topicNameLbl: UILabel!
    
    @IBOutlet var zoomScrollView: UIScrollView!
    
    @IBOutlet var descriptionTxtView: UITextView!
    @IBOutlet var zoomView: UIView!
   
    var className = NSString()
    var topicName = NSString()
    
    var descriptionStr = NSString()
    
    @IBOutlet var schoolName: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var changePictureBtn: UIButton!
    @IBOutlet var EditBtn: UIButton!
    @IBOutlet var navigatioarView: UIView!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        
        let encodedData = descriptionStr.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
      
        do
        {
            
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
            
            let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
            self.descriptionTxtView.text = decodedString
            
            if  decodedString == ""
            {
                self.descriptionTxtView.text = "No Description"
            }
            
            
        }
            
        catch
        {
            
            //("Fetch failed: \((error as NSError).localizedDescription)")
            
        }

        
        
        ClassImageApi()
        
        
        
        showCurriculumData()
        getSyllabus()
        allScheduleData()
        
        let cla_classid_eid =   NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
        
        let contentSize = self.descriptionTxtView.sizeThatFits(self.descriptionTxtView.bounds.size)
        var frame = self.descriptionTxtView.frame
        frame.size.height = contentSize.height + 20
        self.descriptionTxtView.frame = frame

        self.navigationItem.title = className as String
        
        topicNameLbl.text = "Topic:\(topicName)"
        
        enrollPasscodeLbl.text =  "Enrollment Passcode:\(cla_classid_eid)"
        
       let sch = NSUserDefaults.standardUserDefaults().valueForKey("schoolsName") as! String
        
        schoolName.text = "School:\(sch)"
        EditBtn.layer.borderWidth = 0.5
        EditBtn.layer.borderColor = UIColor.whiteColor().CGColor
        EditBtn.layer.cornerRadius = 3
        
        changePictureBtn.layer.borderWidth = 0.5
        changePictureBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        deleteBtn.layer.borderWidth = 0.5
        deleteBtn.layer.borderColor = UIColor.whiteColor().CGColor
        deleteBtn.layer.cornerRadius = 3
        
        scrollView.contentSize.height = descriptionTxtView.frame.origin.y + descriptionTxtView.frame.size.height
        
        descriptionTxtView.layer.borderWidth = 0.5
        descriptionTxtView.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionTxtView.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
       //imageView.image =  ClassListAndChangeImage
        
       if let imageData = NSUserDefaults.standardUserDefaults().objectForKey("ClassListAndChangeImage") as? NSData
       {
        
        imageView.image = UIImage(data: imageData)
        }
        
        if CNDSyllabusOptionBool == true
        {
           syllabusOption.text = CNDSyllabusOptionStr as String
        }
        
        if CNDCurriculumOptionBool == true
        {
        
       curriculumOption.text = CNDCurriculumOptionStr as String
        
       
        }
        if CNDScheduleOptionBool == true
        {
        
         scheduleOption.text = CNDScheduleOptionStr as String
            
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            
            
            self.grayView.hidden = true
            
           
            
            self.grayView.hidden = true
        })
        
    }

   
   
    //MARK:- Enter button
    
   // @IBAction func enterBtn(sender: AnyObject)
   // {
   //     let lessonView = storyboard?.instantiateViewControllerWithIdentifier("lessonView") as! LessonsViewController
   //     lessonView.teacherCollaborationBool = true
   //   lessonView.navigationTitle = self.navigationItem.title!
        
//self.navigationController?.pushViewController(lessonView, animated: true)
        //self.navigationItem.title = "Back"
   // }
    
    //MARK:- Down Edit Button
    
    @IBAction func downEditBtn(sender: AnyObject)
    {
        let syllabusView = storyboard?.instantiateViewControllerWithIdentifier("syllabusView") as! SyllabusViewController
        
        self.navigationController?.pushViewController(syllabusView, animated:true)
        
    }
    
    
    //MARK:- EDIT DELETE CHANGE PICTURE BUTTON
    
    
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
    
    @IBAction func deleteBtn(sender: AnyObject)
    {
        let deleteView = storyboard?.instantiateViewControllerWithIdentifier("deleteView") as! DeleteViewController
        
        self.navigationController?.pushViewController(deleteView, animated: false)
    }
    
    //MARK:- Zoom In Zoom Out
    
    @IBAction func zoomIn(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, animations: {
            self.zoomView.transform = CGAffineTransformScale(self.zoomView.transform, 1.25, 1.25)
            
            self.zoomScrollView.contentSize.height = self.zoomView.frame.height
            self.zoomScrollView.contentSize.width = self.zoomView.frame.width
             self.scrollView.contentSize.height = self.descriptionTxtView.frame.origin.y + self.descriptionTxtView.frame.size.height+10
            
            
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
             self.scrollView.contentSize.height = self.descriptionTxtView.frame.origin.y + self.descriptionTxtView.frame.size.height+10
            
        }
            
            
            
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.zoomView.transform = CGAffineTransformScale(self.zoomView.transform, 0.8, 0.8)
                
                self.zoomScrollView.contentSize.height = self.zoomView.frame.height
                self.zoomScrollView.contentSize.width = self.zoomView.frame.width
                
                self.zoomView.frame.origin.x = 0
                self.zoomView.frame.origin.y = 0
                 self.scrollView.contentSize.height = self.descriptionTxtView.frame.origin.y + self.descriptionTxtView.frame.size.height+10
            })
            
        }
        
        //(zoomView.frame.height)
        //(zoomView.frame.width)
        
        
        
    }
    
    
    
    //MARK:- Menu Bar Button
    
    
    @IBAction func menuBarBtn(sender: AnyObject)
    {
        
        
        
        if menuView.frame.origin.x == 0
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = -700
               // self.navigatioarView.frame.origin.x = 0
               // self.zoomView.frame.origin.x =  0
                self.grayView.hidden = true
                
                
            })
            
            
        }
            
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                
               //self.navigatioarView.frame.origin.x = self.menuView.frame.size.width
              // self.zoomView.frame.origin.x = self.menuView.frame.size.width
                
                self.grayView.hidden = false
                
            })
            
        }
        
        
    }
    
    
    
    
    //MARK:- Menu Buttons
    
    @IBAction func menuClassBtn(sender: AnyObject)
    {
        let classListView = storyboard?.instantiateViewControllerWithIdentifier("classListView") as! ClassListingViewController
        
        self.navigationController?.pushViewController(classListView, animated: true)

        
        
    }
    
    @IBAction func menuLessonBtn(sender: AnyObject)
    {
        let lessonView = storyboard?.instantiateViewControllerWithIdentifier("lessonView") as! LessonsViewController
        
        self.navigationController?.pushViewController(lessonView, animated: true)
    }
    
    
    @IBAction func menuClassResorcesBtn(sender: AnyObject)
    {
        let classResourceView = storyboard?.instantiateViewControllerWithIdentifier("classResourceView") as! ClassResourcesViewController
        
        self.navigationController?.pushViewController(classResourceView, animated: true)
        
    }
    
    @IBAction func menuQuizBtn(sender: AnyObject)
    {
        let quizView = storyboard?.instantiateViewControllerWithIdentifier("quizView") as! QuizViewController
        
        self.navigationController?.pushViewController(quizView, animated: true)
        
        
    }
    
    @IBAction func menuStudentBtn(sender: AnyObject)
    {
        let studentView = storyboard?.instantiateViewControllerWithIdentifier("studentView") as! StudentViewController
        
        self.navigationController?.pushViewController(studentView, animated: true)
    }
    
    @IBAction func menuEnrollBtn(sender: AnyObject)
    {
        let enrollView = storyboard?.instantiateViewControllerWithIdentifier("enrollView") as! GradeViewController
        
        self.navigationController?.pushViewController(enrollView, animated: true)
        
    }
    
    //MARK:- Logout Button
    
    @IBAction func logoutBtn(sender: AnyObject)
    {
        let login = storyboard?.instantiateViewControllerWithIdentifier("teacherLogin") as! LoginViewController
        
        loginbacktoschoolBool = true
        login.StudentAndTeacherLoginBool = true
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "Login")
        self.navigationController?.pushViewController(login, animated: false)
    }
    
    //MARK:- Show Curriculum Data Api
    
    func showCurriculumData()
    {
        if Reachability.isConnectedToNetwork() == false
        {
//            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
//            
//            alert.show()
            
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
//                    let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
//                    
//                    alert.show()
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
                        
                        
                        print(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            
                            if success
                            {
                                var curriculumData = NSArray()
                                
                                curriculumData = jsonResults!.valueForKey("data") as! NSArray
                                
                                self.curriculumOption.text = ""
                                if let title = curriculumData[0].valueForKey("title")
                                {
                                    self.curriculumOption.text = title as? String
                                }
                            
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
//                                let alert = UIAlertView(title: "Alert", message:"No Data", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
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
//                            let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
//                            
//                            alert.show()
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
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                            let success = jsonResults?.valueForKey("success") as! Bool
                            if success
                            {
                                var syallabusData = NSArray()
                                syallabusData = jsonResults!.valueForKey("data") as! NSArray
                                self.syllabusOption.text = ""
                                if let sy = syallabusData[0].valueForKey("title")
                                {
                                    self.syllabusOption.text = sy as? String
                                }
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
//                                let alert = UIAlertView(title: "Alert", message: "No Data", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
//                                
                                
                                spinningIndicator.hide(true)
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                    catch
                    {
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
//                                let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
                                spinningIndicator.hide(true)
                        })
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
        
    }
    

    
    //MARK:- All Schedule Data
    
    
    func allScheduleData()
    {
        
        
        if Reachability.isConnectedToNetwork() == false
        {
//            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
//            
//            alert.show()
//            
        }
            
        else
            
        {
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let post = NSString(format:"userid=%@&clsid=%@",cls_createdby_userID,cla_classid_eid)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/before_edit_time.php")
            
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
//                    let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
//                    
//                    alert.show()
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
                            
                            if success
                            {
                                var scheduleArray = NSArray()
                                
                                scheduleArray =  jsonResults?.valueForKey("data") as! NSArray
                                
                                
                                self.scheduleOption.text = ""
                                
                                if let day = scheduleArray.lastObject!.valueForKey("day")
                                {
                                    if day as! String == "1"
                                    {
                                        self.scheduleOption.text = "Monday"
                                    }
                                    
                                    if day as! String == "2"
                                    {
                                       self.scheduleOption.text = "Tuesday"
                                    }
                                    
                                    if day as! String == "3"
                                    {
                                        self.scheduleOption.text = "Wednesday"
                                    }
                                    
                                    if day as! String == "4"
                                    {
                                        self.scheduleOption.text = "Thursday"
                                    }
                                    
                                    if day as! String == "5"
                                    {
                                        self.scheduleOption.text = "Friday"
                                    }
                                    
                                    if day as! String == "6"
                                    {
                                        self.scheduleOption.text = "Saturday"
                                    }
                                    
                                    if day as! String == "7"
                                    {
                                        self.scheduleOption.text = "Sunday"
                                    }
                                    
                                    if day as! String == "8"
                                    {
                                        self.scheduleOption.text = "Every Day"
                                    }
                                    
                                    if day as! String == "9"
                                    {
                                        self.scheduleOption.text = "Every Weekday"
                                    }
                                    
                                    
                                }

                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
//                                let alert = UIAlertView(title: "Alert", message: "No data", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
                                spinningIndicator.hide(true)
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                    catch
                    {
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
//                                let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
//                                
                              //  alert.show()
                                spinningIndicator.hide(true)
                        })
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
        
    }
    

    //MARK:- ClassImage Data
    
    
    func ClassImageApi()
    {
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            
        
        }
            
        else
            
        {
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
           
            let cla_classid_eid = NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let post = NSString(format:"classid=%@",cla_classid_eid)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_image.php")
            
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
                       // //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                
                                var imageArray = NSArray()
                                
                                imageArray = jsonResults?.valueForKey("data") as! NSArray
                                
                                self.imageView.image = UIImage(named: "no-icon.png")
                                
                                NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(self.imageView.image!), forKey: "ClassListAndChangeImage")
                                
                                        if let url = imageArray[0].valueForKey("class_image") as? String, imageUrl = NSURL(string:url.stringByReplacingOccurrencesOfString("", withString:"%20"))
                                
                                        {
                                
                                            if let data = NSData(contentsOfURL: imageUrl)
                                            {
                                
                                               let image = UIImage(data: data)
                                                
                                              //  //(image)
                                             self.imageView.image    = image!
                                                
                                            //ClassListAndChangeImage = self.imageView.image!
                                                
                                                 NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(image!), forKey: "ClassListAndChangeImage")
                                                
                                                
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
