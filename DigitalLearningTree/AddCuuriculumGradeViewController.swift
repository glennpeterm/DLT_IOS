//
//  AddCuuriculumGradeViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/25/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var gradeFromBool = Bool()
var gradeToBool = Bool()
class AddCuuriculumGradeViewController: UIViewController
{

    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var gradeTableView: UITableView!
    
    var checked = [Bool]()
    var lastIndex = -1
    
    var gradeArray = NSArray()
    
    var gradeBool  = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        checked = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
        gradeArray = ["Other","K","1","2","3","4","5","6","7","8","9","10","11","12","HigherEd"]
        
        gradeTableView.tableFooterView = UIView(frame: CGRectZero)

        if NSUserDefaults.standardUserDefaults().boolForKey("GradesaveCheckMark")
        {
            
            checked[NSUserDefaults.standardUserDefaults().integerForKey("GradeindexSave")] = true
            
            lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("GradeindexSave")
            
        }


        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK:- TableView Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gradeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let gradeCell = tableView.dequeueReusableCellWithIdentifier("gradeCell", forIndexPath: indexPath)
        
        gradeCell.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        gradeCell.textLabel?.text = gradeArray[indexPath.row] as? String
        
        if checked[indexPath.row] == false
        {
            
            gradeCell.accessoryType = .None
        }
        else if checked[indexPath.row] == true
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "GradesaveCheckMark")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "GradeindexSave")
            
            saveBtn.tag = indexPath.row
            gradeCell.accessoryType = .Checkmark
        }
        
        
        return gradeCell
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
        
        if lastIndex != -1
        {
            checked[lastIndex] = false
        }
        
        checked[indexPath.row] = true
        
        
        lastIndex = indexPath.row
        
        
        tableView.reloadData()
        
    }
    
    //MARK:- Save button
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        if gradeBool == true
        {
            gradeFromBool = true
            CurriculumDataShowGradeFromBool = false
            lo_ageIndex = String(sender.tag)
            addCurriculumGradeFromStr = gradeArray[sender.tag] as! NSString
        }
        
        else
        
        {
            CurriculumDataShowGradeToBool = false
            gradeToBool = true
            hig_ageIndex = String(sender.tag)
            addCurriculumGradeToStr = gradeArray[sender.tag] as! NSString
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
