//
//  ProfileViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 1/12/16.
//  Copyright © 2016 mrinal khullar. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
class ProfileViewController: UIViewController,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate
{
    
    @IBOutlet var wechatTxtfield: UITextField!
    
    @IBOutlet var firstNameView: UIView!
    @IBOutlet var lastnameView: UIView!
    @IBOutlet var wechatView: UIView!
    @IBOutlet var whatsupView: UIView!
    @IBOutlet var whatsupTxtField: UITextField!
   
    var imageBackToFront = UIImage()
    
    var teacherStudentBool = Bool()
     var imagePickerTakePhoto = UIImagePickerController()
     var spinningIndicator = MBProgressHUD()
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    
    @IBOutlet var emailTxtField: UITextField!
    
    @IBOutlet var firstNameTxtField: UITextField!
    
    @IBOutlet var descTxtView: UITextView!
    @IBOutlet var lastNameTxtField: UITextField!
    @IBOutlet var phoneTxtField: UITextField!
    
    @IBOutlet var profileImage: UIImageView!
    var emailStr = String()
    var phoneNoStr = String()
    var firstNameStr = String()
    var lastNameStr = String()
    var descStr = String()
    var whatsupstr = String()
    var wechatStr = String()
    var socialidStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descTxtView.delegate = self
        IQKeyboardManager.sharedManager().enable = true
       
        imagePickerTakePhoto.delegate = self
        scrollView.contentSize.height = updateBtn.frame.origin.y + updateBtn.frame.size.height + 10
        profileImage.image = imageBackToFront
        
        emailTxtField.text = emailStr
        phoneTxtField.text = phoneNoStr
        firstNameTxtField.text = firstNameStr
        lastNameTxtField.text = lastNameStr
        whatsupTxtField.text = whatsupstr
        wechatTxtfield.text = wechatStr
        
        if descStr == "" || descStr == "\n"
        {
            descTxtView.text = "No Description"
            
        }
        else
        {
            let encodedData = descStr.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let attributedOptions : [String: AnyObject] =
            [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            do
            {
                
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
                descTxtView.text  = decodedString
                
            }
            catch
            {
                
                print("Fetch failed: \((error as NSError).localizedDescription)")
                
            }
            
       // descTxtView.text = descStr
        }
        descTxtView.layer.borderWidth = 1
        descTxtView.layer.borderColor = UIColor.lightGrayColor().CGColor
        descTxtView.layer.cornerRadius = 5
        
        if descTxtView.text == "No Description"
        {
            descTxtView.textColor = UIColor.lightGrayColor()
        }
        profileImage.layer.cornerRadius = 75
        profileImage.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
   
    
    //MARK:- TextView Delegate
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        
        if textView.text == "No Description"
        {
            textView.text = ""
        }
        
        textView.textColor = UIColor.blackColor()
        
    }
    
    
    
    
    
    
    func textViewDidEndEditing(textView: UITextView)
    {
        
        
        if textView.text == ""
        {
            textView.text = "No Description"
        }
        
        
        if textView.text ==  "No Description"
        {
            textView.textColor = UIColor.lightGrayColor()
        }
            
        else
            
        {
            textView.textColor = UIColor.blackColor()
        }
        
        
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
    
    //MARK:- Update Button
    @IBAction func UpdateBtn(sender: AnyObject)
    {
        updateProfileApi()
    }
    
    //MARK:- Update Profile
    func updateProfileApi()
    {
        
        
        
        if Reachability.isConnectedToNetwork() == false
        {
            let alert = UIAlertView(title: "Alert", message: "No Internet Connection", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
            
        }
            
        else
            
        {
            
            spinningIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningIndicator.labelText = "Loading"
            
            
            createMultipart(profileImage.image!, callback: { success in
                if success
                {
                    //("success")
                    self.spinningIndicator.hide(true)
                }
                else
                {
                    //("fail")
                    self.spinningIndicator.hide(true)
                }
            })
            
            
        }
        
    }
    
    
    
    func createMultipart(image: UIImage, callback: Bool -> Void)
    {
        var userID = NSString()
        if teacherStudentBool == true
        {
              userID = NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
            
        }
        else
        {
          userID = NSUserDefaults.standardUserDefaults().valueForKey("StudentUserID") as! String
        }
        
        let id = userID
        
        let param = [
            "userid" : id as String,
            "first_name" : firstNameTxtField.text,
            "last_name" : lastNameTxtField.text,
            "email" : emailTxtField.text,
            "phone_number" : phoneTxtField.text,
            "description" : descTxtView.text,
            "wechat":wechatTxtfield.text,
            "whatsapp":whatsupTxtField.text,
            "social_id":socialidStr
        ]
        
        //(param)
        
        Alamofire.upload(
            .POST,
            "http://digitallearningtree.com/digitalapi/profiles.php",
            multipartFormData: { multipartFormData in
                
                let imageData = UIImagePNGRepresentation(image)
                
                
                multipartFormData.appendBodyPart(data: imageData!, name: "mem_image", fileName: "iosFile.png", mimeType: "mem_image/*")
                
                for (key, value) in param
                {
                    multipartFormData.appendBodyPart(data:"\(value)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :key)
                }
                
            },
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.navigationController?.popViewControllerAnimated(true)
                        self.spinningIndicator.hide(true)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    let alert = UIAlertView(title: "Alert", message: "Something Wrong.Try again", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        )
        
        
    }
    
    //MARK:- Image button
    
    @IBAction func imageBtn(sender: AnyObject)
    {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Gallery", "Camera")
        
        actionSheet.showInView(self.view)

    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            
            imagePickerTakePhoto.allowsEditing = true
            imagePickerTakePhoto.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            
            presentViewController(imagePickerTakePhoto, animated: true, completion: nil)
            
            
        }
        else if buttonIndex == 2
        {
            if (UIImagePickerController.availableCaptureModesForCameraDevice(UIImagePickerControllerCameraDevice.Rear) != nil)
            {
                imagePickerTakePhoto.allowsEditing = true
                imagePickerTakePhoto.sourceType = UIImagePickerControllerSourceType.Camera
                imagePickerTakePhoto.cameraCaptureMode = .Photo
                
                
                presentViewController(imagePickerTakePhoto, animated: true, completion: nil)
            }
            else
            {
                let alertView = UIAlertView(title:"Alert", message: "Sorry, this device has no camera", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
                
            }
            
            
        }
        
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        
    {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            profileImage.contentMode = .ScaleAspectFit
            profileImage.image = pickedImage
            
            self.dismissViewControllerAnimated(false, completion: nil)
            
            
        }
    }

}
