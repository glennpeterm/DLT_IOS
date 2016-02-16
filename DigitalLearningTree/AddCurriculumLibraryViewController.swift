//
//  AddCurriculumLibraryViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/25/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var addCurriculumLibraryBool = Bool()
class AddCurriculumLibraryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var libraryTableView: UITableView!
    
    var checked = [Bool]()
    var lastIndex = -1
    
    var libraryArray = NSArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        checked = [false,false,false]
        libraryArray = ["Personal","School","Community"]
        
        libraryTableView.tableFooterView = UIView(frame: CGRectZero)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("librarysaveCheckMark")
        {
            
            checked[NSUserDefaults.standardUserDefaults().integerForKey("libraryindexSave")] = true
            
            lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("libraryindexSave")
            
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    

   //MARK:- TableView Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return libraryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let libraryCell = tableView.dequeueReusableCellWithIdentifier("libraryCell", forIndexPath: indexPath)
        
        libraryCell.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        libraryCell.textLabel?.text = libraryArray[indexPath.row] as? String
        
        if checked[indexPath.row] == false
        {
            
            libraryCell.accessoryType = .None
        }
        else if checked[indexPath.row] == true
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "librarysaveCheckMark")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "libraryindexSave")
            
            saveBtn.tag = indexPath.row
            libraryCell.accessoryType = .Checkmark
        }
        

        return libraryCell
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
        CurriculumDataShowLibraryBool = false
        addCurriculumLibraryBool = true
        addCurriculumLibraryStr = libraryArray[sender.tag] as! String
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
