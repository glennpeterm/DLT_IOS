//
//  ScheduleDescriptionViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/25/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var scheduleDescriptionBool = Bool()

class ScheduleDescriptionViewController: UIViewController
{

    var showScheduleDiscriptionStr = NSString()
    
    @IBOutlet var descriptionView: RichTextEditor!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        descriptionView.becomeFirstResponder()
        
        descriptionView.text = showScheduleDiscriptionStr as String
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        

       
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //(frame)
        
        descriptionView.frame.size.height = view.frame.size.height - frame.size.height
        
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK:- Back Button
    
    @IBAction func backbtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK:- Done Button
    
    @IBAction func doneBtn(sender: AnyObject)
    {
        ScheduleDataShowDescriptionBool = false
        scheduleDescriptionBool = true
        scheduleDescriptionStr  = descriptionView.text
       self.navigationController?.popViewControllerAnimated(true)
    }

   
}
