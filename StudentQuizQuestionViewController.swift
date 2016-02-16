//
//  StudentQuizQuestionViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import CoreData

class StudentQuizQuestionViewController: UIViewController
{
    var timerEnable = Bool()
    var str = NSString()
    var correctAnsArray: [String] = []
    @IBOutlet var questionScrollView: UIScrollView!
    @IBOutlet var timerLbl: UILabel!
    var user_ans = NSString()
    var anWerDataStr = NSString()
    var TimeFormatStr = NSString()
    var totalSeconds = 0
    var timer = NSTimer()
    @IBOutlet var descriptionLbl: UITextView!
    var checkBoolCondition = Bool()
    var quizArray = NSMutableArray()
    @IBOutlet var submitMyAns: UIButton!
    var y :Int = 0
    @IBOutlet var lessontitleLbl: UILabel!
    
    @IBOutlet var lessonView: UIView!
    
    var quiz_id = NSString()
    var currentQuesCount = 0
  
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    
    var anwerData = NSString()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        StudentQuizDetailApi()
        timerEnable = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
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
        
        
        print(zoomView.frame.height)
        print(zoomView.frame.width)
        
        
        
        
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
        
        print(zoomView.frame.height)
        print(zoomView.frame.width)
        
        
        
    }
    
    
    //MARK:- StudentQuizDetail Api
    
    func StudentQuizDetailApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
        else
        {
            let classID =  NSUserDefaults.standardUserDefaults().valueForKey("StudentClassID") as! String
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            let post = NSString(format:"quizid=%@&classid=%@",quiz_id,classID)
            print(post)
            var dataModel = NSData()
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength = String(dataModel.length)
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_quiz.php")
            let urlRequest = NSMutableURLRequest(URL: url!)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = dataModel
            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                print(data)
                
                print(response)
                
                if (error != nil)
                {
                    print("\(error?.localizedDescription)")
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
                        //success ...
                        print(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                let dict = jsonResults?.valueForKey("data") as! NSDictionary
                                
                                self.quizArray = dict.valueForKey("quiz_info") as! NSMutableArray
                                
                                if let name = self.quizArray[0].valueForKey("quiz_name")
                                {
                                    self.lessontitleLbl.text = name as? String
                                }
                                
                                if let desc = self.quizArray[0].valueForKey("quiz_desc")
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
                                        self.descriptionLbl.text  = decodedString
                                    }
                                    catch
                                    {
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                    }
                                    

                                   // self.descriptionLbl.text = desc as? String
                                }
                                
                                self.quizQuestion()

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
    
    
    //MARK:- Next Button
    
    @IBAction func nextBtn(sender: AnyObject)
    {
        if submitMyAns.titleLabel?.text == "Submit Answer"
        {
            str = String (format: "{%@}", str)
            anWerDataStr = str
            print(str)
            StudentResultApi()
        }
        else
        {
             anwerStr()
        }
        
    }
    
    func countDown()
    {
        var hours = 00, minutes = 00, seconds = 00
        
        totalSeconds++;
        hours = totalSeconds / 3600;
        minutes = (totalSeconds % 3600) / 60;
        seconds = (totalSeconds % 3600) % 60;
        
        var Shours = "\(hours)"
        var SMint = "\(minutes)"
        var SSec = "\(seconds)"
        
        if hours < 10
        {
            Shours = "0\(hours)"
        }
        
        if minutes < 10
        {
            SMint = "0\(minutes)"
        }
        
        if seconds < 10
        {
            SSec = "0\(seconds)"
        }
        
        print("\(Shours):\(SMint):\(SSec)")
        
        TimeFormatStr = "\(Shours):\(SMint):\(SSec)"
        timerLbl.text = TimeFormatStr as String
    }
    
    //MARK:- Student Result Api
    
    func StudentResultApi()
    {
        timer.invalidate()
        print(TimeFormatStr)
        
        
        let date = NSDate()
        
        let requestedComponents: NSCalendarUnit =
        [
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
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else
        {
            print(anWerDataStr)
            let user_ID = NSUserDefaults.standardUserDefaults().valueForKey("StudentUserID") as! String
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
             let strFrmt = UIDevice.currentDevice().identifierForVendor!.UUIDString as String
              print(strFrmt)
             let post = NSString(format:"quizmasterid=%@&todaydate=%@&ipaddr=%@&timelast=%@&userid=%@&answerdata=%@",quiz_id,createdDate,strFrmt,TimeFormatStr,user_ID,anWerDataStr)
            print(post)
            var dataModel = NSData()
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength = String(dataModel.length)
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_quiz.php")
            let urlRequest = NSMutableURLRequest(URL: url!)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = dataModel
            urlRequest.setValue(postLength, forHTTPHeaderField:"Content-Length")
            urlRequest.setValue("application/json", forHTTPHeaderField:"Accept")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")

            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                print(data)
                
                print(response)
                
                if (error != nil)
                {
                    print("\(error?.localizedDescription)")
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
                                let storyBoardStudent = UIStoryboard(name: "Student", bundle: nil)
                                
                                let quizResult = storyBoardStudent.instantiateViewControllerWithIdentifier("quizResult") as! StudentQuizResultViewController
                                
                                quizResult.arrayResult = jsonResults?.valueForKey("data") as! NSMutableArray
                                self.navigationController?.pushViewController(quizResult, animated: true)
                                
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                let managedContext = appDelegate.managedObjectContext
                                
                                let entity = NSEntityDescription.entityForName("SubmitQuizAndUserId", inManagedObjectContext: (managedContext))
                                
                                let person = NSManagedObject (entity:entity!, insertIntoManagedObjectContext: managedContext)
                                person.setValue(user_ID,forKey: "userID")
                                person.setValue(self.quiz_id, forKey: "quizID")
                                
                                do
                                {
                                    try managedContext.save()
                                    
                                    print("save")
                                } catch let error as NSError
                                {
                                    print("Could not save \(error), \(error.userInfo)")
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
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                }
            })
            task.resume()
        }
    }
    
    
    
    //MARK:- QuizQuestion
    
    
    func quizQuestion()
    {
        autoreleasepool({
            
        
        for var i = 0 ; i < quizArray.count ; i++
        {
            correctAnsArray.append("4")
            currentQuesCount++
            let optionsArray = quizArray[i].valueForKey("quiz_option_data") as! NSMutableArray
            //let optionsArray = dict.valueForKey("quiz_options") as! NSArray
            questionScrollView.pagingEnabled = true
            let questionTextView = UITextView(frame: CGRectMake(8,10,view.frame.size.width - 16, 0.43 * questionScrollView.frame.height))
            questionTextView.layer.cornerRadius = 5
            questionTextView.layer.borderWidth = 1
            questionTextView.layer.borderColor = UIColor.grayColor().CGColor
            questionTextView.textColor = UIColor.lightGrayColor()
            questionTextView.text = "Quiz Question"
            if let question = quizArray[i].valueForKey("quiz_question")
            {
                let encodedData = question.dataUsingEncoding(NSUTF8StringEncoding)!
                
                let attributedOptions : [String: AnyObject] =
                [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                ]
                
                do
                {
                    
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    
                    
                    let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                    
                    questionTextView.text  = decodedString
                    
                    
                    
                }
                    
                catch
                {
                    
                    print("Fetch failed: \((error as NSError).localizedDescription)")
                    
                }

                //questionTextView.text = question as! String
                questionTextView.textColor = UIColor.blackColor()
            }
            questionTextView.font = UIFont(name: "Arial", size: 18)
            questionTextView.userInteractionEnabled = false
            questionTextView.editable = false
            questionTextView.selectable = false
            
            let ans1Btn = UIButton()
            ans1Btn.frame = CGRectMake(8, questionTextView.frame.origin.y + questionTextView.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            ans1Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans1Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans1Btn.addTarget(self, action: "ans1Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans1Btn.tag = (currentQuesCount*50) + 2
            
            let ans2Btn = UIButton()
            ans2Btn.frame = CGRectMake(8, ans1Btn.frame.origin.y + ans1Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            
            print(0.094 * questionScrollView.frame.height)
            ans2Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans2Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans2Btn.addTarget(self, action: "ans2Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans2Btn.tag = (currentQuesCount*50) + 3
            
            
            let ans3Btn = UIButton()
            ans3Btn.frame = CGRectMake(8, ans2Btn.frame.origin.y + ans2Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            ans3Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans3Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans3Btn.addTarget(self, action: "ans3Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans3Btn.tag = (currentQuesCount*50) + 4
          
            
            let ans4Btn = UIButton()
            ans4Btn.frame = CGRectMake(8, ans3Btn.frame.origin.y + ans3Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            ans4Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans4Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans4Btn.addTarget(self, action: "ans4Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans4Btn.tag = (currentQuesCount*50) + 5
            
            
            let ans1TxtField = UITextField()
            ans1TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, questionTextView.frame.origin.y + questionTextView.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.094 * questionScrollView.frame.height))
            ans1TxtField.userInteractionEnabled = false
            ans1TxtField.tag = (currentQuesCount*50) + 6
            ans1TxtField.placeholder = "Ans1"
            ans1TxtField.font = UIFont(name: "Arial", size: 18)
            
            let ans1LineView = UIView()
            ans1LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans1TxtField.frame.origin.y + ans1TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.0023 * questionScrollView.frame.height))
            ans1LineView.backgroundColor = UIColor.lightGrayColor()
            
            if let ans1 = optionsArray[0].valueForKey("quiz_option")
            {
                ans1TxtField.text = ans1 as? String
                
            }
            
            let ans2TxtField = UITextField()
            ans2TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans1TxtField.frame.origin.y + ans1TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.094 * questionScrollView.frame.height))
            ans2TxtField.userInteractionEnabled = false
            ans2TxtField.placeholder = "Ans2"
            ans2TxtField.tag = (currentQuesCount*50) + 7
            ans2TxtField.font = UIFont(name: "Arial", size: 18)
            
            
            let ans2LineView = UIView()
            ans2LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans2LineView.backgroundColor = UIColor.lightGrayColor()

            ans2Btn.hidden = true
            ans2TxtField.hidden = true
            ans2LineView.hidden = true
            if optionsArray.count > 1
            {
                ans2Btn.hidden = false
                ans2TxtField.hidden = false
                ans2LineView.hidden = false
                
            if let ans2 = optionsArray[1].valueForKey("quiz_option")
            {
                ans2TxtField.text = ans2 as? String
                
            }
            }
            
            
            
            
            let ans3TxtField = UITextField()
            ans3TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
            ans3TxtField.userInteractionEnabled = false
            ans3TxtField.tag = (currentQuesCount*50) + 8
            ans3TxtField.placeholder = "Ans3"
            ans3TxtField.font = UIFont(name: "Arial", size: 18)
            
            let ans3LineView = UIView()
            ans3LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans3LineView.backgroundColor = UIColor.lightGrayColor()

            
            ans3Btn.hidden = true
            ans3TxtField.hidden = true
            ans3LineView.hidden = true
            
            if optionsArray.count > 2
            {
                ans3Btn.hidden = false
                ans3TxtField.hidden = false
                ans3LineView.hidden = false
            if let ans3 = optionsArray[2].valueForKey("quiz_option")
            {
                ans3TxtField.text = ans3 as? String
                
            }
            }
            
            
            let ans4TxtField = UITextField()
            ans4TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
            ans4TxtField.userInteractionEnabled = false
            ans4TxtField.tag = (currentQuesCount*50) + 9
            ans4TxtField.placeholder = "Ans4"
            ans4TxtField.font = UIFont(name: "Arial", size: 18)
            
            let ans4LineView = UIView()
            ans4LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans4TxtField.frame.origin.y + ans4TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans4LineView.backgroundColor = UIColor.lightGrayColor()

            ans4Btn.hidden = true
            ans4TxtField.hidden = true
            ans4LineView.hidden = true

            if optionsArray.count > 3
            {
                ans4Btn.hidden = false
                ans4TxtField.hidden = false
                ans4LineView.hidden = false
                

            if let ans4 = optionsArray[3].valueForKey("quiz_option")
            {
                ans4TxtField.text = ans4 as? String
                
            }
            }
            
            
            let view1 = UIView()
            view1.frame = CGRectMake(CGFloat(y),lessonView.frame.origin.y ,  questionScrollView.frame.width, questionScrollView.frame.height)
            print(ans4LineView.frame.origin.y + ans4LineView.frame.size.height)
            view1.addSubview(questionTextView)
            view1.addSubview(ans1Btn)
            view1.addSubview(ans2Btn)
            view1.addSubview(ans3Btn)
            view1.addSubview(ans4Btn)
            view1.addSubview(ans1LineView)
            view1.addSubview(ans2LineView)
            view1.addSubview(ans3LineView)
            view1.addSubview(ans4LineView)
            view1.addSubview(ans1TxtField)
            view1.addSubview(ans2TxtField)
            view1.addSubview(ans3TxtField)
            view1.addSubview(ans4TxtField)
            
            questionScrollView.addSubview(view1)
            
            y = y + Int(view1.frame.width)
            questionScrollView.contentSize.width = CGFloat(y)
            print(questionScrollView.contentOffset.x)
            
            
        }
        
        })
    }
    
    //MARK:- Answers Button
    
    func ans1Btn(sender:UIButton)
    {
        var index = Int()
        
        index = (sender.tag % 50) - 2 + Int(sender.tag / 50) - 1
        
        print(index)
        correctAnsArray[index] = "0"
        sender.selected = true
        let random1: UIButton = self.view!.viewWithTag(sender.tag+1) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag+2) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag+3) as! UIButton
        random1.selected = false
        random2.selected = false
        random3.selected = false
        
        startTimer()

    }
    
    func ans2Btn(sender:UIButton)
    {
        var index = Int()
        
        index = (sender.tag % 50) - 3 + Int(sender.tag / 50) - 1
        correctAnsArray[index] = "1"
        sender.selected = true
        let random1: UIButton = self.view!.viewWithTag(sender.tag-1) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag+1) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag+2) as! UIButton
        random1.selected = false
        random2.selected = false
        random3.selected = false
        
        startTimer()
        
    }
    
    func ans3Btn(sender:UIButton)
    {
        var index = Int()
        index = (sender.tag % 50) - 4 + Int(sender.tag / 50) - 1
        correctAnsArray[index] = "2"
        sender.selected = true
        let random1: UIButton = self.view!.viewWithTag(sender.tag-2) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag-1) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag+1) as! UIButton
        random1.selected = false
        random2.selected = false
        random3.selected = false
        
        startTimer()
        

    }
    
    func ans4Btn(sender:UIButton)
    {
        var index = Int()
        index = (sender.tag % 50) - 5 + Int(sender.tag / 50) - 1
        
        correctAnsArray[index] = "3"
        sender.selected = true
        let random1: UIButton = self.view!.viewWithTag(sender.tag-3) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag-2) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag-1) as! UIButton
        random1.selected = false
        random2.selected = false
        random3.selected = false
        
        startTimer()
        

    }
    
    func startTimer()
    {
        if timerEnable == false
        {
        countDown()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
            timerEnable = true
            
            self.navigationItem.leftBarButtonItem = nil
        }

    }
    
    func anwerStr()
    {
        
            
        
        var errorCheck = Bool()
        errorCheck = true
        
        var ansText = NSString()
        

           let  i = Int(self.questionScrollView.contentOffset.x / self.questionScrollView.frame.size.width)
        
        
            let QuestionNo = String(i+1)
            let questionID = quizArray[i].valueForKey("quizzes_id") as! String
            
            
            
            if correctAnsArray[i] == "0"
            {
               ansText = (self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text!
            }
            if correctAnsArray[i] == "1"
            {
                ansText = (self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text!
            }
            if correctAnsArray[i] == "2"
            {
                ansText = (self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text!
            }
            if correctAnsArray[i] == "3"
            {
                ansText = (self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text!
            }
            
            
            if correctAnsArray[i] == "4"
            {
                 errorCheck = false
                let alert = UIAlertView(title: "Alert", message: "Please select the answer", delegate: self, cancelButtonTitle: "OK")
                alert.show()
               
            }
            
            else
            {
            errorCheck = true
            if i == 0
            {
                
            str =  String(format: "\"%@\":{\"question_id\":\"%@\",\"useranswer\":\"%@\",\"correct_answer\":\"%@\"}", QuestionNo,questionID,correctAnsArray[i],ansText)
            
            }
            else
            {
                str =  String(format: "%@,\"%@\":{\"question_id\":\"%@\",\"useranswer\":\"%@\",\"correct_answer\":\"%@\"}",str, QuestionNo,questionID,correctAnsArray[i],ansText)
                
            }
                if i == quizArray.count - 1
                {
                    submitMyAns.setTitle("Submit Answer", forState: .Normal)
                }
                else
                {
                UIView.animateWithDuration(0.5, animations:
                    {
                    
                    self.questionScrollView.contentOffset.x = self.questionScrollView.contentOffset.x + self.questionScrollView.frame.size.width
                    
                })
                }
                
                
            }
            
     
        
        
   
    }
    
}



