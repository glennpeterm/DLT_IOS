//
//  StudentQuizViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import CoreData
class StudentQuizViewController: UIViewController {

    var studentQuizArray: [Dictionary<String, AnyObject!>] = []
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var quizTableView: UITableView!
    var quizIDResult = NSString()
    var dashBoardIDResult = NSString()
    var alreadyGivenTests: [String] = []
    
    var User_IDQuiz_ID = [NSManagedObject]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        quizTableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"SubmitQuizAndUserId")
       
        
        
        //(fetchRequest)

        
        
        do
        {
            User_IDQuiz_ID = try   managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            var quizes: [String] = []
            
            for var i = 0; i < User_IDQuiz_ID.count; i++
            {
                quizes.append(User_IDQuiz_ID[i].valueForKey("quizID") as! String)
            }
            
            //(quizes)
            
            alreadyGivenTests = quizes
            
            //(alreadyGivenTests)
            
        }
        catch
        {
            //("Fetch failed: \((error as NSError).localizedDescription)")
        }
        
        
        

        getStudentQuizApi()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.quizTableView.frame.origin.x = 0
            
            
            self.quizTableView.userInteractionEnabled = true
        })
        
    }
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentQuizArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let quizCell = tableView.dequeueReusableCellWithIdentifier("studentQuizCell", forIndexPath: indexPath) as! StudentQuizTableViewCell
      
        quizCell.quizName.text = ""
        
        if let name = studentQuizArray[indexPath.row]["quiz_name"] as? String
        {
             quizCell.quizName.text = name
            
        }
        
       /* dispatch_async(dispatch_get_main_queue(),
            {

        
       if  let desc = self.studentQuizArray[indexPath.row]["quiz_desc"] as? String
       {
        
        
        
        do
        {
            var replaceUrl = NSString()
            if desc.containsString("http")
            {
                
                let types: NSTextCheckingType = .Link
                
                
                
                let detector = try NSDataDetector(types: types.rawValue)
                let matches = detector.matchesInString(desc, options: .ReportCompletion, range: NSMakeRange(0, desc.characters.count))
                if matches.count > 0
                {
                    let url = matches[0].URL!
                    //("Opening URL: \(url)")
                    
                    
                    
                    let vide = String(url)
                    
                    var decodeStr = NSString()
                    
                    let encodedData = vide.dataUsingEncoding(NSUTF8StringEncoding)!
                    
                    let attributedOptions : [String: AnyObject] =
                    [
                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                    ]
                    
                    do
                    {
                        
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        
                        
                        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                        
                        decodeStr  = decodedString
                        
                        //(decodeStr)
                        
                    }
                        
                    catch
                    {
                        
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                        
                    }
                    
                    
                    
                    
                    if let url1 = decodeStr.stringByReplacingOccurrencesOfString("youtu.be", withString: "youtube.com/embed") as? String
                    {
                        replaceUrl = url1
                        
                        
                    }
                        
                        
                    else if let url = decodeStr.stringByReplacingOccurrencesOfString("watch?v=", withString: "embed/") as? String
                    {
                        ////(url)
                        replaceUrl = url
                        
                    }
                    
                    
                }
                
            }
                
            else
                
            {
                replaceUrl = "http://youtube.com/embed/edzWTw0Yp"
            }
            
            let width = 290
            let height = 210
            let frame  = 0

            
            let code:NSString = "<iframe width=\(width) height=\(height) src=\(replaceUrl) frameborder=\(frame) allowfullscreen></iframe>"
          
            quizCell.imageWebView.loadHTMLString(code as String, baseURL: nil)
           
           
        }
        catch
        {
            // ("error in findAndOpenURL detector")
        }
        }
            
            })*/
        return quizCell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
      //  let apiQuizID = studentQuizArray[indexPath.row]["quiz_id"] as! String
       // let quiz_status = studentQuizArray[indexPath.row]["quiz_status"] as! String
        
      //  print(quiz_status)
//        if alreadyGivenTests.contains(apiQuizID) || quiz_status == "Completed"
//        {
//            let alert = UIAlertView(title: "Alert", message: "Test Completed", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            
//            
//        }
//        
//        else
//        {
            let quizQuestion = storyboard?.instantiateViewControllerWithIdentifier("studentQuizQuestion") as! StudentQuizQuestionViewController
            if let idq = studentQuizArray[indexPath.row]["quiz_id"] as? String
            {
                quizQuestion.quiz_id  = idq
            }
            self.navigationController?.pushViewController(quizQuestion, animated: true)

       // }
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
        let shareAction = UITableViewRowAction(style: .Default, title: "Result") { value in
            print("button did tapped!")
            
            self.quizIDResult = self.studentQuizArray[indexPath.row]["quiz_id"] as! String
            
            if let boardid = self.studentQuizArray[indexPath.row]["dashboard_id"] as? String
            {
                self.dashBoardIDResult = boardid
            }
            
            self.getResultQuizApi()
        }
        shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
        return [shareAction]
    }
    //MARK:- Menu Bar Button
    @IBAction func menuBarBtn(sender: AnyObject)
    {
        if menuView.frame.origin.x == 0
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = -700
                self.quizTableView.frame.origin.x = 0
                self.quizTableView.userInteractionEnabled = true
            })
        }
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.quizTableView.frame.origin.x = self.menuView.frame.size.width
                self.quizTableView.userInteractionEnabled = false
            })
        }
    }
    
    //MARK:- Menu Buttons
    @IBAction func menuClassBtn(sender: AnyObject)
    {
        let classListView = storyboard?.instantiateViewControllerWithIdentifier("studentClassListView") as! StudentClassViewController
        self.navigationController?.pushViewController(classListView, animated: true)
    }
    
    @IBAction func menuLessonBtn(sender: AnyObject)
    {
        let lessonView = storyboard?.instantiateViewControllerWithIdentifier("studentLessonView") as! StudentLessonViewController
        
        self.navigationController?.pushViewController(lessonView, animated: true)
    }
    
    @IBAction func menuClassResorcesBtn(sender: AnyObject)
    {
        let classResourceView = storyboard?.instantiateViewControllerWithIdentifier("StudentclassResourceView") as! StudentClassResourceViewController
        self.navigationController?.pushViewController(classResourceView, animated: true)
        
    }
    
    @IBAction func menuQuizBtn(sender: AnyObject)
    {
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.quizTableView.frame.origin.x = 0
            
            
            self.quizTableView.userInteractionEnabled = true
            
        })
    }
    @IBAction func menuEnrollBtn(sender: AnyObject)
    {
        
        let enrollView = storyboard?.instantiateViewControllerWithIdentifier("studentEnrollView") as! StudentEnrollViewController
        
        self.navigationController?.pushViewController(enrollView, animated: true)
    }
    
    @IBAction func logoutBtn(sender: AnyObject)
    {
        
        StudentLogoutApi()
        
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

    //MARK:- Get Student Quiz Api
    
    func getStudentQuizApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
            
        }
            
        else
            
        {
            let userID = NSUserDefaults.standardUserDefaults().valueForKey("StudentUserID") as! String
            let classID =  NSUserDefaults.standardUserDefaults().valueForKey("StudentClassID") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
           
            
            let post = NSString(format:"userid=%@&cid=%@",userID,classID)
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_quiz.php")
            
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
                                
                                self.studentQuizArray = jsonResults?.valueForKey("data") as! [Dictionary<String, AnyObject!>]
                                
                                self.quizTableView.reloadData()
                                
                                
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
    
     //MARK:- Student Logout Api
    
    func StudentLogoutApi()
    {
        
        
        let date = NSDate()
        
        let requestedComponents: NSCalendarUnit = [
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
    
    
    func getResultQuizApi()
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
            let Mem_Name = NSUserDefaults.standardUserDefaults().valueForKey("Mem_Name") as! String
            let post = NSString(format:"quizmasterid=%@&dashboard_id=%@&username=%@",quizIDResult,dashBoardIDResult,Mem_Name)
//             if alreadyGivenTests.contains(quizIDResult as String)
//             {
//                post = NSString(format:"quizmasterid=%@&dashboard_id=%@&status=%@",quizIDResult,dashBoardIDResult,"mobile")
//             }
//            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/quiz_result.php")
            
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
                                    
                                    let storyBoardStudent = UIStoryboard(name: "Student", bundle: nil)
                                    
                                    let quizResult = storyBoardStudent.instantiateViewControllerWithIdentifier("quizResult") as! StudentQuizResultViewController
                                    
                                    quizResult.arrayResult = jsonResults?.valueForKey("data") as! NSMutableArray
                                    self.navigationController?.pushViewController(quizResult, animated: true)

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
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
            
            
        }
        
        
    }

       
}
