//
//  StudentViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/7/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController
{
    var archiveArray = NSMutableArray()
    var enrollArray = NSMutableArray()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var grayView: UIView!
    @IBOutlet var addStudentBtn: UIButton!
   
    @IBOutlet var menuView: UIView!
    @IBOutlet var archieveEnrollView: UIView!
    @IBOutlet var studentArchiveTableView: UITableView!
    @IBOutlet var enrolStudentTableView: UITableView!
    @IBOutlet var enrolStudentBtn: UIButton!
    @IBOutlet var archivedStudentBtn: UIButton!
    var studentDeleteIndexSave = Int()
    var studentType = NSString()
    var studentTypeBool = Bool()
    var studentId = NSString()
    
    
    var deleteApiBool = Bool()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        studentTypeBool = true
        self.navigationController?.navigationBarHidden = false
        
        enrolStudentBtn.layer.borderColor = UIColor.whiteColor().CGColor
        archivedStudentBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        enrolStudentTableView.tableFooterView = UIView(frame: CGRectZero)
        studentArchiveTableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
        studentTypeBool = true
        studentList()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.enrolStudentTableView.frame.origin.x = 0
            self.studentArchiveTableView.frame.origin.x = 0
            self.archieveEnrollView.frame.origin.x = 0
            
            
            self.enrolStudentTableView.userInteractionEnabled = true
            self.studentArchiveTableView.userInteractionEnabled = true
            self.archieveEnrollView.userInteractionEnabled = true
            
           
            self.addStudentBtn.userInteractionEnabled = true
            
            self.grayView.hidden = true
            
        })
        
    }
    
   
    
    
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == studentArchiveTableView
        {
            return archiveArray.count
        }
        else
        {
            return enrollArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableView == studentArchiveTableView
        {
            
        let studentArchivedCell = tableView.dequeueReusableCellWithIdentifier("studentArchivedCell", forIndexPath: indexPath) as! StudentTableViewCell
        
            studentArchivedCell.archivedStudentNameLbl.text = ""
            
            var firstName = NSString()
            var lastName = NSString()
            
            if let name = archiveArray[indexPath.row].valueForKey("Name")
            {
                firstName = name as! NSString
            }
            
            if let last = archiveArray[indexPath.row].valueForKey("LastName")
            {
                lastName = last as! NSString
            }
            
            studentArchivedCell.archivedStudentNameLbl.text = "\(firstName) \(lastName)"
            
            
            
        return studentArchivedCell
            
        }
        
        else
        {
            let studentEnrolCell = tableView.dequeueReusableCellWithIdentifier("studentEnrolCell", forIndexPath: indexPath) as! StudentTableViewCell
            
            
            studentEnrolCell.enrollStudentNameLbl.text = ""
            
            var firstName = NSString()
            var lastName = NSString()
            
            if let name = enrollArray[indexPath.row].valueForKey("Name")
            {
                firstName = name as! NSString
            }
            
            if let last = enrollArray[indexPath.row].valueForKey("LastName")
            {
                lastName = last as! NSString
            }
            
            studentEnrolCell.enrollStudentNameLbl.text = "\(firstName) \(lastName)"
            
            

            
            
            return studentEnrolCell

        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if tableView == enrolStudentTableView
        {
            
        let studentDetail = storyboard?.instantiateViewControllerWithIdentifier("studentDetail") as! StudentDetailViewController
        studentDetail.memID = enrollArray[indexPath.row].valueForKey("Mem_id") as! String
        self.navigationController?.pushViewController(studentDetail, animated: true)
            
        }
        else
            
           
        {
            let studentDetail = storyboard?.instantiateViewControllerWithIdentifier("studentDetail") as! StudentDetailViewController
            studentDetail.memID = archiveArray[indexPath.row].valueForKey("Mem_id") as! String
            self.navigationController?.pushViewController(studentDetail, animated: true)
            
        }
       
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
        
        if tableView == enrolStudentTableView
        {

        let shareAction = UITableViewRowAction(style: .Default, title: "Archieve") { value in
            //("button did tapped!")
            
            self.studentId = self.enrollArray[indexPath.row].valueForKey("Mem_id") as! String
            self.ArchievedApi()
            self.studentDeleteIndexSave = indexPath.row
        }
        
        let shareAction1 = UITableViewRowAction(style: .Default, title: "Delete") { value in
            //("button did tapped!")
            
            self.studentId = self.enrollArray[indexPath.row].valueForKey("Mem_id") as! String
            self.studentDeleteIndexSave = indexPath.row
            self.deleteStudentApi()
            self.deleteApiBool = true
        }
        
        shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
        
        
        shareAction1.backgroundColor = UIColor(red: 255/255, green: 74/255, blue: 74/255, alpha: 1.0)
        
        
        
        return [shareAction1,shareAction]
        }
            
        else
            
        {
            let shareAction = UITableViewRowAction(style: .Default, title: "Un-Archieve") { value in
                //("button did tapped!")
                
                self.studentId = self.archiveArray[indexPath.row].valueForKey("Mem_id") as! String
                self.UnArchievedApi()
                self.studentDeleteIndexSave = indexPath.row
            

                
            }
            
            let shareAction1 = UITableViewRowAction(style: .Default, title: "Delete") { value in
                //("button did tapped!")
                
                self.studentId = self.archiveArray[indexPath.row].valueForKey("Mem_id") as! String
                self.studentDeleteIndexSave = indexPath.row
                self.deleteStudentApi()
                self.deleteApiBool = false
                
            }
            
            shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
            
            
            shareAction1.backgroundColor = UIColor(red: 255/255, green: 74/255, blue: 74/255, alpha: 1.0)
            
            
            
            return [shareAction1,shareAction]

       
        
        }
        
        
    }

    
    
    //MARK:- StudentArchived Button
    
    @IBAction func archivedStudentBtn(sender: AnyObject)
    {
        studentTypeBool = false
        studentList()
        studentArchiveTableView.hidden = false
        enrolStudentTableView.hidden = true
        
        enrolStudentBtn.backgroundColor = UIColor(red: 137/255, green: 193/255, blue: 57/255, alpha: 1.0)
        
        enrolStudentBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
        
        archivedStudentBtn.backgroundColor = UIColor.whiteColor()
        archivedStudentBtn.setTitleColor(UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0), forState: UIControlState.Normal)
        
    }
    
    //MARK:- StudentEnroll Button
    
    @IBAction func enrollStudentBtn(sender: AnyObject)
    {
        studentTypeBool = true
        
        studentList()
        studentArchiveTableView.hidden = true
        enrolStudentTableView.hidden = false
        
        archivedStudentBtn.backgroundColor = UIColor(red: 137/255, green: 193/255, blue: 57/255, alpha: 1.0)
            
        archivedStudentBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
        enrolStudentBtn.backgroundColor = UIColor.whiteColor()
        enrolStudentBtn.setTitleColor(UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0), forState: UIControlState.Normal)

    }
    
    //MARK:- Menu Bar Button
    
    
    @IBAction func menuBarBtn(sender: AnyObject)
    {
        
        
        
        if menuView.frame.origin.x == 0
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = -700
                self.enrolStudentTableView.frame.origin.x = 0
                self.studentArchiveTableView.frame.origin.x = 0
                self.archieveEnrollView.frame.origin.x = 0
                
                
                self.enrolStudentTableView.userInteractionEnabled = true
                self.studentArchiveTableView.userInteractionEnabled = true
                self.archieveEnrollView.userInteractionEnabled = true

                
                self.addStudentBtn.userInteractionEnabled = true
                 self.grayView.hidden = true

            })
            
            
        }
            
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.enrolStudentTableView.frame.origin.x = self.menuView.frame.size.width
                self.studentArchiveTableView.frame.origin.x = self.menuView.frame.size.width
                self.archieveEnrollView.frame.origin.x = self.menuView.frame.size.width
                
                self.enrolStudentTableView.userInteractionEnabled = false
                self.studentArchiveTableView.userInteractionEnabled = false
                self.archieveEnrollView.userInteractionEnabled = false

                
                self.addStudentBtn.userInteractionEnabled = false
                
                 self.grayView.hidden = false
                

                
            })
            
        }
        
        
    }
    //MARK:- Menu Buttons
    
    @IBAction func menuClassBtn(sender: AnyObject)
    {
        let classListView = storyboard?.instantiateViewControllerWithIdentifier("classListView") as! ClassListingViewController
        
        self.navigationController?.pushViewController(classListView, animated: true)
        
        
        
        
    }
    
    @IBAction func menuLessonBtn(sender: AnyObject)
    {
        let lessonView = storyboard?.instantiateViewControllerWithIdentifier("lessonView") as! LessonsViewController
        
        self.navigationController?.pushViewController(lessonView, animated: true)
    }
    
    
    @IBAction func menuClassResorcesBtn(sender: AnyObject)
    {
        let classResourceView = storyboard?.instantiateViewControllerWithIdentifier("classResourceView") as! ClassResourcesViewController
        
        self.navigationController?.pushViewController(classResourceView, animated: true)
        
    }
    
    @IBAction func menuQuizBtn(sender: AnyObject)
    {
        let quizView = storyboard?.instantiateViewControllerWithIdentifier("quizView") as! QuizViewController
        
        self.navigationController?.pushViewController(quizView, animated: true)

        
        
        
    }
    
    @IBAction func menuStudentBtn(sender: AnyObject)
    {
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.enrolStudentTableView.frame.origin.x = 0
            self.studentArchiveTableView.frame.origin.x = 0
            self.archieveEnrollView.frame.origin.x = 0
            
            
            self.enrolStudentTableView.userInteractionEnabled = true
            self.studentArchiveTableView.userInteractionEnabled = true
            self.archieveEnrollView.userInteractionEnabled = true
            
           
            self.addStudentBtn.userInteractionEnabled = true
            
             self.grayView.hidden = true
            

            
        })

    }
    
    
    @IBAction func menuEnrollBtn(sender: AnyObject)
    {
        let enrollView = storyboard?.instantiateViewControllerWithIdentifier("enrollView") as! GradeViewController
        
        self.navigationController?.pushViewController(enrollView, animated: true)
        
    }

    @IBAction func logOutBtn(sender: AnyObject)
    {
        let login = storyboard?.instantiateViewControllerWithIdentifier("teacherLogin") as! LoginViewController
        
        loginbacktoschoolBool = true
         login.StudentAndTeacherLoginBool = true
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "Login")
        self.navigationController?.pushViewController(login, animated: false)
        
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
    
    //MARK:- Student List
    
    func studentList()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else
            
        {
            if studentTypeBool == false
            {
            studentType = "0"
            }
            if studentTypeBool == true
            {
                studentType = "1"
            }
            
            
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"userid=%@&classid=%@&student_type=%@",cls_createdby_userID,cla_classid_eid,studentType)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/student.php")
            
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
                                if self.studentTypeBool == true
                                {
                                    self.enrollArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                    self.enrolStudentTableView.reloadData()
                                }
                                else
                                {
                                     self.archiveArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                     self.studentArchiveTableView.reloadData()
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

    //MARK:- Delete Student Api
    
    
    func deleteStudentApi()
        
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
            
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            let post = NSString(format:"mem_id=%@&classid=%@",studentId,cla_classid_eid)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/student.php")
            
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
                                if self.deleteApiBool == true
                                {
                                
                                self.enrollArray.removeObjectAtIndex(self.studentDeleteIndexSave)
                                
                                self.enrolStudentTableView.reloadData()
                                    
                                }
                                
                                if self.deleteApiBool == false
                                
                                {
                                    self.archiveArray.removeObjectAtIndex(self.studentDeleteIndexSave)
                                    
                                    self.studentArchiveTableView.reloadData()
                                }
                                
                                self.studentList()
                                
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
    
    //MARK:- Archieved APi
    
    func ArchievedApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            
           
            let cla_classid_eid = NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"classid=%@&arch_stu_id=%@",cla_classid_eid,studentId)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/archive.php")
            
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
                                self.enrollArray.removeObjectAtIndex(self.studentDeleteIndexSave)
                                self.enrolStudentTableView.reloadData()
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
    

    //MARK:- UnArchieved APi
    
    func UnArchievedApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            
            
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"classid=%@&unarch_stu_id=%@",cla_classid_eid,studentId)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/archive.php")
            
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
                                self.archiveArray.removeObjectAtIndex(self.studentDeleteIndexSave)
                                self.studentArchiveTableView.reloadData()
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
