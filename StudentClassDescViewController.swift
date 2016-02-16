//
//  StudentClassDescViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 1/19/16.
//  Copyright © 2016 mrinal khullar. All rights reserved.
//

import UIKit

class StudentClassDescViewController: UIViewController {

    @IBOutlet var descScrollview: UIScrollView!
    @IBOutlet var profileDesc: UITextView!
    var Cla_Id = NSString()
    @IBOutlet var wechatTxt: UILabel!
    @IBOutlet var whatsappTxt: UILabel!
    @IBOutlet var numberTxt: UILabel!
    @IBOutlet var nameTxt: UILabel!
    @IBOutlet var emailTxt: UILabel!
    @IBOutlet var profileImage: UIImageView!
    var classDesc = NSString()
    @IBOutlet var descView: UITextView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileTeacherData()
        profileImage.layer.cornerRadius = 75
        profileImage.clipsToBounds = true
        
        descView.layer.borderWidth = 1
        descView.layer.borderColor = UIColor.lightGrayColor().CGColor
        descView.layer.cornerRadius = 5
        
        profileDesc.layer.borderWidth = 1
        profileDesc.layer.borderColor = UIColor.lightGrayColor().CGColor
        profileDesc.layer.cornerRadius = 5

        

        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK:- GetTeacherProfileData
    
    
    func getProfileTeacherData()
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
        
            
            let post = NSString(format:"classid=%@",Cla_Id)
            
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
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                
                                
                                let success = jsonResults?.valueForKey("success") as! Bool
                                
                                if success
                                {
                                    var firstName = String()
                                    var lastName = String()
                                    let profileData = jsonResults?.valueForKey("data") as! NSMutableArray
                                    
                                    if let email = profileData[0].valueForKey("email") as? String
                                    {
                                        self.emailTxt.text = email
                                    }
                                    
                                    
                                    if let number = profileData[0].valueForKey("phonenumber") as? String
                                    {
                                        self.numberTxt.text = number
                                    }
                                    
                                    if let first = profileData[0].valueForKey("firstname") as? String
                                    {
                                        firstName = first
                                    }
                                    if let last = profileData[0].valueForKey("lastName") as? String
                                    {
                                        lastName = last
                                    }
                                    
                                    
                                    self.nameTxt.text = "\(firstName) \(lastName)"

                                    if let social = profileData[0].valueForKey("social") as? NSMutableArray
                                    {
                                        let socialID = social
                                        
                                        if let whatsapp = socialID[0].valueForKey("whatsapp") as? String
                                        {
                                            self.whatsappTxt.text = whatsapp
                                        }
                                        
                                        if let wechat = socialID[0].valueForKey("wechat") as? String
                                        {
                                            self.wechatTxt.text = wechat
                                        }
                                        
                                        
                                    }
                                    
                                    let imageStr = profileData[0].valueForKey("photo") as! String
                                    
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
                                    
                                    
                                    
                                    let encodedData = self.classDesc.dataUsingEncoding(NSUTF8StringEncoding)!
                                    
                                    let attributedOptions : [String: AnyObject] =
                                    [
                                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                                    ]
                                    do
                                    {
                                        
                                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                                        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                                        self.descView.text  = decodedString
                                        self.descView.font = UIFont(name: "Arial", size: 18)
                                    }
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }
                                    
                                    let contentSize = self.descView.sizeThatFits(self.descView.bounds.size)
                                    var frame1 = self.descView.frame
                                    frame1.size.height = contentSize.height + 10
                                    self.descView.frame = frame1

                                    self.profileDesc.text = "No Profile Description"
                                    if let proDesc = profileData[0].valueForKey("description") as? String
                                    {
                                        let encodedData = proDesc.dataUsingEncoding(NSUTF8StringEncoding)!
                                        
                                        let attributedOptions : [String: AnyObject] =
                                        [
                                            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                                        ]
                                        do
                                        {
                                            
                                            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                                            let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                                            self.profileDesc.text  = decodedString
                                            
                                        }
                                        catch
                                        {
                                            print("Fetch failed: \((error as NSError).localizedDescription)")
                                        }

                                    }
                                    
                                    self.profileDesc.font = UIFont(name: "Arial", size: 18)
                                    
                                    
                                    let contentSize1 = self.profileDesc.sizeThatFits(self.profileDesc.bounds.size)
                                    var frame = self.profileDesc.frame
                                    frame.size.height = contentSize1.height + 10
                                    self.profileDesc.frame = frame
                                    
                                    self.descScrollview.contentSize.height = self.descView.frame.origin.y + self.descView.frame.size.height+10
                                    
                                    
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
