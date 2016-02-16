//
//  OtherViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/19/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController,UITextViewDelegate
{
    var otherID = NSString()

    @IBOutlet var othertextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        othertextView.delegate = self
        
        othertextView.becomeFirstResponder()

        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    

   //MARK:- Save Button

    @IBAction func saveBtn(sender: AnyObject)
    {
        
        if createClassBool == true
        {
            
            CreatetopicCheckBool = true
            createClassBool = false
           
            CreateClasstopicOptionString = othertextView.text!
            CreateClassOtherTxtString = othertextView.text!
            NSUserDefaults.standardUserDefaults().setValue(otherID, forKey: "topicID")
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(CreateClassViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
        }
        
       if EditClassBool == true
            
        {
            
            editClassTopicString = othertextView.text!
            EditClassOtherTxtString = othertextView.text!
            editClasstopicCheckBool = true
            
            
            NSUserDefaults.standardUserDefaults().setValue(otherID, forKey: "edittopicID")
            EditClassBool = false
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(EditClassViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
        }

        
        
        
        
        if addCurrciculumBool == true
        {
            
            CurriculumDataShowTopicBool = false
            addCurrciculumBool = false
            
            addCurriculumTopicStr = othertextView.text!
            addCurriculumTopicCheckBool = true
            
            NSUserDefaults.standardUserDefaults().setValue(otherID, forKey: "addCurriculumtopicID")
            
            for controller in self.navigationController!.viewControllers as Array
            {
                if controller.isKindOfClass(AddCurriculumViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
            }
            }
            
        }

        

  
    }
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        createClassBool = false
        EditClassBool = false
        addCurrciculumBool = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    //MARK:- Touch Event Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        othertextView.resignFirstResponder()
        
    }
    
}
