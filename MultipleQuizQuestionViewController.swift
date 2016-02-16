//
//  MultipleQuizQuestionViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 12/29/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

class MultipleQuizQuestionViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate
{
    var correctAns = String()
    var correctAnsArray: [String] = []
   
    @IBOutlet var questionScrollView: UIScrollView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    var editQuestionBool = Bool()
   var editArrayAns = NSMutableArray()
   var textBool = Bool()
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var addMoreBtn: UIButton!
    
    var y :Int = 0
    var height:Int!
    
    
 
    var currentQuesCount = 0
    
    override func viewDidLoad()
    {
        //IQKeyboardManager.sharedManager().enable = true
        print(editArrayAns)
        if editQuestionBool == true
        {
            addMoreBtn.hidden = true
            
            saveBtn.frame = CGRectMake(8, view.frame.size.height - 60, view.frame.size.width - 16, 40)
            
            
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        if editQuestionBool == true
        {
            addMoreBtn.hidden = true
            
            editQuestion()
            
            
        }
        else
        {
            multipleQuestion()
        }
    }
    
    //MARK:- Save Button
    
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        
        
        if editQuestionBool == true
        {
            
           updateValues()
            
        }
        else
        {
            getValues()
        }
    }
    
    //MARK:- ADD More Button
    
    
    @IBAction func addMoreBtn(sender: AnyObject)
        
    {
        multipleQuestion()
    }
    
    //MARK:- Back Button
    
    @IBAction func BackBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
        //IQKeyboardManager.sharedManager().enable = false
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
        //(zoomView.frame.height)
        //(zoomView.frame.width)
    }
    
    //MARK:- Multiple Question Function
    
    func multipleQuestion()
    {
        correctAnsArray.append("0")
        currentQuesCount++
        
        questionScrollView.pagingEnabled = true
        let questionTextView = UITextView(frame: CGRectMake(8, 0.042 * questionScrollView.frame.height, view.frame.size.width - 16, 0.43 * questionScrollView.frame.height))
        questionTextView.layer.cornerRadius = 5
        questionTextView.layer.borderWidth = 1
        questionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        questionTextView.text = "Quiz Question"
        questionTextView.textColor = UIColor.lightGrayColor()
        questionTextView.font = UIFont(name: "Arial", size: 18)
        questionTextView.tag = (currentQuesCount*50) + 1
        
        questionTextView.delegate = self
        let ans1Btn = UIButton()
        
        ans1Btn.frame = CGRectMake(8, questionTextView.frame.origin.y + questionTextView.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
        
        ans1Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
        ans1Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
        
        ans1Btn.addTarget(self, action: "ans1Btn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        ans1Btn.tag = (currentQuesCount*50) + 2
      
        let ans2Btn = UIButton()
        ans2Btn.frame = CGRectMake(8, ans1Btn.frame.origin.y + ans1Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
        //(0.094 * questionScrollView.frame.height)
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
        
        ans1TxtField.tag = (currentQuesCount*50) + 6
        
       
        ans1TxtField.delegate = self
        
        ans1TxtField.placeholder = "Ans1"
        ans1TxtField.font = UIFont(name: "Arial", size: 18)
        
        let ans1LineView = UIView()
        ans1LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans1TxtField.frame.origin.y + ans1TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.0023 * questionScrollView.frame.height))
        ans1LineView.backgroundColor = UIColor.lightGrayColor()
        
        let ans2TxtField = UITextField()
        ans2TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans1TxtField.frame.origin.y + ans1TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.094 * questionScrollView.frame.height))
        
        ans2TxtField.placeholder = "Ans2"
        ans2TxtField.font = UIFont(name: "Arial", size: 18)
       
        ans2TxtField.tag = (currentQuesCount*50) + 7
        ans2TxtField.delegate = self
        let ans2LineView = UIView()
        ans2LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
        ans2LineView.backgroundColor = UIColor.lightGrayColor()
        
        
        let ans3TxtField = UITextField()
        ans3TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
        ans3TxtField.delegate = self
        
        ans3TxtField.placeholder = "Ans3"
        ans3TxtField.font = UIFont(name: "Arial", size: 18)
        ans3TxtField.tag = (currentQuesCount*50) + 8
        
        let ans3LineView = UIView()
        ans3LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
        ans3LineView.backgroundColor = UIColor.lightGrayColor()
        
        let ans4TxtField = UITextField()
        ans4TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
        ans4TxtField.delegate = self
        
        ans4TxtField.placeholder = "Ans4"
        ans4TxtField.font = UIFont(name: "Arial", size: 18)
        ans4TxtField.tag = (currentQuesCount*50) + 9
        
        let ans4LineView = UIView()
        ans4LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans4TxtField.frame.origin.y + ans4TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
        ans4LineView.backgroundColor = UIColor.lightGrayColor()
        
        
        let view1 = UIView()
        
        view1.frame = CGRectMake(0, CGFloat(y),  questionScrollView.frame.width, questionScrollView.frame.height)
        
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
        
        
        y = y + Int(view1.frame.height)
       
        
        questionScrollView.contentSize.height = CGFloat(y)
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.questionScrollView.contentOffset.y = CGFloat(self.y) - view1.frame.height
            
        })
        //(questionScrollView.contentOffset.y)
    }
    
    //MARK:- Answers Button
    
    func ans1Btn(sender:UIButton)
    {
        var index = Int()

        index = (sender.tag % 50) - 2 + Int(sender.tag / 50) - 1
        
        //(index)
        
        correctAnsArray[index] = "1"
        
       
            sender.selected = true
            correctAns = "1"
        
            let random1: UIButton = self.view!.viewWithTag(sender.tag+1) as! UIButton
            let random2: UIButton = self.view!.viewWithTag(sender.tag+2) as! UIButton
            let random3: UIButton = self.view!.viewWithTag(sender.tag+3) as! UIButton

            random1.selected = false
            random2.selected = false
            random3.selected = false
        
        //(correctAnsArray)
        
        
    }
    
    func ans2Btn(sender:UIButton)
    {
        var index = Int()
        
        index = (sender.tag % 50) - 3 + Int(sender.tag / 50) - 1
        
        correctAnsArray[index] = "2"
        
        sender.selected = true
        correctAns = "1"
        
        let random1: UIButton = self.view!.viewWithTag(sender.tag-1) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag+1) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag+2) as! UIButton
        
        random1.selected = false
        random2.selected = false
        random3.selected = false
        
        
        //(correctAnsArray)
        
       
    }
    
    func ans3Btn(sender:UIButton)
    {
        var index = Int()
        
        index = (sender.tag % 50) - 4 + Int(sender.tag / 50) - 1
        
        correctAnsArray[index] = "3"
        
        
        sender.selected = true
        correctAns = "1"
        
        let random1: UIButton = self.view!.viewWithTag(sender.tag-2) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag-1) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag+1) as! UIButton
        
        random1.selected = false
        random2.selected = false
        random3.selected = false
        
       
        
        //(correctAnsArray)
        
    }
    
    func ans4Btn(sender:UIButton)
    {
        var index = Int()
        
        index = (sender.tag % 50) - 5 + Int(sender.tag / 50) - 1
        
        correctAnsArray[index] = "4"
        sender.selected = true
        correctAns = "1"
        let random1: UIButton = self.view!.viewWithTag(sender.tag-3) as! UIButton
        let random2: UIButton = self.view!.viewWithTag(sender.tag-2) as! UIButton
        let random3: UIButton = self.view!.viewWithTag(sender.tag-1) as! UIButton
        random1.selected = false
        random2.selected = false
        random3.selected = false
        //(correctAnsArray)
        
    }
    
    
    
    //MARK:- EditQuestion
    
    func editQuestion()
    {
        for var i = 0 ; i < editArrayAns.count ; i++
        {
            correctAnsArray.append("0")
            currentQuesCount++
            
            let dict = editArrayAns[i].valueForKey("quiz_options") as! NSDictionary
            let optionsArray = dict.valueForKey("options") as! NSArray
            
            questionScrollView.pagingEnabled = true
            let questionTextView = UITextView(frame: CGRectMake(8, 0.042 * questionScrollView.frame.height, view.frame.size.width - 16, 0.43 * questionScrollView.frame.height))
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

                //questionTextView.text = question as! String
                  questionTextView.textColor = UIColor.blackColor()
            }
            
          
            questionTextView.font = UIFont(name: "Arial", size: 18)
            questionTextView.tag = (currentQuesCount*50) + 1
            
            questionTextView.delegate = self
            let ans1Btn = UIButton()
            
            ans1Btn.frame = CGRectMake(8, questionTextView.frame.origin.y + questionTextView.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            
            ans1Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans1Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            
            if optionsArray[0].valueForKey("correct_answer") as! String == "1"
            {
                ans1Btn.selected = true
            }
            ans1Btn.addTarget(self, action: "ans1Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            
            ans1Btn.tag = (currentQuesCount*50) + 2
            
            let ans2Btn = UIButton()
            
            ans2Btn.frame = CGRectMake(8, ans1Btn.frame.origin.y + ans1Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            
            //(0.094 * questionScrollView.frame.height)
            
            ans2Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans2Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans2Btn.addTarget(self, action: "ans2Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans2Btn.tag = (currentQuesCount*50) + 3

            ans2Btn.hidden = true
            if optionsArray.count>1
            {
                ans2Btn.hidden = false
            if optionsArray[1].valueForKey("correct_answer") as! String == "1"
            {
                ans2Btn.selected = true
            }
            }
            
            
            let ans3Btn = UIButton()
            ans3Btn.frame = CGRectMake(8, ans2Btn.frame.origin.y + ans2Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            ans3Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans3Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans3Btn.addTarget(self, action: "ans3Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans3Btn.tag = (currentQuesCount*50) + 4
            
            ans3Btn.hidden = true
            if optionsArray.count>2
            {
                ans3Btn.hidden = false
            if optionsArray[2].valueForKey("correct_answer") as! String == "1"
            {
                ans3Btn.selected = true
            }
            }
            
            
            
            let ans4Btn = UIButton()
            ans4Btn.frame = CGRectMake(8, ans3Btn.frame.origin.y + ans3Btn.frame.size.height + (0.035 * questionScrollView.frame.height), 40, 0.094 * questionScrollView.frame.height)
            ans4Btn.setBackgroundImage(UIImage(named: "check-edit.png"), forState: .Normal)
            ans4Btn.setBackgroundImage(UIImage(named: "check-edit-sel.png"), forState: UIControlState.Selected)
            ans4Btn.addTarget(self, action: "ans4Btn:", forControlEvents: UIControlEvents.TouchUpInside)
            ans4Btn.tag = (currentQuesCount*50) + 5

            ans4Btn.hidden = true
            if optionsArray.count>3
            {
            ans4Btn.hidden = false
            if optionsArray[3].valueForKey("correct_answer") as! String == "1"
            {
                ans4Btn.selected = true
            }
            }
            let ans1TxtField = UITextField()
            ans1TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, questionTextView.frame.origin.y + questionTextView.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.094 * questionScrollView.frame.height))
            
            ans1TxtField.tag = (currentQuesCount*50) + 6
            
            
            ans1TxtField.delegate = self
            
            ans1TxtField.placeholder = "Ans1"
            
            if let ans1 = optionsArray[0].valueForKey("quiz_option")
            {
                ans1TxtField.text = ans1 as? String
                
            }
            ans1TxtField.font = UIFont(name: "Arial", size: 18)
            
            let ans1LineView = UIView()
            ans1LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans1TxtField.frame.origin.y + ans1TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.0023 * questionScrollView.frame.height))
            ans1LineView.backgroundColor = UIColor.lightGrayColor()
            
            let ans2TxtField = UITextField()
            ans2TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans1TxtField.frame.origin.y + ans1TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, (0.094 * questionScrollView.frame.height))
            ans2TxtField.placeholder = "Ans2"
            ans2TxtField.font = UIFont(name: "Arial", size: 18)
            ans2TxtField.tag = (currentQuesCount*50) + 7
            ans2TxtField.delegate = self
            
            let ans2LineView = UIView()
            ans2LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans2LineView.backgroundColor = UIColor.lightGrayColor()
            
            ans2TxtField.hidden = true
            ans2LineView.hidden = true
            ans2TxtField.text = " "
            if optionsArray.count>1
            {
                ans2TxtField.hidden = false
                ans2LineView.hidden = false

            if let ans2 = optionsArray[1].valueForKey("quiz_option")
            {
                ans2TxtField.text = ans2 as? String
                
            }
            }
            
            
            
            let ans3TxtField = UITextField()
            ans3TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans2TxtField.frame.origin.y + ans2TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
            ans3TxtField.delegate = self
            ans3TxtField.placeholder = "Ans3"
            ans3TxtField.font = UIFont(name: "Arial", size: 18)
            ans3TxtField.tag = (currentQuesCount*50) + 8
            
            
            let ans3LineView = UIView()
            ans3LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans3LineView.backgroundColor = UIColor.lightGrayColor()
            
            ans3TxtField.hidden = true
            ans3LineView.hidden = true
            ans3TxtField.text = " "
            if optionsArray.count>2
            {
                ans3TxtField.hidden = false
                ans3LineView.hidden = false
            if let ans3 = optionsArray[2].valueForKey("quiz_option")
            {
                ans3TxtField.text = ans3 as? String
                
            }
            }
           
            
          
            
            let ans4TxtField = UITextField()
            ans4TxtField.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans3TxtField.frame.origin.y + ans3TxtField.frame.size.height + (0.035 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.094 * questionScrollView.frame.height)
            ans4TxtField.delegate = self
            ans4TxtField.placeholder = "Ans4"
            ans4TxtField.font = UIFont(name: "Arial", size: 18)
            ans4TxtField.tag = (currentQuesCount*50) + 9
            
            let ans4LineView = UIView()
            ans4LineView.frame = CGRectMake(ans1Btn.frame.origin.x + ans1Btn.frame.size.width + 10, ans4TxtField.frame.origin.y + ans4TxtField.frame.size.height + (0.007 * questionScrollView.frame.height), questionTextView.frame.size.width - ans1Btn.frame.size.width - 10, 0.0023 * questionScrollView.frame.height)
            ans4LineView.backgroundColor = UIColor.lightGrayColor()
            
            ans4TxtField.hidden = true
            ans4LineView.hidden = true
            ans4TxtField.text = " "
            if optionsArray.count > 3
            {
                ans4TxtField.hidden = false
                ans4LineView.hidden = false
            if let ans4 = optionsArray[3].valueForKey("quiz_option")
            {
                ans4TxtField.text = ans4 as? String
                
            }
            }

            
            let view1 = UIView()
            view1.frame = CGRectMake(0, CGFloat(y),  questionScrollView.frame.width, questionScrollView.frame.height)
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
            
            
            y = y + Int(view1.frame.height)
            
            
            questionScrollView.contentSize.height = CGFloat(y)
            

            //(questionScrollView.contentOffset.y)

        }
        
    }
    
    
    //MARK:- GetTag
    func getValues()
    {
        
        var str = ""

        var errorCheck = Bool()
         errorCheck = true
        for var i = 0; i < correctAnsArray.count ; i++
        {
            
            if (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! == "" ||  (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! == "Quiz Question" || (self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text! == "" || (self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text! == "" || (self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text! == "" || (self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text! == ""
            {
                errorCheck = false
                let alert = UIAlertView(title: "", message: "Please fill required Fields", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                break
            }
            else if correctAnsArray[i] == "0"
            {
                errorCheck = false
                let alert = UIAlertView(title: "", message: "Please Select the answer", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                break
            }
            else
            {
            
            let strInt = String(i+1)
            if i == 0
            {
                
            str = String(format: "\"%@\":{\"correct_ans\":\"%@\",\"quiz_ans_1\":\"%@\",\"quiz_ans_2\":\"%@\",\"quiz_ans_3\":\"%@\",\"quiz_ans_4\":\"%@\",\"quiz_question\":\"%@\"}",strInt,correctAnsArray[i],(self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!)
            }
            else
            
            {
                str = String(format: "%@,\"%@\":{\"correct_ans\":\"%@\",\"quiz_ans_1\":\"%@\",\"quiz_ans_2\":\"%@\",\"quiz_ans_3\":\"%@\",\"quiz_ans_4\":\"%@\",\"quiz_question\":\"%@\"}",str,strInt,correctAnsArray[i],(self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text!,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!)
            }
                 quizLessonQuizQuestionStr = (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!
            }
            }
        
        if errorCheck == true
        {
        str = String (format: "{%@}", str)
            
        
        print(str)
        multipleQuizQuestionStr = str
        quizLessonQuizQUestionBool = true
           //IQKeyboardManager.sharedManager().enable = false
        self.navigationController?.popViewControllerAnimated(true)
            
        }
}
   
    func updateValues()
    {
        var str = ""
        
        var errorCheck = Bool()
        errorCheck = true
        for var i = 0; i < editArrayAns.count ; i++
        {
            let ans1CR = String(Int((self.view!.viewWithTag(((i+1)*50) + 2) as! UIButton).selected))
            let ans2CR = String(Int((self.view!.viewWithTag(((i+1)*50) + 3) as! UIButton).selected))
            let ans3CR = String(Int((self.view!.viewWithTag(((i+1)*50) + 4) as! UIButton).selected))
            let ans4CR = String(Int((self.view!.viewWithTag(((i+1)*50) + 5) as! UIButton).selected))
            
            if (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! == "" ||  (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! == "Quiz Question" || (self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text! == "" || (self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text! == "" || (self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text! == "" || (self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text! == ""
            {
                errorCheck = false
                let alert = UIAlertView(title: "", message: "Please fill required Fields", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                break
            }
//            else if ans1CR == "0" && ans2CR == "0" && ans3CR == "0" && ans4CR == "0"
//            {
//                errorCheck = false
//                let alert = UIAlertView(title: "", message: "Please Select the answer", delegate: nil, cancelButtonTitle: "OK")
//                alert.show()
//                break
//            }
            else
            {
            
            let questionID = editArrayAns[i].valueForKey("question_id") as! String
            
            let dict = editArrayAns[i].valueForKey("quiz_options") as! NSMutableDictionary
            
            let optionArray = dict.valueForKey("options") as! NSMutableArray
            
                print(optionArray)
           // index = (sender.tag % 50) - 2 + Int(sender.tag / 50) - 1
            //(Int((self.view!.viewWithTag(((i+1)*50) + 2) as! UIButton).selected))
               // let strInt = String(i+1)
            
                if i == 0
                {
                    str = String(format: "{\"quiz_question\":[{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[0].valueForKey("option_id") as! String,optionArray[0].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text!,ans1CR as String)
                    
                    
                    if optionArray.count > 1
                    {
                        str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[1].valueForKey("option_id") as! String,optionArray[1].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text!,ans2CR as String)
                        
                    }
                    
                    
                    
                    if optionArray.count > 2
                    {
                        str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[2].valueForKey("option_id") as! String,optionArray[2].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text!,ans3CR as String)
                        
                    }

                    
                    if optionArray.count > 3
                    {
                        str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[3].valueForKey("option_id") as! String,optionArray[3].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text!,ans4CR as String)

                    }

                    
                    
                }
                else
                    
                {
                    
                    str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[0].valueForKey("option_id") as! String,optionArray[0].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 6) as! UITextField).text!,ans1CR as String)
                    
                    if optionArray.count > 1
                    {
                        str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[1].valueForKey("option_id") as! String,optionArray[1].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 7) as! UITextField).text!,ans2CR as String)
                        
                    }
                    

                    
                    if optionArray.count > 2
                    {
                        str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[2].valueForKey("option_id") as! String,optionArray[2].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 8) as! UITextField).text!,ans3CR as String)
                        
                    }

                    
                    if optionArray.count > 3
                    {
                        str = String(format: "%@,{\"question_id\":\"%@\",\"question_name\":\"%@\",\"quiz_options\":{\"options\":[{\"option_id\":\"%@\",\"quizzes_id\":\"%@\",\"quiz_option\":\"%@\",\"correct_answer\":\"%@\"}]}}",str,questionID,(self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!,optionArray[3].valueForKey("option_id") as! String,optionArray[3].valueForKey("quizzes_id") as! String,(self.view!.viewWithTag(((i+1)*50) + 9) as! UITextField).text!,ans4CR as String)
                        
                    }


                }
                
                quizLessonQuizQuestionStr = (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text!
           }
        }
        
        if errorCheck == true
        {
            str = String (format: "%@]}", str)
            print(str)
            multipleQuizQuestionStr = str
            quizLessonQuizQUestionBool = true
            //IQKeyboardManager.sharedManager().enable = false
            self.navigationController?.popViewControllerAnimated(true)
            
        }

        
    }
    

    
    //MARK:- TextView Delegate
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        for var i = 0; i < correctAnsArray.count ; i++
        {
            if (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! == "Quiz Question"
            {
                (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! = ""
            }
             (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).textColor = UIColor.blackColor()
        }
        
        

    }
    
    
    func textViewDidEndEditing(textView: UITextView)
    {
        for var i = 0; i < correctAnsArray.count ; i++
        {
        
        if (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! == ""
        {
            (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! = "Quiz Question"
        }
        
        
        if (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).text! ==  "Quiz Question"
        {
            (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).textColor = UIColor.lightGrayColor()
        }
        else
        {
             (self.view!.viewWithTag(((i+1)*50) + 1) as! UITextView).textColor = UIColor.blackColor()
        }
        
        }
    }
 
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    
    //MARK:- TextField Delegate
    
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
          print(textField.frame.origin.y)
        if textField.frame.origin.y + 60 > self.view.frame.size.height - 250
            
        {
            UIView.animateWithDuration(0.3, animations: {
                
           
                self.textBool = true
                self.view.frame.origin.y -= 190
                
             })
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textBool == true
        {
            UIView.animateWithDuration(0.3, animations: {
                self.textBool = false
                self.view.frame.origin.y +=  190
                
            })

        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}