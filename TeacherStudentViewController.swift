//
//  TeacherStudentViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/18/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class TeacherStudentViewController: UIViewController
{

    
    
    @IBOutlet var logoImageView: UIImageView!
   
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var loaderView: UIView!
    
    @IBOutlet var schoolName: UILabel!
    
    var imageStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //(imageStr)
        
        schoolName.text = NSUserDefaults.standardUserDefaults().valueForKey("schoolsName") as? String
        
        
        if imageStr != ""
        {
            let request : NSURLRequest = NSURLRequest(URL: NSURL(string: imageStr)!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,data,error) -> Void in
                if error == nil
                {
                    let image = UIImage(data: data!)!
                    dispatch_async(dispatch_get_main_queue(),{
                        self.logoImageView.image = image
                        self.loaderView.hidden = true
                    })
                }
                else
                {
                    self.loaderView.hidden = true
                    //("Error: \(error!.localizedDescription)")
                }
            })

        }
        else
        {
            self.loaderView.hidden = true
            self.logoImageView.image = UIImage(named: "logo.png")!
        }
    }
    
    
    func searchTapped(sender:UIButton) {
        //("search pressed")
    }
   
    func addTapped (sender:UIButton) {
        //("add pressed")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    //MARK:- Teacher Login
    
    
    @IBAction func teacherLogin(sender: AnyObject)
    {
        let teacherLogin = storyboard?.instantiateViewControllerWithIdentifier("teacherLogin") as! LoginViewController
        
        teacherLogin.StudentAndTeacherLoginBool = true
        
        
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(logoImageView.image!), forKey: "image")
        
        self.navigationController?.pushViewController(teacherLogin, animated: true)
        
    }
    
    //MARK:- Student Login
    
    
    @IBAction func studentLogin(sender: AnyObject)
    {
        
        let teacherLogin = storyboard?.instantiateViewControllerWithIdentifier("teacherLogin") as! LoginViewController
        teacherLogin.StudentAndTeacherLoginBool = false
         NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(logoImageView.image!), forKey: "image")
        self.navigationController?.pushViewController(teacherLogin, animated: true)
    }
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:- Zoom In Zoom Out
    @IBAction func zoomIn(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, animations:
            {
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
}
