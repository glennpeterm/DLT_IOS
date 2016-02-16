//
//  TopicViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/17/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var CreatetopicCheckBool = Bool()
var editClasstopicCheckBool = Bool()
var addCurriculumTopicCheckBool = Bool()
class TopicViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    
 
    var checked = [Bool]()
    var checkTopicOption = String()
    var checkTopicOptionBool = Bool()
    @IBOutlet var zoomScrollView: UIScrollView!
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var topicTableView: UITableView!
    var topicArray = NSArray()
    var lastIndex = -1
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        topicApi()
        
        topicTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    //MARK:- Table View Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return topicArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let topicCell = tableView.dequeueReusableCellWithIdentifier("topicCell", forIndexPath: indexPath) as! TopicTableViewCell
        
        topicCell.topicLbl.text = topicArray[indexPath.row].valueForKey("name") as? String
        
        
        if checkTopicOptionBool == true
        {
            
            if checkTopicOption == topicArray[indexPath.row].valueForKey("name") as! String
            {
                topicCell.accessoryType = .Checkmark
               
            }
            
            if topicCell.topicLbl.text == "Art" || topicCell.topicLbl.text == "Other"
            {
                topicCell.arrowImage!.image = UIImage(named: "arrow.png")
                
            }
            
        }

        else
            
        {
        
        if topicCell.topicLbl.text == "Art" || topicCell.topicLbl.text == "Other"
        {
            topicCell.arrowImage!.image = UIImage(named: "arrow.png")
            
        }
        
        else
        
        {
            
        
            
            if checked[indexPath.row] == false
            {
                
                topicCell.accessoryType = .None
            }
                
            else if checked[indexPath.row] == true
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saveCheckMarkTopic")
                
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "indexSaveTopic")
                
                
                //(indexPath.row)
                saveBtn.tag = indexPath.row
                
                topicCell.accessoryType = .Checkmark
            }

            
        }
        
        }
       
        
        return topicCell
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
        checkTopicOptionBool = false
        if indexPath.row == 0
        {
            let arts = storyboard?.instantiateViewControllerWithIdentifier("Arts") as! ArtsViewController
            
            self.navigationController?.pushViewController(arts, animated: true)
        }
        
        else if indexPath.row == 2
        {
            let other = storyboard?.instantiateViewControllerWithIdentifier("other") as! OtherViewController
            
            other.otherID = topicArray[indexPath.row].valueForKey("id") as! String
            
            self.navigationController?.pushViewController(other, animated: true)
        }
        
        else
            
        {
        
        if lastIndex != -1
        {
            checked[lastIndex] = false
        }
        
        checked[indexPath.row] = true
        
        
        lastIndex = indexPath.row
        
        
        tableView.reloadData()
            
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
    
    //MARK:- Topic Api
    
    
    func topicApi()
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
            
            urlRequest.HTTPMethod = "GET"
            
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
                                
                                self.topicArray = jsonResults?.valueForKey("data") as! NSArray
                                
                                //(self.topicArray.count)
                                
                                for var i = 0; i < self.topicArray.count; i++
                                {
                                    self.checked.append(false)
                                }
                                
                                        if NSUserDefaults.standardUserDefaults().boolForKey("saveCheckMarkTopic")
                                        {
                                
                                           self.checked[NSUserDefaults.standardUserDefaults().integerForKey("indexSaveTopic")] = true
                                
                                            self.lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("indexSaveTopic")
                                            
                                        }

                                //(self.checked)
                                self.topicTableView.reloadData()
                                
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
            
            CreatetopicCheckBool = true
            createClassBool = false
            CreateClasstopicOptionString = topicArray[sender.tag].valueForKey("name") as! String
            let topicID = topicArray[sender.tag].valueForKey("id") as! String
            
            NSUserDefaults.standardUserDefaults().setValue(topicID, forKey: "topicID")
            
        }
            
        if EditClassBool == true
            
        {
            editClassTopicString = topicArray[sender.tag].valueForKey("name") as! String
            editClasstopicCheckBool = true
            EditdataShowGetBackTopicBool = false
            EditClassBool = false
            let topicID = topicArray[sender.tag].valueForKey("id") as! String
            //(topicID)
            NSUserDefaults.standardUserDefaults().setValue(topicID, forKey: "edittopicID")
        }
        
        
        if addCurrciculumBool == true
        {
            CurriculumDataShowTopicBool = false
            addCurriculumTopicStr = topicArray[sender.tag].valueForKey("name") as! String
            addCurriculumTopicCheckBool = true
            let topicID = topicArray[sender.tag].valueForKey("id") as! String
            //(topicID)
            NSUserDefaults.standardUserDefaults().setValue(topicID, forKey: "addCurriculumtopicID")
            
            addCurrciculumBool = false
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
