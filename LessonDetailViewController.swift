//
//  LessonDetailViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/13/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
//import YoutubeSourceParserKit

 
var lessonsListArraySwipeProcess = NSArray()

class LessonDetailViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    
   var moviePlayer = MPMoviePlayerViewController()
    @IBOutlet var lessonCountView: UIView!
    @IBOutlet var rightArrow: UIImageView!
    @IBOutlet var leftArrow: UIImageView!
 
    var currentTable: Int = 0
    
    @IBOutlet var lessonCountLbl: UILabel!
    var replaceUrl = NSString()
   var indexSaveCell = Int()
    @IBOutlet var swipeScrollView: UIScrollView!
   var editLessonAndPreviewLessonBool = Bool()
    var descriptionLessonStr = NSString()
    var videoUrlStr = NSString()
    
    var lessonNameStr = NSString()
  
   
    var quizarray = NSArray()
    
    var tableViews: [UITableView] = []
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
      override func viewDidLoad()
    {
        
        super.viewDidLoad()
        lessonCountLbl.layer.borderColor = UIColor(red: 122/255, green: 174/255, blue: 48/255, alpha: 1.0).CGColor
        swipeScrollView.delegate = self
        if editLessonAndPreviewLessonBool == true
        {
            lessonCountView.hidden = true
            let webView2 = UIWebView()
            
            let descriptionTextView = UITextView()
        
            webView2.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.7)
            
            descriptionTextView.frame = CGRectMake(0, webView2.frame.origin.y + webView2.frame.height + 10, self.view.frame.size.width,self.view.frame.size.height/2 - 20)
            
            descriptionTextView.font = UIFont(name: "Arial", size: 18)
            descriptionTextView.editable = false
            descriptionTextView.selectable = false
            
            webView2.userInteractionEnabled = false
            
        
            descriptionTextView.text = descriptionLessonStr as String
            
            
            
            var decodeStr = NSString()
            
            let encodedData = videoUrlStr.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            
            do
            {
                
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                
                
                let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                
                decodeStr  = decodedString
                
            }
                
            catch
            {
                
                ////("Fetch failed: \((error as NSError).localizedDescription)")
                
            }
            if decodeStr.containsString("http")
            {
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
            
            else
            {
                replaceUrl = "http://youtube.com/embed/edzWTw0Yp"
            }
            let width = self.view.frame.size.width-15
            let height = (self.view.frame.size.height/2.7)
            let frame  = 0
            let code:NSString = "<iframe width=\(width) height=\(height) src=\(replaceUrl) frameborder=\(frame) allowfullscreen></iframe>"
            webView2.loadHTMLString(code as String, baseURL: nil)
            swipeScrollView.addSubview(webView2)
            swipeScrollView.addSubview(descriptionTextView)
        }
        if editLessonAndPreviewLessonBool == false
        {
        let arrayCountSave = NSUserDefaults.standardUserDefaults().integerForKey("arrayCountSave")
        self.swipeScrollView.contentSize.width = CGFloat(arrayCountSave) * self.swipeScrollView.frame.width
        self.swipeScrollView.pagingEnabled = true
            for var i = 0 ; i < arrayCountSave ; i++
            {

                
                let image = UIButton()
                image.tag = i
                image.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.7)
                image.addTarget(self, action: "imageBtn:", forControlEvents:UIControlEvents.TouchUpInside)
                image.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                let imageStr = lessonsListArraySwipeProcess[i].valueForKey("video_thumb") as! String
                
                if imageStr != ""
                {
                let request : NSURLRequest = NSURLRequest(URL: NSURL(string: imageStr )!)
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,data,error) -> Void in
                    if error == nil
                    {
                        let image1 = UIImage(data: data!)!
                        dispatch_async(dispatch_get_main_queue(),{
                            image.setImage(image1, forState: UIControlState.Normal)
                        })
                    }
                    else
                    {
                        print("Error: \(error!.localizedDescription)")
                    }
                })

                }
                
              else
                {
                    image.setImage(UIImage(named: "defaultThumbnail_overlay.png"), forState: UIControlState.Normal)
                }
                

                
                let descriptionTextView = UITextView()
                descriptionTextView.frame = CGRectMake(0, image.frame.origin.y + image.frame.height + 10, self.view.frame.size.width,self.view.frame.size.height/2 - 20)
                descriptionTextView.font = UIFont(name: "Arial", size: 18)
                descriptionTextView.editable = false
                descriptionTextView.selectable = false
                
                if let desc = lessonsListArraySwipeProcess[i].valueForKey("desc")
                {
                    let encodedData = desc.dataUsingEncoding(NSUTF8StringEncoding)!
                    
                    let attributedOptions : [String: AnyObject] =
                    [
                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                    ]
                    
                    do
                    {
                        
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        
                        
                        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                        
                         descriptionTextView.text  = decodedString
                        
                        //(decodeStr)
                        
                    }
                        
                    catch
                    {
                        
                        print("Fetch failed: \((error as NSError).localizedDescription)")
                        
                    }

                // descriptionTextView.text = desc as? String
        
                }
           
                let contentSize = descriptionTextView.sizeThatFits(descriptionTextView.bounds.size)
                var frame1 = descriptionTextView.frame
                frame1.size.height = contentSize.height + 20
                descriptionTextView.frame = frame1
               
                let tableview = UITableView()
                
                tableview.tag = i
                currentTable = i
                
                tableview.frame = CGRectMake(0, descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height + 20, self.view.frame.size.width, 170)
                
                tableview.dataSource = self
                tableview.delegate = self
                
                tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
                tableview.tableFooterView = UIView(frame: CGRectZero)
                tableview.bounces = false
                tableViews.append(tableview)

                let view = UIScrollView()
                view.frame = CGRectMake(CGFloat(i)*swipeScrollView.frame.width, 0, swipeScrollView.frame.width, swipeScrollView.frame.height)
               // view.addSubview(imageBtn)
                view.addSubview(image)
                view.addSubview(descriptionTextView)
                view.bounces = false
                view.addSubview(tableview)
                view.contentSize.height = tableview.frame.origin.y + tableview.frame.size.height + 100
                swipeScrollView.addSubview(view)
            }
            
            quizarray = lessonsListArraySwipeProcess[0].valueForKey("quiz_data") as! NSArray
            tableViews[0].reloadData()
            //(quizarray)
            
            swipeScrollView.contentOffset.x = CGFloat(indexSaveCell) * swipeScrollView.frame.width
            
            let strIndex = String(indexSaveCell + 1)
            
            
             lessonCountLbl.text = "Lesson \(strIndex) of \(arrayCountSave)"
        
            if strIndex == "1"
            {
                leftArrow.hidden = true
            }
            else
            {
                leftArrow.hidden = false
            }
        }
        
        self.navigationItem.title = lessonNameStr as String
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView == swipeScrollView
        {
            let arrayCountSave = NSUserDefaults.standardUserDefaults().integerForKey("arrayCountSave")
            let pageNo = Int(swipeScrollView.contentOffset.x/swipeScrollView.frame.width) + 1
            lessonCountLbl.text = "Lesson \(pageNo) of \(arrayCountSave)"
            
            if pageNo == 1
            {
                leftArrow.hidden = true
            }
            else
            {
                leftArrow.hidden = false
            }
              if pageNo == arrayCountSave
            {
                rightArrow.hidden = true
            }
            else
            {
                rightArrow.hidden = false
            }
            if let lsname =  lessonsListArraySwipeProcess[Int(swipeScrollView.contentOffset.x / swipeScrollView.frame.width)].valueForKey("lesson_name") as? String
            {
                self.title =  lsname
            }
            
            if let lsname1 =  lessonsListArraySwipeProcess[Int(swipeScrollView.contentOffset.x / swipeScrollView.frame.width)].valueForKey("les_name") as? String
            {
                self.title =  lsname1
            }
            quizarray = lessonsListArraySwipeProcess[Int(swipeScrollView.contentOffset.x / swipeScrollView.frame.width)].valueForKey("quiz_data") as! NSArray
            tableViews[Int(swipeScrollView.contentOffset.x / swipeScrollView.frame.width)].reloadData()
        }
    }

    func imageBtn(sender:UIButton!)
    {

        let vide = lessonsListArraySwipeProcess[sender.tag].valueForKey("video_url") as! String
        if vide.containsString("http")
        {
        var url : NSURL!
        url = NSURL(string:vide)!
        let video = vide 
        let VideoID = video.stringByReplacingOccurrencesOfString("http://youtu.be/", withString: "")
        let url1 = NSURL(string:"YouTube://\(VideoID)")!
        if UIApplication.sharedApplication().canOpenURL(url1)
        {
            UIApplication.sharedApplication().openURL(url1)
        } else
        {
            UIApplication.sharedApplication().openURL(url)
        }
        }
        else
        {
            let alert = UIAlertView(title: "Alert", message: "Video not uploaded or supported", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }

    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- TableView Delegate
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return quizarray.count
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
            //(quizarray.count)
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
            cell.textLabel?.font = UIFont(name: "Arial", size: 18)
        
        
            cell.textLabel?.text = quizarray[indexPath.row].valueForKey("quiz_name") as? String
            return cell
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


  //MARK:- Back Button

    @IBAction func backBtn(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
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
        
        
        ////(zoomView.frame.height)
        ////(zoomView.frame.width)
        
        
        
        
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
        
        ////(zoomView.frame.height)
        ////(zoomView.frame.width)
        
        
        
    }

}
