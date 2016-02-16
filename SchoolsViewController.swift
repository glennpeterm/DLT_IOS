//
//  SchoolsViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/18/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class SchoolsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    var spinningIndicator = MBProgressHUD()

   
    var searchArray = NSDictionary()
    @IBOutlet var searchTxtField: UITextField!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    var imageCache = [String:UIImage]()
    @IBOutlet var schoolTableView: UITableView!
    var schoolsDetail = NSMutableArray()
    var tempArray = NSMutableArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        let paddingViewUserName = UIView(frame: CGRectMake(0, 0, 25, searchTxtField.frame.size.height))
        searchTxtField.leftView = paddingViewUserName
        searchTxtField.leftViewMode = UITextFieldViewMode.Always

       schoolTableView.tableFooterView = UIView(frame: CGRectZero)
       searchTxtField.delegate = self
        
        searchTxtField.layer.borderWidth = 0.5
        searchTxtField.layer.borderColor = UIColor.lightGrayColor().CGColor
        searchTxtField.layer.cornerRadius = 5
        
        schoolApi()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - TextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {

       schoolsDetail = []
       //(string.characters.count)
        
        var check = 1;
        
        
        
        if string.characters.count == 0
        {
            
           if  textField.text!.characters.count == 1
           {
            
                schoolsDetail = tempArray
                schoolTableView.reloadData()
                check = 0;
            }
            
           else
           {
            check = 1;
            }

        }
        
        
        
        
        
        if(check == 1)
        {
            let str = "\(textField.text!)\(string)"
            for var i = 0 ; i < tempArray.count ; i++
            {
                if  tempArray[i].valueForKey("sch_name")!.rangeOfString(str).location != NSNotFound
                {
                    searchArray = tempArray[i] as! NSDictionary
                    
                    schoolsDetail.addObject(searchArray)
                    
                     //(searchArray.count)
                    //(searchArray)
                }
                
            }
            
            schoolTableView.reloadData()
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
     //MARK:- School Api
    func schoolApi()
    {
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }
            
        else
            
        {
            
            dispatch_async(dispatch_get_main_queue(), {
            
            self.spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.spinningIndicator.labelText = "Loading"
            })
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/schools.php")
            
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            urlRequest.HTTPMethod = "GET"
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
                
                
                
                if (error != nil)
                {
                    
                    
                    //("\(error?.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
                            
                            alert.show()

                        self.spinningIndicator.hide(true)
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
                                
                              
                                self.schoolsDetail = jsonResults?.valueForKey("data") as! NSMutableArray
                                
                                self.tempArray = self.schoolsDetail
                                
                                 self.schoolTableView.hidden = false
                                self.schoolTableView.reloadData()
                                //(self.schoolsDetail)
                                self.spinningIndicator.hide(true)
                                
                                
                                
                            }
                            else
                                
                            {
                                let alert = UIAlertView(title: "Alert", message: "No Data", delegate: self, cancelButtonTitle: "OK")
                                alert.show()
                                self.schoolTableView.hidden = false
                                self.spinningIndicator.hide(true)
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                    catch
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinningIndicator.hide(true)
                        })
                        
                        let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
                        
                        alert.show()
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }
    }

    //MARK:-  TableView Methods
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return schoolsDetail.count
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let schoolCell = tableView.dequeueReusableCellWithIdentifier("schoolCell", forIndexPath: indexPath) as! SchoolTableViewCell
        
        schoolCell.schoolName.text = "Digital Learning Tree"
        
        if let schoolName = schoolsDetail[indexPath.row].valueForKey("sch_name")
        {
            schoolCell.schoolName.text = schoolName as? String
        }
        
        
        schoolCell.schoolLogoImage.image = UIImage(named: "logo.png")

        if  let urlString  =  schoolsDetail[indexPath.row].valueForKey("sch_photo_thumb") as? String, imagUrl = NSURL(string: urlString)
        {
            schoolCell.schoolLogoImage.image = UIImage(named: "logo.png")
            
            if let img = imageCache[urlString]
            {
                
                schoolCell.schoolLogoImage.contentMode = UIViewContentMode.ScaleAspectFit
                schoolCell.schoolLogoImage.image = img
            }
            else
            {
                let request : NSURLRequest = NSURLRequest(URL: imagUrl)
                
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,data,error) -> Void in
                    
                    
                    if error == nil
                    {
                        let image = UIImage(data: data!)
                        
                        self.imageCache[urlString] = image
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if   let cellUpdate = tableView.cellForRowAtIndexPath(indexPath) as? SchoolTableViewCell
                            {
                                cellUpdate.schoolLogoImage.image = image
                            }
                        })
                    }
                    else
                    {
                        //("Error: \(error!.localizedDescription)")
                        
                    }
                    
                })
                
                
            }
            
        }

        
        
        return schoolCell
        
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let teacherStudent = storyboard?.instantiateViewControllerWithIdentifier("teacherStudent") as! TeacherStudentViewController
        loginbacktoschoolBool = false
       
        
        let schName = schoolsDetail[indexPath.row].valueForKey("sch_name") as! String
        
        NSUserDefaults.standardUserDefaults().setValue(schName, forKey: "schoolsName")
        
        let schID = schoolsDetail[indexPath.row].valueForKey("sch_id") as! String
        
      
        
       teacherStudent.imageStr = schoolsDetail[indexPath.row].valueForKey("sch_logo") as! String
      
        //(schID)
        
        NSUserDefaults.standardUserDefaults().setValue(schID, forKey: "schID")
        
        self.navigationController?.pushViewController(teacherStudent, animated: true)
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
    
    //MARK:- Search Api
    
    
//    func searchApi()
//    {
//        
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
//            
//            
//            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            spinningIndicator.labelText = "Loading"
//            
//            
//            let post = NSString(format:"search=%@",searchTxtField.text!)
//            
//            //(post)
//            
//            var dataModel = NSData()
//            
//            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            
//            let postLength = String(dataModel.length)
//            
//            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/search.php")
//            
//            let urlRequest = NSMutableURLRequest(URL: url!)
//            
//            urlRequest.HTTPMethod = "POST"
//            urlRequest.HTTPBody = dataModel
//            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
//            
//
//            
//            let session = NSURLSession.sharedSession()
//            
//            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data,response,error -> Void in
//                
//                
//                
//                if (error != nil)
//                {
//                    
//                    
//                    //("\(error?.localizedDescription)")
//                    dispatch_async(dispatch_get_main_queue(),
//                        {
//                            let alert = UIAlertView(title: "Alert", message: "No Data Found", delegate: self, cancelButtonTitle: "OK")
//                            
//                            alert.show()
//                            
//                            spinningIndicator.hide(true)
//                    })
//                }
//                    
//                else
//                {
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
//                            if success
//                            {
//                                
//                                
//                                self.schoolsDetail = jsonResults?.valueForKey("data") as! NSMutableArray
//                                self.schoolTableView.hidden = false
//                                self.schoolTableView.reloadData()
//                                //(self.schoolsDetail)
//                                spinningIndicator.hide(true)
//                                
//                                
//                                
//                            }
//                            else
//                                
//                            {
//                                
//                                let alert = UIAlertView(title: "Alert", message: "No data found", delegate: self, cancelButtonTitle: "OK")
//                                alert.show()
//                                 self.schoolTableView.hidden = true
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
//                        dispatch_async(dispatch_get_main_queue(), {
//                            spinningIndicator.hide(true)
//                        })
//                        
//                        let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: self, cancelButtonTitle: "OK")
//                        
//                        alert.show()
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
//    }

    
}
