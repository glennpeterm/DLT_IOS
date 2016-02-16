//
//  AddCurriculumCountryViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/25/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var addCurriculumCountryBool = Bool()
class AddCurriculumCountryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var countryTableView: UITableView!
    
    
    var checked = [Bool]()
    var lastIndex = -1
    
    var countryArray = NSMutableArray()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        countryApi()
        
        countryTableView.tableFooterView = UIView(frame: CGRectZero)
        
        


        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
       
        
        
    }
    
    
    //MARK:- TableView Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return countryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let countryCell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)
        
        countryCell.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        countryCell.textLabel?.text = countryArray[indexPath.row] as? String
        
        if checked[indexPath.row] == false
        {
            
            countryCell.accessoryType = .None
        }
        else if checked[indexPath.row] == true
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CountrysaveCheckMark")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "CountryindexSave")
            
            saveBtn.tag = indexPath.row
            countryCell.accessoryType = .Checkmark
        }
        
        
        return countryCell
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
        
        CurriculumDataShowCountryBool = false
        addCurriculumCountryBool = true
        addCurriculumCountryStr = countryArray[sender.tag] as! NSString
        
        countryIndex = String(sender.tag)
        //(sender.tag)
        
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
    
    //MARK:- Country Api
    
    
    func countryApi()
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
            
            let url = NSURL(string:"http://www.digitallearningtree.com/digitalapi/country.php")
            
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            urlRequest.HTTPMethod = "POST"
           
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                //(data)
                
                //(response)
                
                if (error != nil)
                {
                    
                    //("\(error?.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(),
                        
                        
                        {
                            let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                            
                            alert.show()
                            spinningIndicator.hide(true)
                    })
                }
                    
                else
                {
                    
                    //let error:NSError?
                    
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
                                
                                self.countryArray = ["Select Country"]
                                
                                let array = (jsonResults?.valueForKey("data")) as! NSArray
                                
                                self.countryArray.addObjectsFromArray(array as [AnyObject])
                                
                                self.countryTableView.reloadData()
                                
                                for var i = 0; i < self.countryArray.count ; i++
                                {
                                
                                self.checked.append(false)
                                
                                }
                                
                                if NSUserDefaults.standardUserDefaults().boolForKey("CountrysaveCheckMark")
                                {
                                    
                                    self.checked[NSUserDefaults.standardUserDefaults().integerForKey("CountryindexSave")] = true
                                    
                                    self.lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("CountryindexSave")
                                    
                                }
                                
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                let alert = UIAlertView(title: "Alert", message: " Data Missing", delegate: self, cancelButtonTitle: "OK")
                                
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
