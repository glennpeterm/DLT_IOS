//
//  EnrollViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/7/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class GradeViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    

    @IBOutlet var menuView: UIView!

    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var grayView: UIView!
    @IBOutlet var gradeTableView: UITableView!
   
    var gradeStudentArray = NSMutableArray()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        GradestudentList()
        self.navigationController?.navigationBarHidden = false
        gradeTableView.tableFooterView = UIView(frame: CGRectZero)
       
      

        
    }
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            
            self.gradeTableView.userInteractionEnabled = true
           
            self.grayView.hidden = true
            
        })
        
    }
    

    
      //MARK:- TableView Methods
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gradeStudentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    {
        let gradeCell = tableView.dequeueReusableCellWithIdentifier("gradeCell", forIndexPath: indexPath) as! GradeTableViewCell
        
        gradeCell.studentNameLbl.text = ""
        
        var firstName = NSString()
        var lastName = NSString()
        
        if let name = gradeStudentArray[indexPath.row].valueForKey("Name")
        {
            firstName = name as! NSString
        }
        
        if let last = gradeStudentArray[indexPath.row].valueForKey("LastName")
        {
            lastName = last as! NSString
        }
        
        gradeCell.studentNameLbl!.text = "\(firstName) \(lastName)"
        

        return gradeCell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let studentGrade = storyboard?.instantiateViewControllerWithIdentifier("studentGrade") as! StudentGradeViewController
        
        studentGrade.Student_Id = gradeStudentArray[indexPath.row].valueForKey("Mem_id") as! String
        
        let stud_idGrade = gradeStudentArray[indexPath.row].valueForKey("Mem_id") as! String
        
        NSUserDefaults.standardUserDefaults().setValue(stud_idGrade, forKey: "Stud_Id_Grade")
        
                
        self.navigationController?.pushViewController(studentGrade, animated: true)
               
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
    

    //MARK:- Menu Bar Button
    
    
    @IBAction func menuBarBtn(sender: AnyObject)
    {
        
        
        
        if menuView.frame.origin.x == 0
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = -700
                
                self.gradeTableView.userInteractionEnabled = true
                
                self.grayView.hidden = true
            })
            
            
        }
            
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.gradeTableView.userInteractionEnabled = false
                
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
        let studentView = storyboard?.instantiateViewControllerWithIdentifier("studentView") as! StudentViewController
        
        self.navigationController?.pushViewController(studentView, animated: true)
    }
    
    
    @IBAction func menuEnrollBtn(sender: AnyObject)
    {
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            
            
            self.gradeTableView.userInteractionEnabled = true
           
            self.grayView.hidden = true
        })
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
    
    //MARK:- GradeStudent List
    
    func GradestudentList()
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
            
            let post = NSString(format:"userid=%@&classid=%@&student_type=%@",cls_createdby_userID,cla_classid_eid,"1")
            
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
                                
                                self.gradeStudentArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                self.gradeTableView.reloadData()
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
