//
//  ClassResourcesViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var resourceListApiBool = Bool()
class ClassResourcesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var finalResourceListArrayLocalDB = NSMutableArray()
     var demoMutArray = NSMutableArray()
    var resourceId = NSString()
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var grayView: UIView!
    @IBOutlet var addResourceBtn: UIButton!
    @IBOutlet var classResourceTableView: UITableView!
    @IBOutlet var menuView: UIView!
    var resourcesArray = NSMutableArray()
    var Index = Int()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        classResourceList()
        classResourceTableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(animated: Bool)
    {
        if resourceListApiBool == true
        {
            classResourceList()
            resourceListApiBool = false
        }
        
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidDisappear(animated: Bool)
    {
        positionUpdate()
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.classResourceTableView.frame.origin.x = 0
            self.classResourceTableView.userInteractionEnabled = true
            self.addResourceBtn.userInteractionEnabled = true
            self.grayView.hidden = true
        })
    }
    
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return resourcesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let classResourcesCell = tableView.dequeueReusableCellWithIdentifier("classResourcesCell", forIndexPath: indexPath) as! ClassResourcesTableViewCell
        
        if let reourceName = finalResourceListArrayLocalDB[indexPath.row].valueForKey("title")
        {
            classResourcesCell.classResourceNameLbl.text = reourceName as? String
        }
        
     /*    dispatch_async(dispatch_get_main_queue(), {
        
        let desc = self.resourcesArray[indexPath.row].valueForKey("desc") as! String
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
           
            classResourcesCell.imageWebView.loadHTMLString(code as String, baseURL: nil)
        }
        catch
        {
            // ("error in findAndOpenURL detector")
        }
            })*/
        return classResourcesCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let viewClassResource = storyboard?.instantiateViewControllerWithIdentifier("viewClassResource") as! ViewClassResourceViewController
        viewClassResource.decStr = finalResourceListArrayLocalDB[indexPath.row].valueForKey("desc") as! String
        viewClassResource.titleNavigation = finalResourceListArrayLocalDB[indexPath.row].valueForKey("title") as! String
        self.navigationController?.pushViewController(viewClassResource, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let shareAction = UITableViewRowAction(style: .Default, title: "Edit") { value in
            //("button did tapped!")
            let addResource = self.storyboard?.instantiateViewControllerWithIdentifier("addResource") as! AddClassResourcesViewController
            addResource.resourceIdStr = self.finalResourceListArrayLocalDB[indexPath.row].valueForKey("Res_Id") as! String
            addResource.showEditResourceBool = true
            self.navigationController?.pushViewController(addResource, animated: true)
        }
        
        let shareAction1 = UITableViewRowAction(style: .Default, title: "Delete") { value in
            //("button did tapped!")
            self.resourceId = self.finalResourceListArrayLocalDB[indexPath.row].valueForKey("Res_Id") as! String
            self.Index = indexPath.row
            self.deleteResourceApi()
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
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let stringToMove = finalResourceListArrayLocalDB[sourceIndexPath.row]
        finalResourceListArrayLocalDB.removeObjectAtIndex(sourceIndexPath.row)
        finalResourceListArrayLocalDB.insertObject(stringToMove, atIndex: destinationIndexPath.row)
        
    }
    
    
    //MARK:- Menu Bar Button
    
    
    @IBAction func menuBarBtn(sender: AnyObject)
    {
        if menuView.frame.origin.x == 0
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = -700
                self.classResourceTableView.frame.origin.x = 0
                self.classResourceTableView.userInteractionEnabled = true
                self.addResourceBtn.userInteractionEnabled = true
                self.grayView.hidden = true
            })
        }
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.classResourceTableView.frame.origin.x = self.menuView.frame.size.width
                self.classResourceTableView.userInteractionEnabled = false
                self.addResourceBtn.userInteractionEnabled = false
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
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.classResourceTableView.frame.origin.x = 0
            self.classResourceTableView.userInteractionEnabled = true
            self.addResourceBtn.userInteractionEnabled = true
            self.grayView.hidden = true
        })
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
    
    //MARK:- Resource List
    
    func classResourceList()
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
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/resource.php")
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
                                self.resourcesArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                self.insertResourceTableLocalDB()
                                //self.classResourceTableView.reloadData()
                                spinningIndicator.hide(true)
                            }
                            else
                            {
                                let alert = UIAlertView(title: "Alert", message: "No data", delegate: self,cancelButtonTitle: "OK")
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
    
    func insertResourceTableLocalDB()
    {
        let count = checkcount("Class_ID", objectId: "", tableName: "ResourceTable")
        for var i = 0 ; i < self.resourcesArray.count ; i++
        {
            if !checkExistance("Resource_ID", objectId: self.resourcesArray[i].valueForKey("Res_Id") as! String, tableName: "ResourceTable")
            {
                let resourceInfo : ResourceTable = ResourceTable()
                resourceInfo.Class_ID = NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
                resourceInfo.Resource_ID = self.resourcesArray[i].valueForKey("Res_Id") as! String
                resourceInfo.Position = Int(count)
                let isInserted = ModelManager.getInstance().addResourceData(resourceInfo)
                if isInserted
                {
                    // GetFilePath.invokeAlertMethod("", strBody: "Record Inserted successfully.", delegate: nil)
                } else
                {
                    // GetFilePath.invokeAlertMethod("", strBody: "Error in inserting record.", delegate: nil)
                }
                
            }
            count+1
            
        }
        GetFinalLessonArray()
        
    }
    
    func checkExistance(objectIdColumn: String, objectId: String, tableName: String)->Bool
    {
        let resultSet: FMResultSet! = ModelManager.getInstance().getResourceTableData(tableName, selectColumns: ["count(*) as count"], whereString: "\(objectIdColumn) = '\(objectId)'", whereFields: [])
        
        resultSet.next()
        
        let noOfRows = Int(resultSet.intForColumn("count"))
        
        resultSet.close()
        
        return (noOfRows > 0)
    }
    
    
    func GetFinalLessonArray()
    {
        finalResourceListArrayLocalDB = NSMutableArray()
        
        for var i = 0 ; i < self.resourcesArray.count ; i++
        {
            if checkExistance("Resource_ID", objectId: self.resourcesArray[i].valueForKey("Res_Id") as! String, tableName: "ResourceTable")
            {
                
                let strPostion = checkPosition("Resource_ID", objectId: self.resourcesArray[i].valueForKey("Res_Id") as! String, tableName: "ResourceTable")
                var dict = NSMutableDictionary()
                
                dict = resourcesArray[i] as! NSMutableDictionary
                dict.setValue(Int(strPostion), forKey: "Position")
                
                finalResourceListArrayLocalDB.addObject(dict)
                print(strPostion)
            }
        }
        print(finalResourceListArrayLocalDB)
        
        var pricediff = finalResourceListArrayLocalDB as NSArray
        print ( pricediff)
        let ageSortDescriptor = NSSortDescriptor(key: "Position", ascending: true)
        pricediff = (pricediff as NSArray).sortedArrayUsingDescriptors([ageSortDescriptor])
        print ( pricediff)
        finalResourceListArrayLocalDB = []
        finalResourceListArrayLocalDB = pricediff.mutableCopy() as! NSMutableArray
        print(finalResourceListArrayLocalDB)
        
        classResourceTableView.reloadData()
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
    func checkcount(objectIdColumn: String, objectId: String, tableName: String)->Int
    {
        let resultSet: FMResultSet! = ModelManager.getInstance().getTableData(tableName, selectColumns: ["MAX(Position) as count"], whereString: "", whereFields: [])
        
        resultSet.next()
        
        let noOfRows = Int(resultSet.intForColumn("count"))
        
        resultSet.close()
        
        return noOfRows
    }

    
    func positionUpdate()
    {
        for var i = 0 ; i < self.finalResourceListArrayLocalDB.count ; i++
        {
            let resourceInfo : ResourceTable = ResourceTable()
            resourceInfo.Class_ID = NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
            resourceInfo.Resource_ID = self.finalResourceListArrayLocalDB[i].valueForKey("Res_Id") as! String
            resourceInfo.Position = Int(i)
            let isUpdated = ModelManager.getInstance().updateResourceData(resourceInfo)
            if isUpdated {
                //Util.invokeAlertMethod("", strBody: "Record updated successfully.", delegate: nil)
            } else {
                // Util.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
            }
        }
        GetFinalLessonArray()
    }

    
    //MARK:- Add resource Button
    
    @IBAction func addResourceBtn(sender: AnyObject)
    {
        let addResource = storyboard?.instantiateViewControllerWithIdentifier("addResource") as! AddClassResourcesViewController
        self.navigationController?.pushViewController(addResource, animated: true)
    }
    
    //MARK:- Delete Resource api
    func deleteResourceApi()
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
            let post = NSString(format:"userid=%@&del_res_id=%@",cls_createdby_userID,resourceId)
            //(post)
            var dataModel = NSData()
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength = String(dataModel.length)
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/resource.php")
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
                                
                                let isDeleted = ModelManager.getInstance().deleteResourceData(self.resourceId)
                                if isDeleted {
                                    //   GetFilePath.invokeAlertMethod("", strBody: "Record deleted successfully.", delegate: nil)
                                } else {
                                    // GetFilePath.invokeAlertMethod("", strBody: "Error in deleting record.", delegate: nil)
                                }

                                
                                self.resourcesArray.removeObjectAtIndex(self.Index)
                                self.classResourceTableView.reloadData()
                                self.classResourceList()
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
    
    
}
