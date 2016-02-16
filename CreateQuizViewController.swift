//
//  CreateQuizViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit


var quizLessonNameStr = NSString()
var quizLessonNameBool = Bool()


var quizLessonDescriptionStr = NSString()
var quizLessonDescriptionBool = Bool()


var quizLessonQuizQuestionStr = NSString()
var quizLessonQuizQUestionBool = Bool()
var multipleQuizQuestionStr = String()
var quizLessonAns1Str = NSString()
var quizLessonAns2Str = NSString()
var quizLessonAns3Str = NSString()
var quizLessonAns4Str = NSString()
var quizLessonCorrectAnsStr = NSString()

var QuizeditApiBool = Bool()
var quizLessonID = NSString()

class CreateQuizViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    
    var quizID = NSString()
    var editArray = NSMutableArray()
    @IBOutlet var quizQuestionOption: UILabel!
    @IBOutlet var titleTxtField: UITextField!
    @IBOutlet var descriptionOption: UILabel!

    @IBOutlet var lessonNameOption: UILabel!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
   
    @IBOutlet var saveBtn: UIButton!
   
    var questionID = NSString()
    var optionID1 = NSString()
    var optionID2 = NSString()
    var optionID3 = NSString()
    var optionID4 = NSString()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        titleTxtField.delegate = self
        
        saveBtn.layer.borderWidth = 1.5
        saveBtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor
        
        if QuizeditApiBool == true
        {
            getDataBeforeEditApi()
            self.navigationItem.title = "Modify Quiz"
        }
        
        else
        {
            titleTxtField.text = ""
            lessonNameOption.text = ""
            quizQuestionOption.text = ""
            descriptionOption.text = ""
            quizLessonNameBool = false
            quizLessonDescriptionBool = false
            quizLessonQuizQUestionBool = false

        }

        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if quizLessonNameBool == true
        
        {
            lessonNameOption.text = quizLessonNameStr as String
        }
        if quizLessonDescriptionBool == true
        {
            
            descriptionOption.text = quizLessonDescriptionStr as String
        }
        if quizLessonQuizQUestionBool == true
        {
            quizQuestionOption.text = quizLessonQuizQuestionStr as String
        }
          
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
    }
    
    
   

    //MARK:- Back Button

    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(false)
        
        titleTxtField.text = ""
        lessonNameOption.text = ""
        quizQuestionOption.text = ""
        descriptionOption.text = ""
        
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
    
    //MARK:- LessonName Button
    
    @IBAction func lessonNameBtn(sender: AnyObject)
    {
        let createQuizLesson = storyboard?.instantiateViewControllerWithIdentifier("createQuizLesson") as! CreateQuizLessonViewController
        self.navigationController?.pushViewController(createQuizLesson, animated: true)
    }
   
    
    //MARK:- QuizLesson Description Button
    
    @IBAction func quizLessonDescriptionBtn(sender: AnyObject)
    
    {
        let quizLessonDescription = storyboard?.instantiateViewControllerWithIdentifier("quizLessonDescription") as! QuizLessonDescriptionViewController
        
        quizLessonDescription.descriptionStr = descriptionOption.text!
        self.navigationController?.pushViewController(quizLessonDescription, animated: true)
    }
    
    

    //MARK:- Quiz Question Button
    
    @IBAction func quizQuestionBtn(sender: AnyObject)
    {
        let multipleQuiz = storyboard?.instantiateViewControllerWithIdentifier("multipleQuiz") as! MultipleQuizQuestionViewController
        multipleQuiz.editArrayAns = editArray
        
        if saveBtn.titleLabel?.text == "Update"
        {
        multipleQuiz.editQuestionBool = true
        }
        self.navigationController?.pushViewController(multipleQuiz, animated: true)

    }
    
    
    //MARK:- Add Quiz Api
    
    
    
    func addQuizApi()
        
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

        
        if titleTxtField.text == ""  || quizQuestionOption.text == ""  || lessonNameOption.text == "" || descriptionOption.text == ""
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
                let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
                let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
                let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
                
                
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                var post = NSString()
                
                if saveBtn.titleLabel?.text == "Update"
                {
                    post = NSString(format:"classid=%@&user_type=%@&userid=%@&schid=%@&lessonid=%@&quiz_title=%@&quiz_description=%@&last_modified=%@&edit_quiz_id=%@&quiz_data=%@",cla_classid_eid,"4",cls_createdby_userID,schID,quizLessonID,titleTxtField.text!,descriptionOption.text!,createdDate,quizID,multipleQuizQuestionStr)
                }
                else
                    
                {
                    
                post = NSString(format:"classid=%@&user_type=%@&userid=%@&schid=%@&lessonid=%@&quiz_title=%@&quiz_description=%@&qzdata=%@&last_modified=%@",cla_classid_eid,"4",cls_createdby_userID,schID,quizLessonID,titleTxtField.text!,descriptionOption.text!,multipleQuizQuestionStr,createdDate)
                }
                print(post)
                
                
                
                var dataModel = NSData()
                
                dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/quiz.php")
                
                
                
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
                                    self.titleTxtField.text = ""
                                    self.lessonNameOption.text = ""
                                    self.quizQuestionOption.text = ""
                                    self.descriptionOption.text = ""

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
        addQuizApi()
    }
    
    

    
    //MARK:- GET DATA BEFORE EDIT API
    
    func getDataBeforeEditApi()
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
            
            let post = NSString(format:"userid=%@&quizclassid=%@&quizid=%@",cls_createdby_userID,cla_classid_eid,quizID)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/quiz.php")
            
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
                    print("\(error?.localizedDescription)")
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
                                
                                let editDict = jsonResults?.valueForKey("data") as? NSDictionary
                                
                                //(editDict)
                                
                                
                              //  self.editArray = editDict?.valueForKey("options") as! NSArray
                                
                                //(self.editArray)
                                
                                
                                let QuizInfo = editDict?.valueForKey("quiz_info") as? NSDictionary
                                
                                //(QuizInfo)
                                
                                
                                if let title = QuizInfo?.valueForKey("quiz_name")
                                {
                                    self.titleTxtField.text = title as? String
                                }
                                
                                if let desc = QuizInfo?.valueForKey("quiz_desc")
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
                                        
                                        
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }

                                    //self.descriptionOption.text = desc as? String
                                }
                                
                                if let lessName = QuizInfo?.valueForKey("lesson_name")
                                {
                                    self.lessonNameOption.text = lessName as? String
                                }
                                
                                
                                if let lessonid = QuizInfo?.valueForKey("ass_less_id")
                                {
                                    quizLessonID = lessonid as! String
                                }
                                
                                
                                let QuizQuestion = editDict?.valueForKey("quiz_question") as! NSMutableArray
                                 self.editArray = QuizQuestion
                                
                                print(self.editArray)
                                

                                if let quizQues = QuizQuestion.lastObject!.valueForKey("question_name")
                                {
                                    let encodedData = quizQues.dataUsingEncoding(NSUTF8StringEncoding)!
                                    
                                    let attributedOptions : [String: AnyObject] =
                                    [
                                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                                    ]
                                    
                                    do
                                    {
                                        
                                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                                        
                                        
                                        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                                        
                                        self.quizQuestionOption.text  = decodedString
                                        
                                        
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }

                                    //self.quizQuestionOption.text = quizQues as? String
                                }
                                
                                self.questionID = ""
                                self.saveBtn.setTitle("Update", forState: UIControlState.Normal)
                                
                                self.updateValues()
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
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
    }
    
    
    
    func updateValues()
    {
        var str = ""
        
        
        for var i = 0; i < editArray.count ; i++
        {
            
                let questionID = editArray[i].valueForKey("question_id") as! String
                 let questionName = editArray[i].valueForKey("question_name") as! String
                let dict = editArray[i].valueForKey("quiz_options") as! NSMutableDictionary
                let optionArray = dict.valueForKey("options") as! NSMutableArray
            
                print(editArray)
                print(editArray.count)
                print(questionID)
                print(optionArray)
            
                if i == 0
                {
            
                    str = String(format: "{'quiz_question':[{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",questionID,questionName,optionArray[0].valueForKey("option_id") as! String,optionArray[0].valueForKey("quizzes_id") as! String,optionArray[0].valueForKey("quiz_option") as! String,optionArray[0].valueForKey("correct_answer") as! String)
                    
                    if optionArray.count > 1
                    {
                        str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[1].valueForKey("option_id") as! String,optionArray[1].valueForKey("quizzes_id") as! String,optionArray[1].valueForKey("quiz_option") as! String,optionArray[1].valueForKey("correct_answer") as! String)
                    }

                    
                    
                    if optionArray.count > 2
                    {
                        str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[2].valueForKey("option_id") as! String,optionArray[2].valueForKey("quizzes_id") as! String,optionArray[2].valueForKey("quiz_option") as! String,optionArray[2].valueForKey("correct_answer") as! String)
                    }

                    
                    if optionArray.count > 3
                    {
                        str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[3].valueForKey("option_id") as! String,optionArray[3].valueForKey("quizzes_id") as! String,optionArray[3].valueForKey("quiz_option") as! String,optionArray[3].valueForKey("correct_answer") as! String)
                    }

                }
                else
                    
                {
                   
                    
                     str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[0].valueForKey("option_id") as! String,optionArray[0].valueForKey("quizzes_id") as! String,optionArray[0].valueForKey("quiz_option") as! String,optionArray[0].valueForKey("correct_answer") as! String)
                    
                    if optionArray.count > 1
                    {
                        str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[1].valueForKey("option_id") as! String,optionArray[1].valueForKey("quizzes_id") as! String,optionArray[1].valueForKey("quiz_option") as! String,optionArray[1].valueForKey("correct_answer") as! String)
                    }
                    
                    
                    
                    if optionArray.count > 2
                    {
                        str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[2].valueForKey("option_id") as! String,optionArray[2].valueForKey("quizzes_id") as! String,optionArray[2].valueForKey("quiz_option") as! String,optionArray[2].valueForKey("correct_answer") as! String)
                    }
                    

                    
                    if optionArray.count > 3
                    {
                        str = String(format: "%@,{'question_id':'%@','question_name':'%@','quiz_options':{'options':[{'option_id':'%@','quizzes_id':'%@','quiz_option':'%@','correct_answer':'%@'}]}}",str,questionID,questionName,optionArray[3].valueForKey("option_id") as! String,optionArray[3].valueForKey("quizzes_id") as! String,optionArray[3].valueForKey("quiz_option") as! String,optionArray[3].valueForKey("correct_answer") as! String)
                    }
                    
                }
            
            
            
        }
        
        str = String (format: "%@]}", str)
        print(str)
        multipleQuizQuestionStr = str
        
        //(multipleQuizQuestionStr)
    
}
    
}
