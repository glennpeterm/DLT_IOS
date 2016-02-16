//
//  ClassTypeViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/17/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var createClassclassTypeCheckBool = Bool()
var editClassClassTypeCheckBool = Bool()


class ClassTypeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    
    @IBOutlet var saveBtn: UIButton!
   
    var checked = [Bool]()
    @IBOutlet var classTypeTableView: UITableView!
    var classTypeArray = NSArray()
    
    
    
    var lastIndex = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        checked = [false,false,false]
        classTypeArray = ["Instructor","Blended","Self-Paced"]
        
        classTypeTableView.tableFooterView = UIView(frame: CGRectZero)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("saveCheckMark")
        {
            
            checked[NSUserDefaults.standardUserDefaults().integerForKey("indexSave")] = true
            
            lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("indexSave")
            
        }
        
        
        
        }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        
    }
    
    //MARK:- Table View Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return classTypeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let classTypeCell = tableView.dequeueReusableCellWithIdentifier("classTypeCell", forIndexPath: indexPath)
        
        classTypeCell.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        classTypeCell.textLabel?.text = classTypeArray[indexPath.row] as? String
        
        
        if checked[indexPath.row] == false
        {
            
            classTypeCell.accessoryType = .None
        }
        else if checked[indexPath.row] == true
        {
             NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saveCheckMark")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "indexSave")
            
            saveBtn.tag = indexPath.row
            classTypeCell.accessoryType = .Checkmark
        }
        
       
        return classTypeCell
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
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        createClassBool = false
        EditClassBool = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Done Button
  
    @IBAction func doneBtn(sender: UIBarButtonItem)
    {
        
        
    }
   
   
    @IBAction func saveBtn(sender: AnyObject)
    {
        if createClassBool == true
        {
            createClassBool = false
            createClassclassTypeCheckBool = true
            CreateClassclassTypeOptionString = classTypeArray[sender.tag] as! String
            
        }
            
        if EditClassBool == true
            
        {
            EditdataShowGetBackClassTypeBool = false
            EditClassBool = false
            editClassClassTypeString = classTypeArray[sender.tag] as! String
            editClassClassTypeCheckBool = true
        }
        
        
        
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
