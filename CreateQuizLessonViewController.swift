//
//  CreateQuizLessonViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 12/2/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class CreateQuizLessonViewController: UIViewController
{
    
    @IBOutlet var saveBtn: UIButton!
    var checked = [Bool]()
    
    var lastIndex = -1
    @IBOutlet var zoomView: UIView!
    
    @IBOutlet var lessonsTableView: UITableView!
    var lessonListArray = NSMutableArray()
    
    @IBOutlet var zoomScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lessonListApi()
        
        lessonsTableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        
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
    
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lessonListArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let lessons = tableView.dequeueReusableCellWithIdentifier("QuizlessonCell", forIndexPath: indexPath)
        lessons.textLabel?.font = UIFont(name: "Arial", size: 18)
        lessons.textLabel?.text = ""
        
        if let les = lessonListArray[indexPath.row].valueForKey("lesson_name")
        {
            lessons.textLabel?.text = les as? String
            
        }
        
        
        if checked[indexPath.row] == false
        {
            
            lessons.accessoryType = .None
        }
            
        else if checked[indexPath.row] == true
        {
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saveCheckMarkQuizLesson")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "indexSaveQuizLesson")
            
            
            
            //(indexPath.row)
            saveBtn.tag = indexPath.row
            
            lessons.accessoryType = .Checkmark
        }
        
        
        
        return lessons
        
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
    
    //MARK:- Lesson List Api
    func lessonListApi()
    {
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
            
        else
        {
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"userid=%@&classid=%@",cls_createdby_userID,cla_classid_eid)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/teach_lesson.php")
            
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
                    self.saveBtn.hidden = true
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
                                self.lessonListArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                //(self.lessonListArray.count)
                                for var i = 0; i < self.lessonListArray.count; i++
                                {
                                    self.checked.append(false)
                                }
                                if NSUserDefaults.standardUserDefaults().boolForKey("saveCheckMarkQuizLesson")
                                {
                                self.checked[NSUserDefaults.standardUserDefaults().integerForKey("indexSaveQuizLesson")] = true
                                    self.lastIndex = NSUserDefaults.standardUserDefaults().integerForKey("indexSaveQuizLesson")
                                }
                                
                                //(self.checked)
                                self.lessonsTableView.reloadData()
                                spinningIndicator.hide(true)
                            }
                            else
                            {
                                let alert = UIAlertView(title: "Alert", message: "No data", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                self.saveBtn.hidden = true
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
                                
                                self.saveBtn.hidden = true
                                spinningIndicator.hide(true)
                        })
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
        
        
        
        
    }
    //MARK:- Save Button
    
    
    @IBAction func savebtn(sender: AnyObject)
    {
        quizLessonNameBool = true
        
        quizLessonNameStr = lessonListArray[sender.tag].valueForKey("lesson_name") as! String
        quizLessonID = lessonListArray[sender.tag].valueForKey("les_id") as! String
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
