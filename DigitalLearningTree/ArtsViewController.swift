//
//  ArtsViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/17/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class ArtsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var saveBtn: UIButton!
 
    var checked = [Bool]()
    var lastIndex = -1

    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var artsTableView: UITableView!
    var artsArray = NSArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        artApi()
        
        artsTableView.tableFooterView = UIView(frame: CGRectZero)
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return artsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let artsCell = tableView.dequeueReusableCellWithIdentifier("artsCell", forIndexPath: indexPath)
         artsCell.textLabel?.font = UIFont(name: "Arial", size: 18)
        artsCell.textLabel?.text = artsArray[indexPath.row].valueForKey("name") as? String
        
        if checked[indexPath.row] == false
        {
            
            artsCell.accessoryType = .None
        }
            
        else if checked[indexPath.row] == true
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saveCheckMarkArts")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "indexSaveArts")
            
            
            
            //(indexPath.row)
            saveBtn.tag = indexPath.row
            
            artsCell.accessoryType = .Checkmark
        }

        
        return artsCell
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
        addCurrciculumBool = false

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Art Api
    
    
    func artApi()
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
            
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/before_class.php")
            
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            urlRequest.HTTPMethod = "POST"
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                
                
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
                                let childarray = jsonResults?.valueForKey("data") as! NSArray
                                
                                self.artsArray = childarray[0].valueForKey("child") as! NSArray
                                
                                //(self.artsArray.count)
                                
                                for var i = 0; i < self.artsArray.count; i++
                                {
                                    self.checked.append(false)
                                }
                                
                                if NSUserDefaults.standardUserDefaults().boolForKey("saveCheckMarkArts")
                                {
                                    
                                    self.checked[NSUserDefaults.standardUserDefaults().integerForKey("indexSaveArts")] = true
                                    
                                    self.lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("indexSaveArts")
                                    
                                }
                                
                                //(self.checked)
                                self.artsTableView.reloadData()
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                
                                spinningIndicator.hide(true)
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                    catch
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            spinningIndicator.hide(true)
                        })
                        
                        let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
                        
                        alert.show()
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
    }

    //MARK:- Done Button
    
  
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        if createClassBool == true
        {
            createClassBool = false
            
           

            
            CreatetopicCheckBool = true
            
            CreateClasstopicOptionString = artsArray[sender.tag].valueForKey("name") as! String
            let topicID = artsArray[sender.tag].valueForKey("id") as! String
            
            NSUserDefaults.standardUserDefaults().setValue(topicID, forKey: "topicID")
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(CreateClassViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }

        }
            
        if EditClassBool == true
            
        {
            editClassTopicString = artsArray[sender.tag].valueForKey("name") as! String
            editClasstopicCheckBool = true
            let topicID = artsArray[sender.tag].valueForKey("id") as! String
            EditClassBool = false
            NSUserDefaults.standardUserDefaults().setValue(topicID, forKey: "edittopicID")
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(EditClassViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
        }
        
        
        if addCurrciculumBool == true
        {
             addCurrciculumBool = false
            CurriculumDataShowTopicBool = false
            
            addCurriculumTopicStr = artsArray[sender.tag].valueForKey("name") as! String
            addCurriculumTopicCheckBool = true
            let topicID = artsArray[sender.tag].valueForKey("id") as! String
            //(topicID)
            NSUserDefaults.standardUserDefaults().setValue(topicID, forKey: "addCurriculumtopicID")
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(AddCurriculumViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
            
        }

        
        
        

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
