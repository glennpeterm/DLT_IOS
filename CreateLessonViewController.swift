//
//  CreateLessonViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AVFoundation

class CreateLessonViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
     var base64Encoded = NSString()
    var spinningIndicator = MBProgressHUD()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet var videoUrlTxtField: UITextField!
    var alertField = UIAlertView()
  
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var descriptionTxtField: UITextView!
    @IBOutlet var scheduledTxtField: UITextField!
    @IBOutlet var titleTxtField: UITextField!
    
    var lesonData = NSArray()
    
    var lessonIdStr = NSString()
    
    var EditApiBool = Bool()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        alertField.delegate = self
        
        if EditApiBool == true
        {
        
        Senddatabeforeeditlesson()
         
            self.navigationItem.title = "Modify Lesson"
            
        }
        descriptionTxtField.delegate = self
        titleTxtField.delegate = self
        scheduledTxtField.delegate = self
        videoUrlTxtField.delegate = self
        
        descriptionTxtField.layer.borderWidth = 0.5
        descriptionTxtField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        descriptionTxtField.layer.cornerRadius = 3

        saveBtn.layer.borderWidth = 1.5
        saveBtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor
        
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
        
        
        scheduledTxtField.text = "\(year)-\(month)-\(day)"

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    //MARK:- TextField Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    //MARK:- TouchEvent Method
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        titleTxtField.resignFirstResponder()
        descriptionTxtField.resignFirstResponder()
        scheduledTxtField.resignFirstResponder()
        videoUrlTxtField.resignFirstResponder()
    }

    //MARK:- TextView Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView == descriptionTxtField
        {
            UIView.animateWithDuration(0.2, animations: {
                
                
                
                self.view.frame.origin.y -= self.view.frame.height/5
            })
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        if textView.text == "Description"
        {
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView)
    {
        
        if textView == descriptionTxtField
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/5
            })
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        if textView.text == ""
                {
                    textView.text = "Description"
                }
        
        
                if textView.text ==  "Description"
                {
                    textView.textColor = UIColor.lightGrayColor()
                }
        
                else
        
                {
                    textView.textColor = UIColor.blackColor()
                }

    }


    //MARK:- BAck Button
    
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
    
    func validateUrl(candidate: String) -> Bool
    {
        let urlRegEx: String = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))|(-)+"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluateWithObject(candidate)
    }
    //MARK:- Create Lesson Api
    func createLessonApi()
        
    {
        if titleTxtField.text == "" || scheduledTxtField.text == "" || descriptionTxtField.text == ""
        {
            
            let alert = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }
        
        else if !videoUrlTxtField.text!.containsString("http") && videoUrlTxtField.text != ""
        {
            let alert = UIAlertView(title: "Alert", message: "Please enter valid url", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
            
        else
            
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
                
                var post = NSString()
                
                
                if saveBtn.titleLabel?.text == "Update"
                {
                    post = NSString(format:"userid=%@&cid=%@&title=%@&desc=%@&les_date=%@&les_id=%@&video_url=%@",cls_createdby_userID,cla_classid_eid,titleTxtField.text!, descriptionTxtField.text!,scheduledTxtField.text!,lessonIdStr,videoUrlTxtField.text!)
                }
                else
                {
                    post = NSString(format:"userid=%@&cid=%@&title=%@&desc=%@&les_date=%@&video_url=%@",cls_createdby_userID,cla_classid_eid,titleTxtField.text!, descriptionTxtField.text!,scheduledTxtField.text!,videoUrlTxtField.text!)
                }
                print(post)
                
                var dataModel = NSData()
                
                let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                
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
                            print(jsonResults)
                            
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                let success = jsonResults?.valueForKey("success") as! Bool
                                let data = jsonResults?.valueForKey("data") as! String
                                
                                if success
                                {
                                   lessonApiToSaveBool = true
                                    self.navigationController?.popViewControllerAnimated(true)
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
    }
    
//MARK:- Save Button
    
    @IBAction func saveBtn(sender: AnyObject)
    {
//        if videoUrlTxtField.text!.containsString("file:///")
//        {
//            uploadImageApi()
//       }
//        
//        else
//        {
            createLessonApi()
        //}
    }
    
    
    
    //MARK:- Send data before edit lesson 
    
    func Senddatabeforeeditlesson()
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
            
            let post = NSString(format:"userid=%@&les_edit_id=%@",cls_createdby_userID,lessonIdStr)
            
            //(post)
            
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
                                self.saveBtn.setTitle("Update", forState: .Normal)
                                
                                self.lesonData = jsonResults?.valueForKey("data") as! NSArray
                                
                                
                                self.titleTxtField.text = ""
                                
                                if let tit = self.lesonData[0].valueForKey("lesson_name")
                                {
                                     self.titleTxtField.text = tit as? String
                                }
                                
                                self.descriptionTxtField.text = ""
                                
                                if  let desc = self.lesonData[0].valueForKey("desc")
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
                                        
                                        self.descriptionTxtField.text  = decodedString
                                        
                                        if self.descriptionTxtField.text != "Description"
                                        {
                                            self.descriptionTxtField.textColor = UIColor.blackColor()
                                        }
                                        
                                        //(decodeStr)
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }
                                    

                                    //self.descriptionTxtField.text = desc as? String
                                }
                                
                                self.scheduledTxtField.text = ""
                                
                                if  let sch = self.lesonData[0].valueForKey("les_date")
                                {
                                    self.scheduledTxtField.text = sch as? String
                                }
                                
                                self.videoUrlTxtField.text = ""
                                
                                if let urlvide = self.lesonData[0].valueForKey("video_url")
                                {
                                    self.videoUrlTxtField.text = urlvide as? String
                                }
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
                        //("Fetch failed: \((error as NSError).localizedDescription)")
                    }
                    
                    
                    
                }
                
                
            })
            task.resume()
        }

        
        
    }
    
    //MARK:- Preview Button
    
    @IBAction func previewBtn(sender: AnyObject)
    {
        if titleTxtField.text == "" || scheduledTxtField.text == "" || descriptionTxtField.text == "" || videoUrlTxtField.text == ""
        {
            let alert = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else
        {
        let lessonDetail = storyboard?.instantiateViewControllerWithIdentifier("lessonDetail") as! LessonDetailViewController
       
        lessonDetail.editLessonAndPreviewLessonBool = true

        lessonDetail.descriptionLessonStr = descriptionTxtField.text
        lessonDetail.lessonNameStr = titleTxtField.text!

        lessonDetail.videoUrlStr = videoUrlTxtField.text!
        self.navigationController?.pushViewController(lessonDetail, animated: true)
            
        }

    }
    
    //MARK:- Upload Video Button
    
//    @IBAction func uploadVideoBtn(sender: AnyObject)
//    {
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        
//        
//        
//        imagePicker.mediaTypes = [kUTTypeMovie as String]
//        
//        presentViewController(imagePicker, animated: true, completion: nil)
//    }
//    
//    //MARK:- Image Picker Delegate
//    
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
//    {
//        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
//        
//        if let type:AnyObject = mediaType
//        {
//            if type is String
//            {
//                let stringType = type as! String
//                if stringType == kUTTypeMovie as String
//                {
//                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
//                    if let url = urlOfVideo
//                    {
//                        videoUrlTxtField.text = String(url)
//                        let dovf = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] 
//                        let filepath = dovf.URLByAppendingPathComponent("temp.mov")
//                     
//                        let filemanager =  NSFileManager.defaultManager()
//                        do
//                        {
//                           try filemanager.removeItemAtURL(filepath)
//                            
//                            //print(filemanager)
//                            let asset: AVURLAsset = AVURLAsset(URL: url, options: nil)
//                            let exportSession: AVAssetExportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)!
//                            exportSession.outputURL = filepath
//                            exportSession.shouldOptimizeForNetworkUse = true
//                            exportSession.outputFileType = AVFileTypeQuickTimeMovie
//                            exportSession.exportAsynchronouslyWithCompletionHandler({() -> Void in
//                                
//                                if exportSession.status == AVAssetExportSessionStatus.Completed
//                                {
//                                    let data = NSData(contentsOfURL: filepath)
//                                    print(data!)
//                                    self.base64Encoded = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//                                    print(self.base64Encoded)
//                                }
//                            })
//                        }
//                        catch
//                        {
//                             //print("Fetch failed: \((error as NSError).localizedDescription)")
//                            let asset: AVURLAsset = AVURLAsset(URL: url, options: nil)
//                            let exportSession: AVAssetExportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetLowQuality)!
//                            exportSession.outputURL = filepath
//                            exportSession.shouldOptimizeForNetworkUse = true
//                            exportSession.outputFileType = AVFileTypeQuickTimeMovie
//                            exportSession.exportAsynchronouslyWithCompletionHandler({() -> Void in
//                                
//                                if exportSession.status == AVAssetExportSessionStatus.Completed
//                                {
//                                    let data = NSData(contentsOfURL: filepath)
//                                    print(data!)
//                                    self.base64Encoded = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//                                    print(self.base64Encoded)
//                                }
//                            })
//
//                            
//                        }
//                    }
//                }
//            }
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    func imagePickerControllerDidCancel(picker: UIImagePickerController)
//    {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    func uploadImageApi()
//    {
//    
//    
//    
//        if Reachability.isConnectedToNetwork() == false
//        {
//            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
//    
//            alert.show()
//
//    
//        }
//        else
//    
//        {
//            spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            spinningIndicator.labelText = "Loading"
//    
//            let url = NSURL(string: videoUrlTxtField.text!)
//            videoData = NSData(contentsOfURL: url!)!
//            createMultipart(videoData, callback: { success in
//                if success
//                {
//                    //("success")
//                    self.spinningIndicator.hide(true)
//                }
//                else
//                {
//                    //("fail")
//                    self.spinningIndicator.hide(true)
//                }
//              })
//    
//    
//        }
//    
//    }
//
//
//    func createMultipart(image: NSData, callback: Bool -> Void)
//    {
//    
//    
//        let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
//        let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
//    
//    
//    
//        let param = [
//            "cid" : cla_classid_eid,
//            "userid" : cls_createdby_userID,
//    "title" : titleTxtField.text!,
//            "desc" : descriptionTxtField.text!,
//            "les_date" : scheduledTxtField.text!,
//            "video_url" : videoUrlTxtField.text!
//    
//        ]
//        print(param)
//    
//        Alamofire.upload(
//            .POST,
//            "http://digitallearningtree.com/digitalapi/teach_lesson.php",
//            multipartFormData: { multipartFormData in
//    
//                //let imageData = UIImagePNGRepresentation(image)
//                print(image)
//                multipartFormData.appendBodyPart(data: image, name: "local_data", fileName: "iosFile.MOV", mimeType: "local_data/*")
//    
//                for (key, value) in param
//                {
//                    multipartFormData.appendBodyPart(data:"\(value)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :key)
//                }
//
//            },
//    
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                       self.navigationController?.popViewControllerAnimated(true)
//                    self.spinningIndicator.hide(true)
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
//                     self.spinningIndicator.hide(true)
//                }
//            }
//       )
//    
//    
//    }

 
}
