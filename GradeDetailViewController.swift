//
//  GradeDetailViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/10/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Foundation

class GradeDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    var quizInfo: [Dictionary<String, AnyObject!>] = []
    var gradeInfo: [Dictionary<String, AnyObject!>] = []
    var quizScore: [Dictionary<String, AnyObject!>] = []
    var quizIDArray: [String] = []
    var quizTotalArray: [String] = []
    var quizGetPointArray: [String] = []
    
    var lesson_ID = NSString()
    var TotalGrade = NSString()
    
    @IBOutlet var totalGradeForClassTxtFied: UITextField!
    
    @IBOutlet var lessonTotalTxtField: UITextField!
    @IBOutlet var gradeQuizListTableView: UITableView!
    
    
    @IBOutlet var lessonGradeTxtField: UITextField!
    
    
    
    
    var index = Int()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        gradeQuizListTableView.tableFooterView = UIView(frame: CGRectZero)
        
        IQKeyboardManager.sharedManager().enable = true
        
        //(quizInfo)
        //(gradeInfo)
        //(index)
        //(quizScore)
        
        
        
        lessonGradeTxtField.text = "A"
        
        if let grade = gradeInfo[index]["grade"]
        {
            lessonGradeTxtField.text = grade as? String
        }
        
        
        lessonTotalTxtField.text = "0"
        
        if let score = quizScore[index]["total"]
        {
            lessonTotalTxtField.text = String(score)
        }
        
        //(lessonTotalTxtField.text)
        
        
        for var i = 0; i < quizInfo.count ; i++
        {
            quizIDArray.append(quizInfo[i]["quiz_id"] as! String)
            quizTotalArray.append(quizInfo[i]["total_point"] as! String)
            
           if let point = quizInfo[i]["get_point"] as? Int
           {
            
            //(String(point))
            
            quizGetPointArray.append("\(point)")
            
            }
            
            else if let point = quizInfo[i]["get_point"] as? String
            {
                quizGetPointArray.append(point as String)
            }
            
        }
        totalGradeForClassTxtFied.text = TotalGrade as String
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Back Button
    
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(false)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    //MARK:- TextField Delegate
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        quizInfo[textField.tag-999]["get_point"] = textField.text
        
    }
    
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return quizInfo.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let gradeQuiz = tableView.dequeueReusableCellWithIdentifier("gradeQuiz", forIndexPath: indexPath) as! GradeQuizListTableViewCell
       // //(quizInfo)
//        if let textfield = gradeQuiz.getPointTxtField.text
//        {
//            textfield.text =
//        }
       
        
        gradeQuiz.quizNameLbl.text = ""
        
        if let name = quizInfo[indexPath.row]["quiz_name"]
        {
            gradeQuiz.quizNameLbl.text = name as? String
        }
        
        
        
        gradeQuiz.getPointTxtField.text = "0"
        gradeQuiz.getPointTxtField.delegate = self
        gradeQuiz.getPointTxtField.tag = indexPath.row + 999
        
        if let point = quizInfo[indexPath.row]["get_point"]
        {
            gradeQuiz.getPointTxtField.text = String(point)
        }
        
        //(gradeQuiz.getPointTxtField.text)
        
        
        
        return gradeQuiz
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
        
        
        if cell.respondsToSelector("setLayoutMargins:")
        {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        
    }
    
    //MARK:-  TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
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
    
    
    //MARK:- Save Button
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        UpdateAndInsertGrade()
        
    }
    
    
    //MARK:- UpdateAndInsertGrade Api
    
    func UpdateAndInsertGrade()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            var quizIdStr = NSString()
            var quizGotItStr = NSString()
            
            for var i = 0;i < quizIDArray.count; i++
                
            {
               if let tmpButton = self.gradeQuizListTableView.viewWithTag(i+999) as? UITextField
               {
                
                //(tmpButton.tag)
                //(tmpButton.text!)
                
                if i == 0
                {
                    quizIdStr = quizIDArray[i]
                    
                    quizGotItStr = "\(tmpButton.text!)"
                }
                    
                else
                    
                {
                    quizIdStr = "\(quizIdStr),\(quizIDArray[i])"
                    
                    
                    quizGotItStr = "\(quizGotItStr),\(tmpButton.text!)"
                }
                }
            }
            
            
            
            
            //(quizIdStr)
            
            let Stud_Id_Grade = NSUserDefaults.standardUserDefaults().valueForKey("Stud_Id_Grade") as! String
            let cla_classid_eid =  NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            
            let post = NSString(format:"cid=%@&stud_id=%@&master_id=%@&hiddenquizscore=%@&gotit_point=%@&total_point=%@&gradeadd=%@&totgrade=%@&lesson_id=%@",cla_classid_eid,Stud_Id_Grade,quizIdStr,"100",quizGotItStr,lessonTotalTxtField.text!,lessonGradeTxtField.text!,totalGradeForClassTxtFied.text!,lesson_ID)
            
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
                                
                                let alert = UIAlertView(title: "Alert", message: "Inserted", delegate: self, cancelButtonTitle: "OK")
                                
                                alert.show()
                                IQKeyboardManager.sharedManager().enable = false
                                spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                
                                let alert = UIAlertView(title: "Alert", message: "No quiz attempted by Student", delegate: self, cancelButtonTitle: "OK")
                                
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
