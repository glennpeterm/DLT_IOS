//
//  StudentDetailViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 12/11/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class StudentDetailViewController: UIViewController
{
    @IBOutlet var profileImage: UIImageView!
    var memID = NSString()
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var passwordLbl: UILabel!
    @IBOutlet var userIdLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 75
        profileImage.clipsToBounds = true
        studentDetailList()
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

    //MARK:- Back Button
    
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- StudentDetail List
    
    func studentDetailList()
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
            
            let post = NSString(format:"member_id=%@",memID)
            
            print(post)
            
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
                        print(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            
                            if success
                            {
                                let studentDetailArray = jsonResults?.valueForKey("data") as! NSArray
                                
                                
                                self.nameLbl.text = ""
                                
                                if let name = studentDetailArray[0].valueForKey("name")
                                {
                                    self.nameLbl.text = name as? String
                                }
                                
                                self.emailLbl.text = ""
                                
                                if let email = studentDetailArray[0].valueForKey("email")
                                {
                                    self.emailLbl.text = email as? String
                                }
                                
                                self.userIdLbl.text = ""
                                
                                if let userid = studentDetailArray[0].valueForKey("userid")
                                {
                                    self.userIdLbl.text = userid as? String
                                }
                                
                                self.passwordLbl.text = ""
                                
                                if let pwd = studentDetailArray[0].valueForKey("password")
                                {
                                    self.passwordLbl.text = pwd as? String
                                }
                                
                                
                                self.statusLbl.text = ""
                                
                                if let status = studentDetailArray[0].valueForKey("mem_online")
                                {
                                    if status as! String  == "0"
                                    {
                                        self.statusLbl.text = "Offline"
                                    }
                                    
                                    if status as! String  == "1"
                                    {
                                        self.statusLbl.text = "Online"
                                    }
                                }
                                
                                let imageStr = studentDetailArray[0].valueForKey("photo") as! String
                                
                                if imageStr != ""
                                {
                                    let request : NSURLRequest = NSURLRequest(URL: NSURL(string: imageStr)!)
                                    
                                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,data,error) -> Void in
                                        if error == nil
                                        {
                                            let image = UIImage(data: data!)!
                                            dispatch_async(dispatch_get_main_queue(),{
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
