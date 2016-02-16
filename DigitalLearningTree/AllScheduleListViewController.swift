//
//  AllScheduleListViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/26/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit


var scheduleListApiBool = Bool()
class AllScheduleListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    var timeID = NSString()
    var scheduleArray = NSMutableArray()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var allScheduleTableView: UITableView!
    var Index = Int()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        allScheduleData()
        allScheduleTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if scheduleListApiBool == true
        {
            scheduleListApiBool = false
            allScheduleData()
        }
    }
    
    
    //BACK Button
    
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK:- TableView Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return scheduleArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let scheduleDataCell = tableView.dequeueReusableCellWithIdentifier("scheduleDataCell", forIndexPath: indexPath) as! AllScheduleDataTableViewCell
        
        
        scheduleDataCell.locationLbl.text = "No Location"
        
        if let location = scheduleArray[indexPath.row].valueForKey("Cls_Location")
        {
            if location as! String == ""
            {
                scheduleDataCell.locationLbl.text = "No Location"
                
            }
                
            else
            {
                scheduleDataCell.locationLbl.text = location as? String
            }
        }
        
        scheduleDataCell.dayLabel.text = "No Day"
        
        if let day = scheduleArray[indexPath.row].valueForKey("day")
        {
            if day as! String == "1"
            {
                scheduleDataCell.dayLabel.text = "Monday"
            }
            
            if day as! String == "2"
            {
                scheduleDataCell.dayLabel.text = "Tuesday"
            }
            
            if day as! String == "3"
            {
                scheduleDataCell.dayLabel.text = "Wednesday"
            }
            
            if day as! String == "4"
            {
                scheduleDataCell.dayLabel.text = "Thursday"
            }
            
            if day as! String == "5"
            {
                scheduleDataCell.dayLabel.text = "Friday"
            }
            
            if day as! String == "6"
            {
                scheduleDataCell.dayLabel.text = "Saturday"
            }
            
            if day as! String == "7"
            {
                scheduleDataCell.dayLabel.text = "Sunday"
            }
            
            if day as! String == "8"
            {
                scheduleDataCell.dayLabel.text = "Every Day"
            }
            
            if day as! String == "9"
            {
                scheduleDataCell.dayLabel.text = "Every Weekday"
            }
            
            
        }
        
        return scheduleDataCell
        
        
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
        let addSchedule = storyboard?.instantiateViewControllerWithIdentifier("addSchedule") as! AddClassScheduledViewController
        
        addSchedule.timeId = scheduleArray[indexPath.row].valueForKey("timeid") as! String
        addSchedule.didSelectBool = true
        self.navigationController?.pushViewController(addSchedule, animated: true)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            timeID = scheduleArray[indexPath.row].valueForKey("timeid") as! String
            Index = indexPath.row
            deleteScheduleApi()
        }
        
    }
    
    
    //MARK:- Add Schedule
    
    
    @IBAction func addScheduleBtn(sender: AnyObject)
    {
        let addSchedule = storyboard?.instantiateViewControllerWithIdentifier("addSchedule") as! AddClassScheduledViewController
        
        self.navigationController?.pushViewController(addSchedule, animated: true)
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
    
    
    //MARK:- All Schedule Data
    
    
    func allScheduleData()
    {
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let post = NSString(format:"userid=%@&clsid=%@",cls_createdby_userID,cla_classid_eid)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/before_edit_time.php")
            
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = dataModel
            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                //(data)
                
                //(response)
                
                if (error != nil)
                {
                    let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                    
                    alert.show()
                    //("\(error?.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(), {
                        spinningIndicator.hide(true)
                    })
                }
                    
                else
                {
                    
                    
                    
                    var jsonResults : NSDictionary?
                    
                    
                    do
                    {
                        jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        
                        // success ...
                        //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                
                                
                                self.scheduleArray =  jsonResults?.valueForKey("data") as! NSMutableArray
                                
                                
                                
                                
                                if let day = self.scheduleArray.lastObject!.valueForKey("day")
                                {
                                    
                                    CNDScheduleOptionBool = true
                                    
                                    if day as! String == "1"
                                    {
                                        CNDScheduleOptionStr = "Monday"
                                    }
                                    
                                    if day as! String == "2"
                                    {
                                        CNDScheduleOptionStr = "Tuesday"
                                    }
                                    
                                    if day as! String == "3"
                                    {
                                        CNDScheduleOptionStr = "Wednesday"
                                    }
                                    
                                    if day as! String == "4"
                                    {
                                        CNDScheduleOptionStr = "Thursday"
                                    }
                                    
                                    if day as! String == "5"
                                    {
                                        CNDScheduleOptionStr = "Friday"
                                    }
                                    
                                    if day as! String == "6"
                                    {
                                        CNDScheduleOptionStr = "Saturday"
                                    }
                                    
                                    if day as! String == "7"
                                    {
                                        CNDScheduleOptionStr = "Sunday"
                                    }
                                    
                                    if day as! String == "8"
                                    {
                                        CNDScheduleOptionStr = "Every Day"
                                    }
                                    
                                    if day as! String == "9"
                                    {
                                        CNDScheduleOptionStr = "Every Weekday"
                                    }
                                    
                                    
                                }

                                
                                
                                
                                
                                self.allScheduleTableView.reloadData()
                                
                                spinningIndicator.hide(true)
                                
                            
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message: "No data", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                spinningIndicator.hide(true)
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                    catch
                    {
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                spinningIndicator.hide(true)
                        })
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
        
    }
    
    
    //MARK:- Delete Schedule Api
    
    
    func deleteScheduleApi()
        
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            
            
            let post = NSString(format:"del_id=%@",timeID)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/cls_time.php")
            
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = dataModel
            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                //(data)
                
                //(response)
                
                if (error != nil)
                {
                    let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                    
                    alert.show()
                    //("\(error?.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(), {
                        spinningIndicator.hide(true)
                    })
                }
                    
                else
                {
                    
                    
                    
                    var jsonResults : NSDictionary?
                    
                    
                    do
                    {
                        jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        
                        // success ...
                        //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                
                                
                                self.scheduleArray.removeObjectAtIndex(self.Index)
                                
                                self.allScheduleTableView.reloadData()
                                
                                spinningIndicator.hide(true)
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message: "Data Missing", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                spinningIndicator.hide(true)
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                    catch
                    {
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                spinningIndicator.hide(true)
                        })
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
        
        
        
    }
    
    
}
