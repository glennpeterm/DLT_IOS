//
//  QuizLessonDescriptionViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 12/3/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class QuizLessonDescriptionViewController: UIViewController,UITextViewDelegate
{

    @IBOutlet var decriptionTxtView: RichTextEditor!
    
    var descriptionStr = NSString()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
       
        decriptionTxtView.delegate = self
        decriptionTxtView.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
         
        
        decriptionTxtView.text = descriptionStr as String
    }
    
    
    func keyboardWillShow(notification: NSNotification)
    {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //(frame)
        
        decriptionTxtView.frame.size.height = view.frame.size.height - frame.size.height
        
    }
    //MARK:- Back Button
    
    @IBAction func backbtn(sender: AnyObject)
    {
       
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Done Button
    
    @IBAction func doneBtn(sender: AnyObject)
    {
        quizLessonDescriptionBool = true
        quizLessonDescriptionStr = decriptionTxtView.text as String
        
        self.navigationController?.popViewControllerAnimated(true)
    }


    
   

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    

    
}
