//
//  QuizViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var demoMutArray = NSMutableArray()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var grayView: UIView!
    @IBOutlet var createQuizBtn: UIButton!
    @IBOutlet var menuView: UIView!
    @IBOutlet var quizTableView: UITableView!
    var quizID = NSString()
    var quizArray = NSMutableArray()
    var Index = Int()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        

        quizTableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        quizListing()
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.quizTableView.frame.origin.x = 0
            
            
            self.quizTableView.userInteractionEnabled = true
            
            self.createQuizBtn.userInteractionEnabled = true
           
            self.grayView.hidden = true
        })
        
    }

    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return quizArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let quizCell = tableView.dequeueReusableCellWithIdentifier("quizCell", forIndexPath: indexPath) as! QuizTableViewCell
        
         quizCell.quizNameLbl.text = ""
        
        if let name = quizArray[indexPath.row].valueForKey("quiz_name")
        {
            quizCell.quizNameLbl.text = name as? String
        }
        
        quizCell.lastModeiftDate.text = ""
        
        if let datemodify = quizArray[indexPath.row].valueForKey("last_modified")
        {
            quizCell.lastModeiftDate.text = datemodify as? String
        }
        
      /*  dispatch_async(dispatch_get_main_queue(), {
       let desc = self.quizArray[indexPath.row].valueForKey("quiz_desc") as! String
        
        
        
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
            })*/
        return quizCell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let quizQuestion = storyboard?.instantiateViewControllerWithIdentifier("quizQuestion") as! QuizQuestionViewController
        quizQuestion.quizID = quizArray[indexPath.row].valueForKey("quizid") as! String
        self.navigationController?.pushViewController(quizQuestion, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let shareAction = UITableViewRowAction(style: .Default, title: "Edit") { value in
            //("button did tapped!")
            
           let editQuiz = self.storyboard?.instantiateViewControllerWithIdentifier("createQuiz") as! CreateQuizViewController
            
            editQuiz.quizID = self.quizArray[indexPath.row].valueForKey("quizid") as! String
            QuizeditApiBool = true
            
            self.navigationController?.pushViewController(editQuiz, animated: true)
            
        }
        
        let shareAction1 = UITableViewRowAction(style: .Default, title: "Delete") { value in
            //("button did tapped!")
            
            self.quizID = self.quizArray[indexPath.row].valueForKey("quizid") as! String
            self.Index = indexPath.row
            self.deleteQuizApi()
            
        }
        
        shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
       
        
        shareAction1.backgroundColor = UIColor(red: 255/255, green: 74/255, blue: 74/255, alpha: 1.0)
        
        
        
        return [shareAction1,shareAction]
        
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
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
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
                self.createQuizBtn.userInteractionEnabled = true
               
                self.grayView.hidden = true

            })
            
            
        }
            
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.quizTableView.frame.origin.x = self.menuView.frame.size.width
                
                self.quizTableView.userInteractionEnabled = false
                self.createQuizBtn.userInteractionEnabled = false
                
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
       
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.quizTableView.frame.origin.x = 0
            
            
            self.quizTableView.userInteractionEnabled = true
            self.createQuizBtn.userInteractionEnabled = true
          
            self.grayView.hidden = true

        })

        
    }
    
    @IBAction func menuStudentBtn(sender: AnyObject)
    {
        let studentView = storyboard?.instantiateViewControllerWithIdentifier("studentView") as! StudentViewController
        
        self.navigationController?.pushViewController(studentView, animated: true)
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
    
    //MARK:- Quiz List
    
    func quizListing()
    {
        var spinningIndicator = MBProgressHUD()
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"userid=%@&quizcid=%@",cls_createdby_userID,cla_classid_eid)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/quiz.php")
            
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
                        print(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            
                            if success
                            {
                                
                                self.quizArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                self.quizTableView.reloadData()
                                
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message: "No data", delegate: self, cancelButtonTitle: "OK")
                                alert.show()
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "saveCheckMarkQuizLesson")
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
    
    
    //MARK:- Delete Quiz api
    
    func deleteQuizApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"userid=%@&del_qm_id=%@",cls_createdby_userID,quizID)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/quiz.php")
            
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
                        print(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            let data = jsonResults?.valueForKey("data") as! String
                            
                            if success
                            {
                                
                                self.quizArray.removeObjectAtIndex(self.Index)
                                
                                self.quizTableView.reloadData()
                                
                                self.quizListing()
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message: data, delegate: self, cancelButtonTitle: "OK")
                                
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
    
    
 //MARK:- Create Quiz Button
    
    @IBAction func createQuizBtn(sender: AnyObject)
    {
        let editQuiz = self.storyboard?.instantiateViewControllerWithIdentifier("createQuiz") as! CreateQuizViewController
        
       
        QuizeditApiBool = false
        
        self.navigationController?.pushViewController(editQuiz, animated: true)
    }
    

}
