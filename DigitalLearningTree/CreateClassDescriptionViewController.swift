//
//  CreateClassDescriptionViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/19/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var createClassDescriptionBool = Bool()
var editClassDescriptionBool = Bool()
var addCurriculumDescriptionBool = Bool()



class CreateClassDescriptionViewController: UIViewController,UITextViewDelegate
{
    var showEditDescriptionStr = NSString()
    var showCurriculumDescriptionStr = NSString()

    @IBOutlet var descriptionTxtView: RichTextEditor!
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

      
        
        
        descriptionTxtView.delegate = self
        descriptionTxtView.becomeFirstResponder()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        if EditClassBool == true
        {
            descriptionTxtView.text = showEditDescriptionStr as String
        }
        
        if addCurrciculumBool == true
        {
            descriptionTxtView.text = showCurriculumDescriptionStr as String
        }
       
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //(frame)
        
        descriptionTxtView.frame.size.height = view.frame.size.height - frame.size.height
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
    

    //MARK:- Back Button
    
    @IBAction func backbtn(sender: AnyObject)
    {
        createClassBool = false
        EditClassBool = false
        addCurrciculumBool = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK:- Done Button
    
    @IBAction func doneBtn(sender: AnyObject)
    {
        if createClassBool == true
        {
            createClassBool = false
            createClassDescriptionBool = true
           createClassDescriptionString = descriptionTxtView.text
            
        }
        
        if EditClassBool == true
        {
            EditdataShowGetBackDescriptionBool = false
            EditClassBool = false
            editClassDescriptionBool = true
            EditClassDescrptionString = descriptionTxtView.text
        }
        
        if  addCurrciculumBool == true
        {
            CurriculumDataShowDescriptionBool = false
            addCurrciculumBool = false
            addCurriculumDescriptionBool = true
            addCurriculumDescriptionStr = descriptionTxtView.text
            
        }
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
