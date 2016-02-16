//
//  StudentLessonViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import Social
import MediaPlayer
class StudentLessonViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var socialArray = NSMutableArray()
    var studentLessonListArray = NSMutableArray()
    var profileArray = NSArray()
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var lessonsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getStudentLessonListApi()

        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        
        lessonsTableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        profileImageApi()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
       
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.lessonsTableView.frame.origin.x = 0
            
            
            self.lessonsTableView.userInteractionEnabled = true
        })
        
    }
    
    
    
    //MARK:- TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentLessonListArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let lessons = tableView.dequeueReusableCellWithIdentifier("studentLessonCell", forIndexPath: indexPath) as! StudentLessonTableViewCell
        
        lessons.lessonname.text = ""
        
     
        
        if let lessonname = studentLessonListArray[indexPath.row].valueForKey("les_name")
        {
            lessons.lessonname.text = lessonname as? String
        }
        
       //        autoreleasepool({
//        var replaceUrl = NSString()
//        dispatch_async(dispatch_get_main_queue(),
//            {
//                
//        let vide = self.studentLessonListArray[indexPath.row].valueForKey("video_url")
//        
//        var decodeStr = NSString()
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
//            //print(decodeStr)
//            
//        }
//            
//        catch
//        {
//            
//            //print("Fetch failed: \((error as NSError).localizedDescription)")
//            
//        }
//        
//        if decodeStr.containsString("http")
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
//            //print(url)
//            replaceUrl = url
//            
//        }
//        }
//        
//        else
//        
//        {
//            replaceUrl = "http://youtube.com/embed/edzWTw0Yp"
//        }
//        
//        
//        print(replaceUrl)
//        
//                
//        
//        let width = 290
//        let height = 210
//        let frame  = 0
//
//        
//        let code:NSString = "<iframe width=\(width) height=\(height) src=\(replaceUrl) frameborder=\(frame) allowfullscreen></iframe>"
//        
//        lessons.videoWebView.loadHTMLString(code as String, baseURL: nil)
//           
//        })
//        })
//        NSString *strVideoURL = @"http://www.xyzvideourl.com/samplevideourl";
//        NSURL *videoURL = [NSURL URLWithString:strVideoURL] ;
//        MPMoviePlayerController *player = [[[MPMoviePlayerController alloc] initWithContentURL:videoURL]autorelease];
//        UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//        player = nil;
        
        return lessons
        
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
        
        let storyBoardTeacher = UIStoryboard(name: "Main", bundle: nil)
        
        let lessonDetail = storyBoardTeacher.instantiateViewControllerWithIdentifier("lessonDetail") as! LessonDetailViewController
        lessonDetail.editLessonAndPreviewLessonBool = false
        
        
        
        
        let descDecode  = studentLessonListArray[indexPath.row].valueForKey("les_desc") as! String
        
        
        
        
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
            
            print("Fetch failed: \((error as NSError).localizedDescription)")
            
        }
        
        
        lessonDetail.videoUrlStr = studentLessonListArray[indexPath.row].valueForKey("video_url") as! String
        lessonDetail.indexSaveCell = indexPath.row
        lessonDetail.lessonNameStr = studentLessonListArray[indexPath.row].valueForKey("les_name") as! String
        self.navigationController?.pushViewController(lessonDetail, animated: true)

        
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let shareAction = UITableViewRowAction(style: .Default, title: "Share") { value in
            print("button did tapped!")
            
            let textToShare = "Hi, I am studying a lesson from this Website "
            
            if let myWebsite = NSURL(string: "http://digitallearningtree2.com")
            {
                let objectsToShare = [textToShare, myWebsite]
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList,UIActivityTypeMail,UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard,UIActivityTypeMessage,UIActivityTypePostToFlickr,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll]
                //
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
            
//            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            vc.setInitialText("Hi, I am studying a lesson from this Website")
//            
//            vc.addURL(NSURL(string: "http://digitallearningtree2.com"))
//            self.presentViewController(vc, animated: true, completion: nil)
            
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
                self.lessonsTableView.frame.origin.x = 0
                
                
                self.lessonsTableView.userInteractionEnabled = true
                
            })
            
            
        }
            
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.menuView.frame.origin.x = self.view.frame.origin.x
                self.lessonsTableView.frame.origin.x = self.menuView.frame.size.width
                
                self.lessonsTableView.userInteractionEnabled = false
                
                
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
        
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.menuView.frame.origin.x = -700
            self.lessonsTableView.frame.origin.x = 0
            
            
            self.lessonsTableView.userInteractionEnabled = true
            
        })
        
    }
    
    
    @IBAction func menuClassResorcesBtn(sender: AnyObject)
    {
        let classResourceView = storyboard?.instantiateViewControllerWithIdentifier("StudentclassResourceView") as! StudentClassResourceViewController
        
        self.navigationController?.pushViewController(classResourceView, animated: true)
    
    }
    
    @IBAction func menuQuizBtn(sender: AnyObject)
    {
        let quizView = storyboard?.instantiateViewControllerWithIdentifier("studentQuizView") as! StudentQuizViewController
        
        self.navigationController?.pushViewController(quizView, animated: true)
        
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
        
        
        print(zoomView.frame.height)
        print(zoomView.frame.width)
        
        
        
        
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
        
        print(zoomView.frame.height)
        print(zoomView.frame.width)
        
        
        
    }

    //MARK:- Get Student LesoonList Api
    
    func getStudentLessonListApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
            
        else
            
        {
            
            let classID =  NSUserDefaults.standardUserDefaults().valueForKey("StudentClassID") as! String
            
            
            let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            
            let post = NSString(format:"cid=%@",classID)
            
            print(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/class_students.php")
            
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
                    print("\(error?.localizedDescription)")
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
                                
                               self.studentLessonListArray = jsonResults?.valueForKey("data") as! NSMutableArray
                                
                                self.lessonsTableView.reloadData()
                                
                                NSUserDefaults.standardUserDefaults().setInteger(self.studentLessonListArray.count, forKey: "arrayCountSave")
                                
                                lessonsListArraySwipeProcess =  self.studentLessonListArray


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
            
            print(post)
            
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
                
                print(data)
                
                print(response)
                
                if (error != nil)
                {
                    print("\(error?.localizedDescription)")
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
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
            
            
        }
        
        
    }
    
    
    func profileImageApi()
    {
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
            
        }
            
        else
            
        {
            let userID = NSUserDefaults.standardUserDefaults().valueForKey("StudentUserID") as! String
            
            let Mem_Name = NSUserDefaults.standardUserDefaults().valueForKey("Mem_Name") as! String
            
            
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
                
                print(data)
                
                print(response)
                
                if (error != nil)
                {
                    print("\(error?.localizedDescription)")
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
                                
                                if let imageStr = self.profileArray[0].valueForKey("photo") 
                                {
                                let request : NSURLRequest = NSURLRequest(URL: NSURL(string: imageStr as! String)!)
                                
                                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,data,error) -> Void in
                                    if error == nil
                                    {
                                        let image = UIImage(data: data!)!
                                        dispatch_async(dispatch_get_main_queue(),
                                            {
                                            spinningIndicator.hide(true)
                                            self.profileImage.image = image
                                           
                                        })
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
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                }
            })
            task.resume()
        }
    }
    
    
    
    //MARK:- Image Button
    
    @IBAction func imageBtn(sender: AnyObject)
    {
        let profile = storyboard?.instantiateViewControllerWithIdentifier("profile") as! ProfileViewController
        
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
        profile.imageBackToFront = profileImage.image!
        self.navigationController?.pushViewController(profile, animated: true)
        

    }
    
    

}
