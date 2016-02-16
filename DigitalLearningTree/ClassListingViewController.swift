//
//  ClassListingViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/5/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import CoreData
var loginbacktoschoolBool = Bool()
var backfromEditDeleteChngePicBool = Bool()

class ClassListingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
     var finalClassListArrayLocalDB = NSMutableArray()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    var demoMutArray = NSMutableArray()
    var imageCache = [String:UIImage]()
    
    var usernameClassList = NSString()
    var passwordClassList = NSString()
     var demoArry = [String]()
    @IBOutlet var createNewClass: UIButton!
    @IBOutlet var classListingTableView: UITableView!
   
    var moveCellData = [NSManagedObject]()
    
    var alreadyGetMoveCellData = NSMutableArray()
    
    var classListArray = NSMutableArray()
   
    override func viewDidLoad()
    {
       
        super.viewDidLoad()
       
        classListingTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool)
    {
        getCLassApi()

        
        self.navigationItem.hidesBackButton = true
        
    }
    
    
    override func viewDidDisappear(animated: Bool)
    {
        positionUpdate()
     
    }

    //MARK:- TableView Deleagte
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return classListArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let classListingCell = tableView.dequeueReusableCellWithIdentifier("classListingCell", forIndexPath: indexPath) as! ClassListingTableViewCell
        
        classListingCell.className.text = finalClassListArrayLocalDB[indexPath.row].valueForKey("cls_name") as? String
        classListingCell.subjectName.text = finalClassListArrayLocalDB[indexPath.row].valueForKey("subject") as? String
        let student = finalClassListArrayLocalDB[indexPath.row]["students"] as! String
        //(student)
        classListingCell.studentCount.text = "Student(s):\(student)"
        return classListingCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        backfromEditDeleteChngePicBool = true
        
        let classNameAndDetail = storyboard?.instantiateViewControllerWithIdentifier("classNameAndDetail") as! ClassNameAndDetailViewController
        
       if  let clsCreatedIDUserID = finalClassListArrayLocalDB[indexPath.row].valueForKey("cls_createdby") as? String
       {
        //(clsCreatedIDUserID)
        
        NSUserDefaults.standardUserDefaults().setValue(clsCreatedIDUserID, forKey: "cls_createdby_userID")
        }
        
        
        
        classNameAndDetail.descriptionStr = "No Description"
        
        if let desc = finalClassListArrayLocalDB[indexPath.row].valueForKey("Cls_desc") as? String
        {
        
        classNameAndDetail.descriptionStr = desc
            
        }
        
        let cla_classid_eid = finalClassListArrayLocalDB[indexPath.row].valueForKey("cla_classid") as! String
        
        //(cla_classid_eid)
         NSUserDefaults.standardUserDefaults().setValue(cla_classid_eid, forKey: "cla_classid_eid")
        
        
        classNameAndDetail.className = finalClassListArrayLocalDB[indexPath.row].valueForKey("cls_name") as! String
        
        
        
        if let topicN = finalClassListArrayLocalDB[indexPath.row].valueForKey("subject")
        {
            classNameAndDetail.topicName = topicN as! NSString
        }
        
        self.navigationController?.pushViewController(classNameAndDetail, animated: true)
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        let shareAction = UITableViewRowAction(style: .Default, title: "Edit") { value in
            
            let editView = self.storyboard?.instantiateViewControllerWithIdentifier("editView") as! EditClassViewController
            backfromEditDeleteChngePicBool = false
            self.navigationController?.pushViewController(editView, animated: true)
            
            
            let clsCreatedIDUserID = self.finalClassListArrayLocalDB[indexPath.row].valueForKey("cls_createdby") as! String
            
            //(clsCreatedIDUserID)
            
            NSUserDefaults.standardUserDefaults().setValue(clsCreatedIDUserID, forKey: "cls_createdby_userID")
            
            
            
            let cla_classid_eid = self.finalClassListArrayLocalDB[indexPath.row].valueForKey("cla_classid") as! String
            
            //(cla_classid_eid)
            NSUserDefaults.standardUserDefaults().setValue(cla_classid_eid, forKey: "cla_classid_eid")

            
            
        }
       
       shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
        
        
        return [shareAction]
        
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
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        
        //(classListArray)
        
        let stringToMove = finalClassListArrayLocalDB[sourceIndexPath.row]
        finalClassListArrayLocalDB.removeObjectAtIndex(sourceIndexPath.row)
        finalClassListArrayLocalDB.insertObject(stringToMove, atIndex: destinationIndexPath.row)
        
        //(classListArray)
        
    }
    
    
    
    
    //MARK:- Get Class Api
    
    func getCLassApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()

            
        }
            
        else
            
        {
             usernameClassList = NSUserDefaults.standardUserDefaults().valueForKey("Username") as! String
             passwordClassList =  NSUserDefaults.standardUserDefaults().valueForKey("Password") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            let schID = NSUserDefaults.standardUserDefaults().valueForKey("schID") as! String
            
            let post = NSString(format:"username=%@&password=%@&logid=%@",usernameClassList,passwordClassList, schID)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/login.php")
            
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
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            if success
                            {
                                if jsonResults?.valueForKey("class_data") as? String != "0"
                                {
                               self.classListArray = jsonResults?.valueForKey("class_data") as! NSMutableArray
                                    self.insertClassTableLocalDB()

                                spinningIndicator.hide(true)
                                
                                let memSchiD = jsonResults?.valueForKey("Mem_Sch_Id") as! String
                                
                                let userId = jsonResults?.valueForKey("Sch_Mem_id") as! String
                                
                                NSUserDefaults.standardUserDefaults().setValue(memSchiD, forKey: "loginapiMemSchId")
                                
                                NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "loginapiSchMemId")
                                }
                                
                                else
                                {
                                    let alert = UIAlertView(title: "Alert", message: "No Data", delegate: self, cancelButtonTitle: "OK")
                                    
                                    alert.show()
                                    
                                    spinningIndicator.hide(true)
                                }

                                
                            }
                                
                            else
                                
                            {
                                
                                let alert = UIAlertView(title: "Alert", message: "No Data", delegate: self, cancelButtonTitle: "OK")
                                
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
    
    //MARK:- DataBase Functions
    
    func insertClassTableLocalDB()
    {
        
        var count = checkcount("Class_ID", objectId: "", tableName: "Class_Table")
        for var i = 0 ; i < self.classListArray.count ; i++
        {
            if !checkExistance("Lesson_ID", objectId: self.classListArray[i].valueForKey("cla_classid") as! String, tableName: "Lesson_Table")
            {
                let classTable : ClassTable = ClassTable()
                classTable.Class_ID = self.classListArray[i].valueForKey("cla_classid") as! String
                classTable.Mem_ID = self.classListArray[i].valueForKey("cls_createdby") as! String
                classTable.Position = Int(count)
                let isInserted = ModelManager.getInstance().addClassData(classTable)
                if isInserted
                {
                    // GetFilePath.invokeAlertMethod("", strBody: "Record Inserted successfully.", delegate: nil)
                } else
                {
                    // GetFilePath.invokeAlertMethod("", strBody: "Error in inserting record.", delegate: nil)
                }
                count = count+1
            }
        }
        GetFinalClassArray()
        
    }
    
    func checkExistance(objectIdColumn: String, objectId: String, tableName: String)->Bool
    {
        let resultSet: FMResultSet! = ModelManager.getInstance().getTableData(tableName, selectColumns: ["count(*) as count"], whereString: "\(objectIdColumn) = '\(objectId)'", whereFields: [])
        
        resultSet.next()
        
        let noOfRows = Int(resultSet.intForColumn("count"))
        
        resultSet.close()
        
        return (noOfRows > 0)
    }
    
    func checkcount(objectIdColumn: String, objectId: String, tableName: String)->Int
    {
        let resultSet: FMResultSet! = ModelManager.getInstance().getTableData(tableName, selectColumns: ["MAX(Position) as count"], whereString: "", whereFields: [])
        
        resultSet.next()
        
        let noOfRows = Int(resultSet.intForColumn("count"))
        
        resultSet.close()
        
        return noOfRows
    }
    
    func GetFinalClassArray()
    {
        finalClassListArrayLocalDB = NSMutableArray()
        for var i = 0 ; i < self.classListArray.count ; i++
        {
            if checkExistance("Class_ID", objectId: self.classListArray[i].valueForKey("cla_classid") as! String, tableName: "Class_Table")
            {
                
                let strPostion = checkPosition("Class_ID", objectId: self.classListArray[i].valueForKey("cla_classid") as! String, tableName: "Class_Table")
                var dict = NSMutableDictionary()
                
                dict = classListArray[i] as! NSMutableDictionary
                dict.setValue(Int(strPostion), forKey: "Position")
                
                finalClassListArrayLocalDB.addObject(dict)
                print(strPostion)
            }
        }
        print(finalClassListArrayLocalDB)
        var pricediff = finalClassListArrayLocalDB as NSArray
        print ( pricediff)
        let ageSortDescriptor = NSSortDescriptor(key: "Position", ascending: true)
        pricediff = (pricediff as NSArray).sortedArrayUsingDescriptors([ageSortDescriptor])
        print ( pricediff)
        finalClassListArrayLocalDB = []
        finalClassListArrayLocalDB = pricediff.mutableCopy() as! NSMutableArray
        print(finalClassListArrayLocalDB)
        
        
        classListingTableView.reloadData()
        
        // print(finalLessonListArrayLocalDB)
        
    }
    
    func checkPosition(objectIdColumn: String, objectId: String, tableName: String)->String
    {
        let resultSet: FMResultSet! = ModelManager.getInstance().getTableData(tableName, selectColumns: ["*"], whereString: "\(objectIdColumn) = '\(objectId)'", whereFields: [])
        
        resultSet.next()
        
        let noOfRows = resultSet.stringForColumn("Position")
        
        resultSet.close()
        
        return noOfRows
    }
    
    func positionUpdate()
    {
        for var i = 0 ; i < self.finalClassListArrayLocalDB.count ; i++
        {
            let classTable: ClassTable = ClassTable()
            classTable.Class_ID = self.finalClassListArrayLocalDB[i].valueForKey("cla_classid") as! String
            classTable.Mem_ID = self.finalClassListArrayLocalDB[i].valueForKey("cls_createdby") as! String
            classTable.Position = Int(i)
            let isUpdated = ModelManager.getInstance().updateClassData(classTable)
            if isUpdated {
                //Util.invokeAlertMethod("", strBody: "Record updated successfully.", delegate: nil)
            } else {
                // Util.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
            }
            
        }
        GetFinalClassArray()
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
    
    //MARK:- Logout Button
    
    @IBAction func logoutBtn(sender: AnyObject)
    {
        let login = storyboard?.instantiateViewControllerWithIdentifier("teacherLogin") as! LoginViewController
        
        loginbacktoschoolBool = true
        login.StudentAndTeacherLoginBool = true
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "Login")
        self.navigationController?.pushViewController(login, animated: false)

    }
    
    
}
