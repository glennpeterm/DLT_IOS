//
//  StudentClassViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class StudentClassViewController: UIViewController
{
    
    
    var studentClassListingArray = NSMutableArray()
    
    @IBOutlet var classListingTableView: UITableView!
    
    
    @IBOutlet var zoomScrollView: UIScrollView!
    
    @IBOutlet var zoomView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        
        getStudentCLassApi()
        classListingTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationItem.hidesBackButton = true
        
    }
    
    
    
    
    
    //MARK:- TableView Deleagte
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentClassListingArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let classListingCell = tableView.dequeueReusableCellWithIdentifier("studentClassListingCell", forIndexPath: indexPath) as! StudentClassTableViewCell
        
        classListingCell.classNameLbl.text = ""
        
        if let className = studentClassListingArray[indexPath.row].valueForKey("classname")
        {
            classListingCell.classNameLbl.text = "Class:\(className)"
        }
        
        classListingCell.subjectHistoryLbl.text = ""
        
        if let subject = studentClassListingArray[indexPath.row].valueForKey("topicname")
        {
            classListingCell.subjectHistoryLbl.text = "Subject:\(subject)"
        }
        
        classListingCell.studentCountLbl.text = ""
        
        if let Stcount = studentClassListingArray[indexPath.row].valueForKey("student")
        {
            classListingCell.studentCountLbl.text = "Student(s):\(Stcount)"
        }

        
        
        
        return classListingCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let studentLessonView = storyboard?.instantiateViewControllerWithIdentifier("studentLessonView") as! StudentLessonViewController
        
        
        let studentClassID = studentClassListingArray[indexPath.row].valueForKey("classid")
        
        NSUserDefaults.standardUserDefaults().setValue(studentClassID, forKey: "StudentClassID")

        
        
        self.navigationController?.pushViewController(studentLessonView, animated: true)
        
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let shareAction = UITableViewRowAction(style: .Default, title: "Info") { value in
            print("button did tapped!")
            
            let studentClassDesc = self.storyboard?.instantiateViewControllerWithIdentifier("studentClassDesc") as! StudentClassDescViewController
            studentClassDesc.Cla_Id = self.studentClassListingArray[indexPath.row].valueForKey("Cla_Id") as! String
            if let desc = self.studentClassListingArray[indexPath.row].valueForKey("classdesc")
            {
                studentClassDesc.classDesc = desc as! String
            }
            self.navigationController?.pushViewController(studentClassDesc, animated: true)
            
        }
        
        shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
        
        return [shareAction]
        
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
    
  
    //MARK:- Get Student Class Api
    
    func getStudentCLassApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
            
        else
            
        {
           let usernameClassList = NSUserDefaults.standardUserDefaults().valueForKey("Username") as! String
           let passwordClassList =  NSUserDefaults.standardUserDefaults().valueForKey("Password") as! String

            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
           let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
            
            let post = NSString(format:"username=%@&password=%@&logid=%@",usernameClassList,passwordClassList, schID)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_students.php")
            
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
                        print(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                
                                let studentUserID = jsonResults?.valueForKey("Sch_Mem_id")
                                
                                NSUserDefaults.standardUserDefaults().setValue(studentUserID, forKey: "StudentUserID")
                                
                                let classDataDict = jsonResults?.valueForKey("class_data") as? NSDictionary
                                
                                let ClassDataSuccess = classDataDict?.valueForKey("success") as! Bool
                                
                                
                                if ClassDataSuccess
                                {
                                    self.studentClassListingArray = classDataDict?.valueForKey("data") as! NSMutableArray
                                    self.classListingTableView.reloadData()
                                    
                                    
                                }
                                
                                else
                                {
                                    let alert = UIAlertView(title: "Alert", message: "No data", delegate: self, cancelButtonTitle: "OK")
                                    alert.show()
                                }
                                
                                
                                
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

//MARK:- Logout Button
    
    
    @IBAction func logoutBtn(sender: AnyObject)
    {
        StudentLogoutApi()
    }
    
    //MARK:- Student Logout Api
    
    func StudentLogoutApi()
    {
        
        
        let date = NSDate()
        
        let requestedComponents: NSCalendarUnit =
        [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day
        ]
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(requestedComponents, fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        
        let createdDate = "\(year)-\(month)-\(day)"
        
        
        
        
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
            
        }
            
        else
            
        {
            let userID = NSUserDefaults.standardUserDefaults().valueForKey("StudentUserID") as! String
            
            
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            
            let post = NSString(format:"userid=%@&curdate=%@",userID,createdDate)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/student_logout.php")
            
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
                                
                                
                                let storyboardLogin = UIStoryboard(name: "Main", bundle: nil)
                                let login = storyboardLogin.instantiateViewControllerWithIdentifier("teacherLogin") as! LoginViewController
                                
                                loginbacktoschoolBool = true
                                login.StudentAndTeacherLoginBool = false
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "StudentLogin")
                                self.navigationController?.pushViewController(login, animated: false)
                                
                                
                                
                                
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
    

   

    
}
