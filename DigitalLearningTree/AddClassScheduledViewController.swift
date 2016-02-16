//
//  AddClassScheduledViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/7/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

var scheduleDayStr = NSString()
var scheduleDescriptionStr = NSString()
var ScheduleDataShowSelectDayBool = Bool()
var ScheduleDataShowDescriptionBool = Bool()

class AddClassScheduledViewController: UIViewController,UITextFieldDelegate
{
     var dayCount = NSString()

    var startTimeDatePicker = UIDatePicker()
    var endTimeDatePicker = UIDatePicker()
    
    
    var didSelectBool = Bool()
    
   
    @IBOutlet var saveBtn: UIButton!
    var scheduleDataArray = NSArray()
    var timeId = NSString()
    
    var startHourStrng = NSString()
    
    var startMinStr = NSString()
    var endHourStr = NSString()
    var endMinStr = NSString()
    
   
    
    @IBOutlet var locationTxtField: UITextField!
    
    @IBOutlet var toTxtField: UITextField!
   
    @IBOutlet var fromTxtField: UITextField!
    
    @IBOutlet var descriptionOption: UILabel!
    @IBOutlet var selectDayOption: UILabel!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
   
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ScheduleDataShowSelectDayBool = true
        ScheduleDataShowDescriptionBool = true
        
        if didSelectBool == true
        
        {
            
        
        showScheduleData()
        }
        locationTxtField.delegate = self
        
        self.navigationController?.navigationBarHidden = false
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if ScheduleDataShowSelectDayBool == false
        
        {
        
        if scheduleDayBool == true
        {
            selectDayOption.text = scheduleDayStr as String
        }
        
        else
        
        {
            selectDayOption.text = ""
        }
        
        }
        
        if ScheduleDataShowDescriptionBool == false
        {
        if scheduleDescriptionBool == true
        {
            descriptionOption.text = scheduleDescriptionStr as String
        }
        
        else
        
        {
            descriptionOption.text = ""
        }
            
        }
    }

    
    //MARK:- TextField Action
    
    
    @IBAction func fromTxtfield(sender: UITextField)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.frame.size.height = datePickerView.frame.size.height - 30
        
         datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = 5
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChangedFrom:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func toTxtField(sender: UITextField)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.frame.size.height = datePickerView.frame.size.height - 30
        datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = 5
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChangedTo:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //MARK:- DatePicker Action
    
    func datePickerValueChangedFrom(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        startTimeDatePicker = sender
        
        
        fromTxtField.text = dateFormatter.stringFromDate(sender.date)
        
        let date = sender.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
        
       
        
        startHourStrng = String(components.hour)
        
        startMinStr = String(components.minute)
        
        //(startHourStrng)
        //(startMinStr)
        
        
    }
   
    func datePickerValueChangedTo(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        toTxtField.text = dateFormatter.stringFromDate(sender.date)
        
        let date = sender.date
        endTimeDatePicker = sender
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
        
        endHourStr = String(components.hour)
        
        endMinStr = String(components.minute)
        
        
        
        //(endHourStr)
        //(endMinStr)
        
    }
    
    
    //MARK:- TextField Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        
       if textField == locationTxtField
       {
        
            UIView.animateWithDuration(0.2, animations: {
                
                
                
                self.view.frame.origin.y -= self.view.frame.height/5
            })
        
        
       }
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == locationTxtField
        {
        
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y += self.view.frame.height/5
            })
            
        
        }
            
        else
        {
            self.view.frame.origin.y = self.view.frame.origin.y
        }
        
        
    }


   
    //MARK:- Back Button

    @IBAction func backBtn(sender: AnyObject)
    
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Description Button
    
    @IBAction func descriptionBtn(sender: AnyObject)
    {
        let scheduleDescription = storyboard?.instantiateViewControllerWithIdentifier("scheduleDescription") as! ScheduleDescriptionViewController
        scheduleDescription.showScheduleDiscriptionStr = descriptionOption.text!
        self.navigationController?.pushViewController(scheduleDescription, animated: true)
        
    }
    
    
    
    //MARK:- TouchEvent Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        locationTxtField.resignFirstResponder()
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

    // MARK:- Add Schedule Api
    
    
    func addScheduleApi()
    {
        let dateFormatTest = NSDateFormatter()
        
        dateFormatTest.dateFormat = "hh:mm a"
        //(fromTxtField.text)
        
      //  startTimeDatePicker.date = dateFormatTest.dateFromString(fromTxtField.text!)!
        
        if let dat = dateFormatTest.dateFromString(fromTxtField.text!)
        {
            startTimeDatePicker.date = dat
        }
        
       // endTimeDatePicker.date = dateFormatTest.dateFromString(toTxtField.text!)!
        
        if let dat1 = dateFormatTest.dateFromString(toTxtField.text!)
        {
            endTimeDatePicker.date = dat1
        }

        
        if selectDayOption.text == "" || fromTxtField.text == "" || toTxtField.text == ""
        {
            let alertFillRequired = UIAlertView(title: "Alert", message: "Please fill required Fields", delegate: self, cancelButtonTitle: "OK")
            alertFillRequired.show()
            
        }
            
            
            
            
        else if dateFormatTest.stringFromDate(startTimeDatePicker.date) >= dateFormatTest.stringFromDate(endTimeDatePicker.date)
        {
            let alert = UIAlertView(title: "Alert", message: "Please check your end time.", delegate: self, cancelButtonTitle: "OK")
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
               
               
                
                if selectDayOption.text == "Monday"
                {
                    dayCount = "1"
                }
                
                if selectDayOption.text == "Tuesday"
                {
                    dayCount = "2"
                }
                
                if selectDayOption.text == "Wednesday"
                {
                    dayCount = "3"
                }
                
                if selectDayOption.text == "Thursday"
                {
                    dayCount = "4"
                }
                
                if selectDayOption.text == "Friday"
                {
                    dayCount = "5"
                }
                
                if selectDayOption.text == "Saturday"
                {
                    dayCount = "6"
                }
                
                if selectDayOption.text == "Sunday"
                {
                    dayCount = "7"
                }
                
                if selectDayOption.text == "Every Day"
                {
                    dayCount = "8"
                }
                
                if selectDayOption.text == "Every Weekday"
                {
                    dayCount = "9"
                }
                
                
                
                
                
                
                
                //(startHourStrng)
                
                let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
                let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String
                
                let spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                spinningIndicator.labelText = "Loading"
                 var dataModel = NSData()
                var post = NSString()
                
                if saveBtn.titleLabel?.text == "Update"
                {
                    post = NSString(format:"cid=%@&userid=%@&day=%@&str_hour=%@&str_min=%@&end_hour=%@&en_min=%@&location=%@&desc=%@&timeid=%@",cla_classid_eid,cls_createdby_userID,dayCount,startHourStrng,startMinStr,endHourStr,endMinStr,locationTxtField.text!,descriptionOption.text!,timeId)
                    let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                }
                
                else
                
                {
                 post = NSString(format:"cid=%@&userid=%@&day=%@&str_hour=%@&str_min=%@&end_hour=%@&en_min=%@&location=%@&desc=%@",cla_classid_eid,cls_createdby_userID,dayCount,startHourStrng,startMinStr,endHourStr,endMinStr,locationTxtField.text!,descriptionOption.text!)
                    let post1 = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    dataModel = post1.dataUsingEncoding(NSASCIIStringEncoding)!

                }
                
                //(post)
                
               
                
                //dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength = String(dataModel.length)
                
                let url = NSURL(string:"http://digitallearningtree.com/digitalapi/cls_time.php")
                
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
                            //(jsonResults)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                
                                
                                
                                let success = jsonResults?.valueForKey("success") as! Bool
                                let message = jsonResults?.valueForKey("data") as? String
                                
                                if success
                                {
                                    scheduleListApiBool = true
                                    
                                    self.navigationController?.popViewControllerAnimated(true)
                                    
                                    spinningIndicator.hide(true)
                                    
                                    
                                    
                                }
                                else
                                    
                                {
                                    let alert = UIAlertView(title: "Alert", message: message, delegate: self, cancelButtonTitle: "OK")
                                    
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
    
    //MARK:- Save Button
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        addScheduleApi()
    }

    
    //MARK:- Show Schedule data
    
    func showScheduleData()
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
            
            let post = NSString(format:"cid=%@&userid=%@&timeid=%@&",cla_classid_eid,cls_createdby_userID,timeId)
            
            
            
            //(post)
            
            var dataModel = NSData()
            
            dataModel = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength = String(dataModel.length)
            
            let url = NSURL(string:"http://digitallearningtree.com/digitalapi/before_edit_time.php")
            
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
                        //(jsonResults)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            
                            
                            
                            let success = jsonResults?.valueForKey("success") as! Bool
                            
                            
                            if success
                            {
                                
                              self.scheduleDataArray = jsonResults?.valueForKey("data") as! NSArray
                                
                            
                                spinningIndicator.hide(true)
                                
                                
                                self.descriptionOption.text = ""
                                
                                if let desc = self.scheduleDataArray[0].valueForKey("Description")
                                {
                                   // self.descriptionOption.text = desc as? String
                                    
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
                                        
                                        self.descriptionOption.text  = decodedString
                                        
                                        //(decodeStr)
                                        
                                    }
                                        
                                    catch
                                    {
                                        
                                        print("Fetch failed: \((error as NSError).localizedDescription)")
                                        
                                    }

                                }
                                
                                self.locationTxtField.text = ""
                                
                                if let location = self.scheduleDataArray[0].valueForKey("Cls_Location")
                                {
                                    self.locationTxtField.text = location as? String
                                }
                                
                                self.selectDayOption.text = ""
                                
                                if  let day = self.scheduleDataArray[0].valueForKey("day")
                                {
                                    self.dayCount = day as! NSString
                                    
                                    if self.dayCount as String == "1"
                                    {
                                        self.selectDayOption.text = "Monday"
                                    }
                                    
                                    if self.dayCount as String == "2"
                                    {
                                        self.selectDayOption.text = "Tuesday"
                                    }
                                    
                                    if self.dayCount as String == "3"
                                    {
                                        self.selectDayOption.text = "Wednesday"
                                    }
                                    
                                    if self.dayCount as String == "4"
                                    {
                                        self.selectDayOption.text = "Thursday"
                                    }
                                    
                                    if self.dayCount as String == "5"
                                    {
                                        self.selectDayOption.text = "Friday"
                                    }
                                    
                                    if self.dayCount as String == "6"
                                    {
                                       self.selectDayOption.text = "Saturday"
                                    }
                                    
                                    if self.dayCount as String == "7"
                                    {
                                        self.selectDayOption.text = "Sunday"
                                    }
                                    
                                    if self.dayCount as String == "8"
                                    {
                                        self.selectDayOption.text = "Every Day"
                                    }
                                    
                                    if self.dayCount as String == "9"
                                    {
                                       self.selectDayOption.text = "Every Weekday"
                                    }
                                }
                                
                                
                                
                                
                                if let sthour = self.scheduleDataArray[0].valueForKey("Str_Hour")
                                {
                                    self.startHourStrng = sthour as! NSString
                                    
                                    
                                }
                                
                                
                                
                                if let stMin = self.scheduleDataArray[0].valueForKey("Str_Min")
                                {
                                    self.startMinStr = stMin as! NSString
                                    
                                    
                                }
                                
                                
                                let CombineHourMin = "\(self.startHourStrng):\(self.startMinStr)"
                                
                                //(CombineHourMin)

                                let dateString = CombineHourMin
                                let df = NSDateFormatter()
                                df.dateFormat = "HH:mm"
                                if let date = df.dateFromString(dateString) {
                                    // now you have your date object
                                    // to display UTC time you have to specify timeZOne UTC
                                    
                                    df.dateFormat = "h:mm a"
                                    self.fromTxtField.text = df.stringFromDate(date)
                                      // "Monday, August 31, 2015 9:36:00 PM"
                                }
                                
                                
                                
                                
                                if let enhour = self.scheduleDataArray[0].valueForKey("En_Hour")
                                {
                                    self.endHourStr = enhour as! NSString
                                    
                                    
                                }
                                
                                
                                
                                if let enMin = self.scheduleDataArray[0].valueForKey("En_Min")
                                {
                                    self.endMinStr = enMin as! NSString
                                    
                                    
                                }
                                
                                
                                let endCombineHourMin = "\(self.endHourStr):\(self.endMinStr)"
                                
                                //(endCombineHourMin)
                                
                                let enddateString = endCombineHourMin
                                let enddf = NSDateFormatter()
                                enddf.dateFormat = "HH:mm"
                                if let date = enddf.dateFromString(enddateString) {
                                    // now you have your date object
                                    // to display UTC time you have to specify timeZOne UTC
                                    
                                    enddf.dateFormat = "h:mm a"
                                    self.toTxtField.text = enddf.stringFromDate(date)
                                    // "Monday, August 31, 2015 9:36:00 PM"
                                }
                                

                                
                                self.saveBtn.setTitle("Update", forState: .Normal)
                                
                                
                                
                                
                                
                            }
                            else
                                
                            {
                                
                                let message = jsonResults?.valueForKey("data") as? String
                                
                                let alert = UIAlertView(title: "Alert", message: message, delegate: self, cancelButtonTitle: "OK")
                                
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
