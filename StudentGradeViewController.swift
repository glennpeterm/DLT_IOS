//
//  StudentGradeViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 12/10/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class StudentGradeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    
    var quiz_json_info: [Dictionary<String, AnyObject!>] = []
    var grade_json_info: [Dictionary<String, AnyObject!>] = []
    var quiz_total_Score: [Dictionary<String, AnyObject!>] = []
    
    var totalGradeForClass = NSString()
    
    @IBOutlet var studentGradeTableView: UITableView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    var studentGradeArray = NSArray()
    
    var Student_Id = NSString()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        StudentGradeApi()
        
        studentGradeTableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationItem.title = "Lessons"
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
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
    
    
    
    //MARK:- TableView Methods
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentGradeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        let StudentgradeCell = tableView.dequeueReusableCellWithIdentifier("StudentgradeCell", forIndexPath: indexPath) as! StudentGradeTableViewCell
        
        StudentgradeCell.lessonnameLbl.font = UIFont(name: "Arial", size: 18)
        
        StudentgradeCell.textLabel?.text = ""
        
        if let lessonname = studentGradeArray[indexPath.row].valueForKey("lesson_name")
        {
            StudentgradeCell.lessonnameLbl.text = lessonname as? String
        }
        return StudentgradeCell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let lessonid = studentGradeArray[indexPath.row].valueForKey("les_id")
        
        var quiz_info: [Dictionary<String, AnyObject!>] = []
        
        for info in quiz_json_info
        {
            if info["ass_less_id"] as? String == lessonid as? String
            {
                quiz_info.append(info)
            }
        }
        
        
        //(quiz_info)
        //(grade_json_info)
        
        let gradeDetail = storyboard?.instantiateViewControllerWithIdentifier("gradeDetail") as! GradeDetailViewController
        gradeDetail.quizScore = quiz_total_Score
        gradeDetail.quizInfo = quiz_info
        gradeDetail.gradeInfo = grade_json_info
        gradeDetail.index = indexPath.row
        gradeDetail.lesson_ID = lessonid as! String
        gradeDetail.TotalGrade = totalGradeForClass
        self.navigationController?.pushViewController(gradeDetail, animated: true)
        
        
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
    
    //MARK:- StudentGrade Api
    
    func StudentGradeApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
        else
        {
            let cla_classid_eid =  NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let post = NSString(format:"cid=%@&studid=%@",cla_classid_eid,Student_Id)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/grade.php")
            
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
                    print("\(error?.localizedDescription)")
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
                                let dict = jsonResults?.valueForKey("data") as! NSDictionary
                                
                                self.studentGradeArray = dict.valueForKey("lesson_info") as! NSArray
                                
                                //(self.studentGradeArray)
                                
                                if let Quiz_Info = dict.valueForKey("quiz_info") as? [Dictionary<String, AnyObject!>]
                                {
                                    
                                self.quiz_json_info = Quiz_Info
                                    
                                    
                                }
                                
                                if let grade_Info = dict.valueForKey("grade_info") as? [Dictionary<String, AnyObject!>]
                                {
                                self.grade_json_info = grade_Info
                                }
                                
                                if let quiztotal =  dict.valueForKey("quiz_total_score") as? [Dictionary<String, AnyObject!>]
                                {
                                     self.quiz_total_Score = quiztotal
                                }
                                
                               
                                self.studentGradeTableView.reloadData()
                                
                                let total_grade = dict.valueForKey("total_grade") as! NSDictionary
                                
                                self.totalGradeForClass = ""
                                
                                if let grade =  total_grade.valueForKey("total_grade_for_class") as? String
                                {
                                    self.totalGradeForClass = grade
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
    
    
    
    
    //MARK:- Back Button
    
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- UpdateAndInsertGrade Api
    
//    func UpdateAndInsertGrade()
//    {
//        
//        if Reachability.isConnectedToNetwork() == false
//        {
//            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
//            
//            alert.show()
//            
//        }
//            
//        else
//            
//        {
//            var quizIdStr = NSString()
//            var quizGotItStr = NSString()
//            
//            for var i = 0;i < quizIDArray.count; i++
//                
//            {
//                if let tmpButton = self.gradeQuizListTableView.viewWithTag(i+999) as? UITextField
//                {
//                    
//                    //(tmpButton.tag)
//                    //(tmpButton.text!)
//                    
//                    if i == 0
//                    {
//                        quizIdStr = quizIDArray[i]
//                        
//                        quizGotItStr = "\(tmpButton.text!)"
//                    }
//                        
//                    else
//                        
//                    {
//                        quizIdStr = "\(quizIdStr),\(quizIDArray[i])"
//                        
//                        
//                        quizGotItStr = "\(quizGotItStr),\(tmpButton.text!)"
//                    }
//                }
//            }
//            
//            
//            
//            
//            //(quizIdStr)
//            
//            let Stud_Id_Grade = NSUserDefaults.standardUserDefaults().valueForKey("Stud_Id_Grade") as! String
//            let cla_classid_eid =  NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
//            
//            
//            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            spinningIndicator.labelText = "Loading"
//            
//            
//            let post = NSString(format:"cid=%@&stud_id=%@&master_id=%@&hiddenquizscore=%@&gotit_point=%@&total_point=%@&gradeadd=%@&totgrade=%@&lesson_id=%@",cla_classid_eid,Stud_Id_Grade,quizIdStr,"100",quizGotItStr,lessonTotalTxtField.text!,lessonGradeTxtField.text!,totalGradeForClassTxtFied.text!,lesson_ID)
//            
//            //(post)
//            
//            var dataModel = NSData()
//            
//            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            
//            let postLength = String(dataModel.length)
//            
//            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/grade.php")
//            
//            let urlRequest = NSMutableURLRequest(URL: url!)
//            
//            urlRequest.HTTPMethod = "POST"
//            urlRequest.HTTPBody = dataModel
//            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
//            
//            let session = NSURLSession.sharedSession()
//            
//            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
//                
//                //(data)
//                
//                //(response)
//                
//                if (error != nil)
//                {
//                    let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
//                    
//                    alert.show()
//                    //("\(error?.localizedDescription)")
//                    dispatch_async(dispatch_get_main_queue(), {
//                        spinningIndicator.hide(true)
//                    })
//                }
//                    
//                else
//                {
//                    
//                    
//                    
//                    var jsonResults : NSDictionary?
//                    
//                    
//                    do
//                    {
//                        jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
//                        
//                        // success ...
//                        //(jsonResults)
//                        
//                        dispatch_async(dispatch_get_main_queue(), {
//                            
//                            
//                            
//                            
//                            let success = jsonResults?.valueForKey("success") as! Bool
//                            
//                            
//                            if success
//                            {
//                                
//                                let alert = UIAlertView(title: "Alert", message: "Inserted", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
//                                IQKeyboardManager.sharedManager().enable = false
//                                spinningIndicator.hide(true)
//                                
//                                
//                                
//                            }
//                            else
//                                
//                            {
//                                
//                                
//                                let alert = UIAlertView(title: "Alert", message: "No quiz attempted by Student", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
//                                spinningIndicator.hide(true)
//                                
//                            }
//                            
//                            
//                            
//                        })
//                        
//                        
//                        
//                    }
//                    catch
//                    {
//                        
//                        dispatch_async(dispatch_get_main_queue(),
//                            {
//                                let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
//                                
//                                alert.show()
//                                spinningIndicator.hide(true)
//                        })
//                        //("Fetch failed: \((error as NSError).localizedDescription)")
//                    }
//                    
//                    
//                    
//                }
//                
//                
//            })
//            task.resume()
//        }
    
}
