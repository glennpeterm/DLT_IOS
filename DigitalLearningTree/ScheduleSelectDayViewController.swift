//
//  ScheduleSelectDayViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/24/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var scheduleDayBool = Bool()

class ScheduleSelectDayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var checked = [Bool]()
    var lastIndex = -1
    

    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    var dayArray = NSArray()
    
    @IBOutlet var dayTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dayTableView.tableFooterView = UIView(frame: CGRectZero)
        
        dayArray = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday","Every Day","Every Weekday"]
        
        checked = [false,false,false,false,false,false,false,false,false]
        
        if NSUserDefaults.standardUserDefaults().boolForKey("scheduleCheckMark")
        {
            
            checked[NSUserDefaults.standardUserDefaults().integerForKey("ScheduleIndexSave")] = true
            
            lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("ScheduleIndexSave")
            
        }
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

   //MARK:- TableView Delegate

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dayArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellDay = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath)
        
        cellDay.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        cellDay.textLabel?.text = dayArray[indexPath.row] as? String
        
        if checked[indexPath.row] == false
        {
            
            cellDay.accessoryType = .None
        }
        else if checked[indexPath.row] == true
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "scheduleCheckMark")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "ScheduleIndexSave")
            
            saveBtn.tag = indexPath.row
            cellDay.accessoryType = .Checkmark
        }

        
        return cellDay
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
    

    //MARK:- Save Button
    
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        ScheduleDataShowSelectDayBool = false
        scheduleDayBool = true
        
        scheduleDayStr = dayArray[sender.tag] as! String
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}
