//
//  EditClassFeaturesViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/19/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var editClassFeaturesBool = Bool()

var calendarBool = String()
var chatBool = String()
var gradeBool = String()
var studentTabBool = String()
class EditClassFeaturesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var savebtn: UIButton!
    var fetaureStrArray  = [String]()
    
    
    var boolDict = Dictionary<String,String>()
    
   
    var featureArray = NSArray()
    
    var checked = [Bool]()
    
    @IBOutlet var featuresTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        featureArray = ["Calendar","Chat","Grades","Student Tab"]
        
        checked = [false,false,false,false]
        
        featuresTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("calendar")
        {
            checked[NSUserDefaults.standardUserDefaults().integerForKey("calendarRow")] = true
            calendarBool = "true"
            
            fetaureStrArray.append(featureArray[NSUserDefaults.standardUserDefaults().integerForKey("calendarRow")] as! String)
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("chat")
        {
            checked[NSUserDefaults.standardUserDefaults().integerForKey("chatRow")] = true
            chatBool = "true"
            fetaureStrArray.append(featureArray[NSUserDefaults.standardUserDefaults().integerForKey("chatRow")] as! String)
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("grade")
        {
            checked[NSUserDefaults.standardUserDefaults().integerForKey("gradeRow")] = true
            gradeBool = "true"
            fetaureStrArray.append(featureArray[NSUserDefaults.standardUserDefaults().integerForKey("gradeRow")] as! String)
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("studentTab")
        {
            checked[NSUserDefaults.standardUserDefaults().integerForKey("studentTabRow")] = true
            studentTabBool = "true"
            fetaureStrArray.append(featureArray[NSUserDefaults.standardUserDefaults().integerForKey("studentTabRow")] as! String)
        }


        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return featureArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let featureCell = tableView.dequeueReusableCellWithIdentifier("featureCell", forIndexPath: indexPath)
        featureCell.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        featureCell.textLabel?.text = featureArray[indexPath.row] as? String
        
         //(checked[indexPath.row])
        if checked[indexPath.row] == false
           
        {
            featureCell.accessoryType = .None
        }
            
        else
            
        {
            featureCell.accessoryType = .Checkmark
            
        }
        
        
        
        
        return featureCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if cell.respondsToSelector("setSeparatorInset:")
        {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        
        
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")
        {
            
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector("setLayoutMargins:")
        {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
        
        if checked[indexPath.row] == false
        {
            checked[indexPath.row] = true
            
            if indexPath.row == 0
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "calendar")
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "calendarRow")
                calendarBool = "true"
                
                fetaureStrArray.append("Calendar")
            }
            
            if indexPath.row == 1
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "chat")
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "chatRow")
                chatBool = "true"
                
                fetaureStrArray.append("Chat")
            }
            
            if indexPath.row == 2
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "grade")
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "gradeRow")
                gradeBool = "true"
                
                fetaureStrArray.append("Grades")
            }
            
            if indexPath.row == 3
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "studentTab")
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "studentTabRow")
                studentTabBool = "true"
                
                fetaureStrArray.append("Student Tab")
            }


            
        }
            
        else
        {
            checked[indexPath.row] = false
            
            if indexPath.row == 0
            {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "calendar")
                calendarBool = ""
                fetaureStrArray.removeAtIndex(indexPath.row)
            }
            
            if indexPath.row == 1
            {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "chat")
                chatBool = ""
                fetaureStrArray.removeAtIndex(indexPath.row)
            }
            
            if indexPath.row == 2
            {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "grade")
               gradeBool = ""
                fetaureStrArray.removeAtIndex(indexPath.row)
            }
            
            if indexPath.row == 3
            {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "studentTab")
                
                studentTabBool = ""
                fetaureStrArray.removeAtIndex(indexPath.row)
            }

            
            
        }
        
        tableView.reloadData()
        
    }
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK:- Done Button
    
    
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        EditdataShowGetBackFeaturesBool = false
        editClassFeaturesBool = true
//        boolDict = ["enable_calendar":calendarBool, "enable_students_tab":studentTabBool,"enable_chat":chatBool,"enable_grades":gradeBool]
//        boolDIctFeatures = boolDict
        //(boolDict)
        //(fetaureStrArray)
        feturesStrArrayEdit = fetaureStrArray
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
    

    
}
