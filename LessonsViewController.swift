//
//  LessonsViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia




var lessonApiToSaveBool = Bool()
class LessonsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var finalLessonListArrayLocalDB = NSMutableArray()
    var lessonDataLocalDB : NSMutableArray!
    var socialArray = NSMutableArray()
    var demoMutArray = NSMutableArray()
    var profileArray = NSArray()
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var menuBarBtn: UIBarButtonItem!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var zoomView: UIView!
    
    @IBOutlet var grayView: UIView!
    @IBOutlet var createLessonBtn: UIButton!
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var lessonsTableView: UITableView!

    var lessonID = NSString()
    var lessonListArray = NSMutableArray()
    var imageCache = [String:UIWebView]()
    
    var navigationTitle = String()
    var index = Int()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        
        lessonListApi()
        
        lessonsTableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.navigationBarHidden = false

       
    }

   func action(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
       if lessonApiToSaveBool == true
       {
        lessonListApi()
        lessonApiToSaveBool = false
        
        }
        profileImageApi()
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidDisappear(animated: Bool)
    {
       positionUpdate()
        
        UIView.animateWithDuration(0.4, animations:
            {
            self.menuView.frame.origin.x = -700
            self.lessonsTableView.frame.origin.x = 0
            
            self.grayView.hidden = true
            
            self.lessonsTableView.userInteractionEnabled = true
            
           
            self.createLessonBtn.userInteractionEnabled = true
            
            self.grayView.hidden = true
        })
        
    }
    

    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lessonListArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let lessons = tableView.dequeueReusableCellWithIdentifier("lessonListingCell", forIndexPath: indexPath) as! LessonsTableViewCell
        
        if let les = finalLessonListArrayLocalDB[indexPath.row].valueForKey("lesson_name")
        {
            
            lessons.lessonNameLbl.text = les as? String
        }
       
//        var replaceUrl = NSString()
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//       
//        
//        let vide = self.lessonListArray[indexPath.row].valueForKey("video_url")
//        var decodeStr = NSString()
//        
//        
//
//        let encodedData = vide!.dataUsingEncoding(NSUTF8StringEncoding)!
//        
//        let attributedOptions : [String: AnyObject] =
//        [
//            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
//        ]
//        
//        do
//        {
//            
//            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
//            
//            
//            let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
//            
//            decodeStr  = decodedString
//            
//            //(decodeStr)
//            
//        }
//            
//        catch
//        {
//            
//            //("Fetch failed: \((error as NSError).localizedDescription)")
//            
//        }
//        
//        if decodeStr.containsString("http") || decodeStr.containsString("file://")
//        {
//        
//        if let url1 = decodeStr.stringByReplacingOccurrencesOfString("youtu.be", withString: "youtube.com/embed") as? String
//        {
//            replaceUrl = url1
//            
//            
//        }
//            
//            
//        else if let url = decodeStr.stringByReplacingOccurrencesOfString("watch?v=", withString: "embed/") as? String
//        {
//            replaceUrl = url
//        }
//        }
//        else
//        {
//            
//            replaceUrl = "http://youtube.com/embed/edzWTw0Yp"
//        }
//        let width = 305
//        let height = 205
//        let frame  = 0
//        let code:NSString = "<iframe width=\(width) height=\(height) src=\(replaceUrl) frameborder=\(frame) allowfullscreen></iframe>"
//        lessons.videoWebView.loadHTMLString(code as String, baseURL: nil)
//         })
//        
//        
        
        return lessons
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let lessonDetail = storyboard?.instantiateViewControllerWithIdentifier("lessonDetail") as! LessonDetailViewController
        lessonDetail.editLessonAndPreviewLessonBool = false
       let descDecode  = finalLessonListArrayLocalDB[indexPath.row].valueForKey("desc") as! String
        let encodedData = descDecode.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] =
        [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        do
        {
            
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            
            
            let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
            
            lessonDetail.descriptionLessonStr  = decodedString
            
        }
            
        catch
        {
            
            //("Fetch failed: \((error as NSError).localizedDescription)")
            
        }
    
        
        lessonDetail.videoUrlStr = finalLessonListArrayLocalDB[indexPath.row].valueForKey("video_url") as! String
        lessonDetail.indexSaveCell = indexPath.row
        lessonDetail.lessonNameStr = finalLessonListArrayLocalDB[indexPath.row].valueForKey("lesson_name") as! String
        self.navigationController?.pushViewController(lessonDetail, animated: true)
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let shareAction = UITableViewRowAction(style: .Default, title: "Edit") { value in
            //("button did tapped!")
            
            let createLesson = self.storyboard?.instantiateViewControllerWithIdentifier("createLesson") as! CreateLessonViewController
            
            createLesson.lessonIdStr = self.finalLessonListArrayLocalDB[indexPath.row].valueForKey("les_id") as! String
            createLesson.EditApiBool = true
            self.navigationController?.pushViewController(createLesson, animated: true)
            
        }
        
        let shareAction1 = UITableViewRowAction(style: .Default, title: "Delete") { value in
            //("button did tapped!")
            
            self.lessonID = self.finalLessonListArrayLocalDB[indexPath.row].valueForKey("les_id") as! String
            self.index = indexPath.row
            self.deleteLessonapi()
        }
        
        shareAction.backgroundColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0)
       // shareAction1.backgroundColor = UIColor(patternImage:UIImage(named: "edit-gren.png")!)
        
        shareAction1.backgroundColor = UIColor(red: 255/255, green: 74/255, blue: 74/255, alpha: 1.0)
        //shareAction.backgroundColor = UIColor(patternImage:UIImage(named: "delete-clor.png")!)
        
        
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
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let stringToMove = finalLessonListArrayLocalDB[sourceIndexPath.row]
        finalLessonListArrayLocalDB.removeObjectAtIndex(sourceIndexPath.row)
        finalLessonListArrayLocalDB.insertObject(stringToMove, atIndex: destinationIndexPath.row)
        //positionUpdate()
    }
    

    
    //MARK:- Create Leeson
    
    

    @IBAction func createLessonBtn(sender: AnyObject)
    {
        let createLesson = self.storyboard?.instantiateViewControllerWithIdentifier("createLesson") as! CreateLessonViewController
        
                
        self.navigationController?.pushViewController(createLesson, animated: true)
        

    }
    
    //MARK:- Menu Bar Button
    
    
    @IBAction func menuBarBtn(sender: AnyObject)
    {
        
        
        
        if menuView.frame.origin.x == 0
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = -700
                self.lessonsTableView.frame.origin.x = 0
                
                self.grayView.hidden = true
                self.lessonsTableView.userInteractionEnabled = true
                
                self.createLessonBtn.userInteractionEnabled = true

            })
            
            
        }
            
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.lessonsTableView.frame.origin.x = self.menuView.frame.size.width
                
                self.lessonsTableView.userInteractionEnabled = false
               
                self.createLessonBtn.userInteractionEnabled = false
                
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
        
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.lessonsTableView.frame.origin.x = 0
            
            
            self.lessonsTableView.userInteractionEnabled = true
           
            self.createLessonBtn.userInteractionEnabled = true
            
            self.grayView.hidden = true

        })
        
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
            
            print(post)
            
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
                
                print(data)
                
                print(response)
                
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
                                
                                self.lessonListArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                self.insertLessonTableLocalDB()
                                //self.lessonsTableView.reloadData()
                                
                                NSUserDefaults.standardUserDefaults().setInteger(self.lessonListArray.count, forKey: "arrayCountSave")
                                
                                
                                
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
    
    //MARK:- DataBase Functions
    
    func insertLessonTableLocalDB()
    {
       
       var count = checkcount("Class_ID", objectId: "", tableName: "Lesson_Table")
        for var i = 0 ; i < self.lessonListArray.count ; i++
        {
            if !checkExistance("Lesson_ID", objectId: self.lessonListArray[i].valueForKey("les_id") as! String, tableName: "Lesson_Table")
            {
                let lessonInfo : LessonsTable = LessonsTable()
                lessonInfo.Class_ID = self.lessonListArray[i].valueForKey("Les_Cls_Id") as! String
                lessonInfo.Lesson_ID = self.lessonListArray[i].valueForKey("les_id") as! String
                lessonInfo.Position = Int(count)
                let isInserted = ModelManager.getInstance().addStudentData(lessonInfo)
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
        GetFinalLessonArray()

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
    
    func GetFinalLessonArray()
    {
        finalLessonListArrayLocalDB = NSMutableArray()
        for var i = 0 ; i < self.lessonListArray.count ; i++
        {
            if checkExistance("Lesson_ID", objectId: self.lessonListArray[i].valueForKey("les_id") as! String, tableName: "Lesson_Table")
            {

                let strPostion = checkPosition("Lesson_ID", objectId: self.lessonListArray[i].valueForKey("les_id") as! String, tableName: "Lesson_Table")
                var dict = NSMutableDictionary()
                
                dict = lessonListArray[i] as! NSMutableDictionary
                dict.setValue(Int(strPostion), forKey: "Position")
                
                finalLessonListArrayLocalDB.addObject(dict)
                 print(strPostion)
            }
        }
         print(finalLessonListArrayLocalDB)
        var pricediff = finalLessonListArrayLocalDB as NSArray
        print ( pricediff)
        let ageSortDescriptor = NSSortDescriptor(key: "Position", ascending: true)
        pricediff = (pricediff as NSArray).sortedArrayUsingDescriptors([ageSortDescriptor])
        print ( pricediff)
        finalLessonListArrayLocalDB = []
        finalLessonListArrayLocalDB = pricediff.mutableCopy() as! NSMutableArray
        print(finalLessonListArrayLocalDB)
        
        lessonsListArraySwipeProcess =  finalLessonListArrayLocalDB
        lessonsTableView.reloadData()
       
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
        for var i = 0 ; i < self.finalLessonListArrayLocalDB.count ; i++
        {
            let lessonInfo: LessonsTable = LessonsTable()
            lessonInfo.Class_ID = self.finalLessonListArrayLocalDB[i].valueForKey("Les_Cls_Id") as! String
            lessonInfo.Lesson_ID = self.finalLessonListArrayLocalDB[i].valueForKey("les_id") as! String
            lessonInfo.Position = Int(i)
            let isUpdated = ModelManager.getInstance().updateStudentData(lessonInfo)
            if isUpdated {
                //Util.invokeAlertMethod("", strBody: "Record updated successfully.", delegate: nil)
            } else {
               // Util.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
            }
            
        }
        GetFinalLessonArray()
    }
    
    
    
    //MARK:- Delete Lesson api
    
    func deleteLessonapi()
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
            
            let post = NSString(format:"userid=%@&del_les_id=%@",cls_createdby_userID,lessonID)
            
            print(post)
            
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
                            let data = jsonResults?.valueForKey("data") as! String
                            
                            if success
                            {
                                
                               
                                let isDeleted = ModelManager.getInstance().deleteStudentData(self.lessonID)
                                if isDeleted
                                {
                                 //   GetFilePath.invokeAlertMethod("", strBody: "Record deleted successfully.", delegate: nil)
                                } else {
                                   // GetFilePath.invokeAlertMethod("", strBody: "Error in deleting record.", delegate: nil)
                                }
                                

                                self.lessonListArray.removeObjectAtIndex(self.index)
                                
                                self.lessonsTableView.reloadData()
                                
                                self.lessonListApi()
                                
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
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
        

        
        
        
    }
    
    //MARK:- ProfileImage
    func profileImageApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
            
        }
            
        else
            
        {
            let userID = NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            
            let Mem_Name = NSUserDefaults.standardUserDefaults().valueForKey("Mem_NameTeacher") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            
            let post = NSString(format:"userid=%@&username=%@",userID,Mem_Name)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/profiles.php")
            
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
                                
                                self.profileArray = jsonResults?.valueForKey("data") as! NSArray
                                
                              if  let imageStr = self.profileArray[0].valueForKey("photo")
                              {
                                
                                let request : NSURLRequest = NSURLRequest(URL: NSURL(string: imageStr as! String)!)
                                
                                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,data,error) -> Void in
                                    if error == nil
                                    {
                                        //print(data)
                                        if data != nil
                                        {
                                         let image = UIImage(data: data!)!
                                        
                                            dispatch_async(dispatch_get_main_queue(),{
                                                spinningIndicator.hide(true)
                                                self.profileImage.image = image
                                            })
                                       
                                           }
                                    }
                                    else
                                    {
                                        spinningIndicator.hide(true)
                                        print("Error: \(error!.localizedDescription)")
                                    }
                                })
                                
                                }
                                else
                                {
                                spinningIndicator.hide(true)
                                }
                                
                                
                                if let socialarr = self.profileArray[0].valueForKey("social")
                                {
                                    self.socialArray = socialarr as! NSMutableArray
                                }
                                
                            }
                            else
                            {
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
    
    
    //MARK:- image Button
    
    
    @IBAction func imageBtn(sender: AnyObject)
    {
        let storyBoardStudent = UIStoryboard(name: "Student", bundle: nil)

        let profile = storyBoardStudent.instantiateViewControllerWithIdentifier("profile") as! ProfileViewController
        if let whats = socialArray[0].valueForKey("whatsapp")
        {
            profile.whatsupstr = whats as! String
        }
        
        if let wechat = socialArray[0].valueForKey("wechat")
        {
            profile.wechatStr = wechat as! String
        }

        if let socialid = socialArray[0].valueForKey("social_id")
        {
            profile.socialidStr = socialid as! String
        }

        
        profile.emailStr = profileArray[0].valueForKey("email") as! String
        profile.phoneNoStr = profileArray[0].valueForKey("phonenumber") as! String
        profile.firstNameStr = profileArray[0].valueForKey("firstname") as! String
        profile.lastNameStr = profileArray[0].valueForKey("lastName") as! String
        profile.descStr = profileArray[0].valueForKey("description") as! String
        profile.teacherStudentBool = true
        profile.imageBackToFront = profileImage.image!
        self.navigationController?.pushViewController(profile, animated: true)
        
        

    }
    
    
  
}
