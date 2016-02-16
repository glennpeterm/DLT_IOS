//
//  QuizQuestionViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class QuizQuestionViewController: UIViewController,UIScrollViewDelegate
{
    
    
    @IBOutlet var rightArrow: UIImageView!
    @IBOutlet var NOQuesLbl: UILabel!
    @IBOutlet var leftArrow: UIImageView!
    @IBOutlet var questionScrollView: UIScrollView!
    
    
    @IBOutlet var descriptionName: UITextView!
    
    
    @IBOutlet var titleName: UILabel!
   
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    
    var quizID = NSString()
    var titleN = NSString()
    var descN = NSString()
    var editArrayAns = NSArray()
     var y :Int = 0
    @IBOutlet var lessonView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getDataBeforeEditApi()
        
        questionScrollView.delegate = self
        
        self.navigationController?.navigationBarHidden = false
        
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(false)
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
            let cla_classid_eid = NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
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
                             
                                let editDict = jsonResults?.valueForKey("data") as? NSDictionary
                                
                                let quizInfo = editDict?.valueForKey("quiz_info") as! NSDictionary
                                
                                if let title = quizInfo.valueForKey("quiz_name")
                                {
                                    
                                    self.titleName.text = title as? String
                                }
                                
                                if let desc = quizInfo.valueForKey("quiz_desc")
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
                                        
                                        self.descriptionName.text  = decodedString
                                        
                                        
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }

                                   // self.descriptionName.text = desc as? String
                                
                                }
                                
                                if let arr = editDict?.valueForKey("quiz_question")
                                {
                                
                                   self.editArrayAns = arr as! NSArray
                                }
                                self.NOQuesLbl.text = "Question \(1) of \(self.editArrayAns.count)"
                                
                                if self.editArrayAns.count == 1
                                {
                                    self.leftArrow.hidden = true
                                    self.rightArrow.hidden = true
                                }
                                else
                                {
                                    self.leftArrow.hidden = true
                                    self.rightArrow.hidden = false

                                }
                                
                                
                                self.editQuestion()
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
    
    
    func editQuestion()
    {
        for var i = 0 ; i < editArrayAns.count ; i++
        {
            let dict = editArrayAns[i].valueForKey("quiz_options") as! NSDictionary
            let optionsArray = dict.valueForKey("options") as! NSArray
            questionScrollView.pagingEnabled = true
            let questionTextView = UITextView(frame: CGRectMake(8,10,view.frame.size.width - 16, 0.43 * questionScrollView.frame.height))
            questionTextView.layer.cornerRadius = 5
            questionTextView.layer.borderWidth = 1
            questionTextView.layer.borderColor = UIColor.grayColor().CGColor
            questionTextView.textColor = UIColor.lightGrayColor()
            questionTextView.text = "Quiz Question"
            if let question = editArrayAns[i].valueForKey("question_name")
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

                
               // questionTextView.text = question as! String
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
            
            if optionsArray[0].valueForKey("correct_answer") as! String == "1"
            {
                ans1Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Normal)
            }
            ans1Btn.addTarget(self, action: "ans1Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans1Btn.userInteractionEnabled = false
            
            
            
            let ans2Btn = UIButton()
            ans2Btn.frame = CGRectMake(8, ans1Btn.frame.origin.y + ans1Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            
            //(0.094 * questionScrollView.frame.height)
            
            ans2Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans2Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans2Btn.addTarget(self, action: "ans2Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans2Btn.userInteractionEnabled = false
             ans2Btn.hidden = true
            if optionsArray.count > 1
            {
                ans2Btn.hidden = false
            if optionsArray[1].valueForKey("correct_answer") as! String == "1"
            {
                ans2Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Normal)
            }
            }
          
            
            
            let ans3Btn = UIButton()
            
            ans3Btn.frame = CGRectMake(8, ans2Btn.frame.origin.y + ans2Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            
            ans3Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans3Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans3Btn.addTarget(self, action: "ans3Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans3Btn.userInteractionEnabled = false
            
            ans3Btn.hidden = true
            if optionsArray.count > 2
            {
                ans3Btn.hidden = false
            if optionsArray[2].valueForKey("correct_answer") as! String == "1"
            {
                ans3Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Normal)
            }
            }
           
            
            
            let ans4Btn = UIButton()
            
            ans4Btn.frame = CGRectMake(8, ans3Btn.frame.origin.y + ans3Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            
            ans4Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans4Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans4Btn.addTarget(self, action: "ans4Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans4Btn.userInteractionEnabled = false
            
            ans4Btn.hidden = true
            if optionsArray.count > 3
            {
             ans4Btn.hidden = false
            if optionsArray[3].valueForKey("correct_answer") as! String == "1"
            {
                ans4Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Normal)
            }
            }
           
            
            
            let ans1TxtField = UITextField()
            ans1TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, questionTextView.frame.origin.y + questionTextView.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.094 * questionScrollView.frame.height))
            ans1TxtField.userInteractionEnabled = false
            
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
            ans2TxtField.font = UIFont(name: "Arial", size: 18)

            let ans2LineView = UIView()
            ans2LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans2LineView.backgroundColor = UIColor.lightGrayColor()
            
            ans2TxtField.hidden = true
            ans2LineView.hidden = true
            if optionsArray.count > 1
            {
                ans2TxtField.hidden = false
                ans2LineView.hidden = false
            if let ans2 = optionsArray[1].valueForKey("quiz_option")
            {
                ans2TxtField.text = ans2 as? String
                
            }
            }
            
            //ans2TxtField.tag = (currentQuesCount*50) + 7
           // ans2TxtField.delegate = self
            
            
            
            let ans3TxtField = UITextField()
            ans3TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
           ans3TxtField.userInteractionEnabled = false
            
            ans3TxtField.placeholder = "Ans3"
             ans3TxtField.font = UIFont(name: "Arial", size: 18)
            
            let ans3LineView = UIView()
            ans3LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans3LineView.backgroundColor = UIColor.lightGrayColor()

            ans3TxtField.hidden = true
            ans3LineView.hidden = true
            if optionsArray.count > 2
            {
                ans3TxtField.hidden = false
                ans3LineView.hidden = false
            
            if let ans3 = optionsArray[2].valueForKey("quiz_option")
            {
                ans3TxtField.text = ans3 as? String
                
            }
            }
           
           // ans3TxtField.tag = (currentQuesCount*50) + 8
            
            
            let ans4TxtField = UITextField()
            ans4TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
            ans4TxtField.userInteractionEnabled = false
            ans4TxtField.placeholder = "Ans4"
            ans4TxtField.font = UIFont(name: "Arial", size: 18)
            
            let ans4LineView = UIView()
            ans4LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans4TxtField.frame.origin.y + ans4TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans4LineView.backgroundColor = UIColor.lightGrayColor()
            
            ans4TxtField.hidden = true
            ans4LineView.hidden = true
            
            if optionsArray.count > 3
            {
                ans4TxtField.hidden = false
                ans4LineView.hidden = false
            if let ans4 = optionsArray[3].valueForKey("quiz_option")
            {
                ans4TxtField.text = ans4 as? String
                
            }
            }
            
           // ans4TxtField.tag = (currentQuesCount*50) + 9
            
           
            
            
            let view1 = UIView()
            
            view1.frame = CGRectMake(CGFloat(y),lessonView.frame.origin.y ,  questionScrollView.frame.width, questionScrollView.frame.height)
            
            //(ans4LineView.frame.origin.y + ans4LineView.frame.size.height)
            
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
            
//            UIView.animateWithDuration(0.5, animations: {
//                
//                self.questionScrollView.contentOffset.x = CGFloat(self.y) - view1.frame.width
//                
//            })
            //(questionScrollView.contentOffset.x)
            
        }
        
    }
    
    
    //MARK:- ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView == questionScrollView
        {
            
            let pageNo = Int(questionScrollView.contentOffset.x/questionScrollView.frame.width) + 1
            NOQuesLbl.text = "Question \(pageNo) of \(editArrayAns.count)"
            
            if pageNo == 1
            {
                leftArrow.hidden = true
            }
            else
                
            {
                leftArrow.hidden = false
            }
            
            if pageNo == editArrayAns.count
            {
                rightArrow.hidden = true
            }
            else
                
            {
                rightArrow.hidden = false
            }
            
            
        }
    }
    

}
