//
//  ChangePictureViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import Alamofire

class ChangePictureViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   var spinningIndicator = MBProgressHUD()

    @IBOutlet var zoomView: UIView!
   
    @IBOutlet var zoomScrollView: UIScrollView!
    var imagePickerTakePhoto = UIImagePickerController()
    @IBOutlet var ChngeImage: UIImageView!
    @IBOutlet var saveBtn: UIButton!
   
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var changePicture: UIButton!
    @IBOutlet var EditBtn: UIButton!
    
    var imgaeBool = Bool()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePickerTakePhoto.delegate = self
        
         self.navigationController?.navigationBarHidden = false
        
        EditBtn.layer.borderWidth = 0.5
        EditBtn.layer.borderColor = UIColor.whiteColor().CGColor
        EditBtn.layer.cornerRadius = 3
        
        changePicture.layer.borderWidth = 0.5
        changePicture.layer.borderColor = UIColor.whiteColor().CGColor
        
        deleteBtn.layer.borderWidth = 0.5
        deleteBtn.layer.borderColor = UIColor.whiteColor().CGColor
        deleteBtn.layer.cornerRadius = 3
        
        saveBtn.layer.borderWidth = 1.5
        saveBtn.layer.borderColor = UIColor(red: 83/255, green: 163/255, blue: 55/255, alpha: 1.0).CGColor

      // ChngeImage.image = ClassListAndChangeImage
        
       let imageData = NSUserDefaults.standardUserDefaults().objectForKey("ClassListAndChangeImage") as! NSData
        ChngeImage.image = UIImage(data: imageData)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK:- EDIT DELETE BUTTON
    
    @IBAction func editBtn(sender: AnyObject)
    {
        let editView = storyboard?.instantiateViewControllerWithIdentifier("editView") as! EditClassViewController
        
        self.navigationController?.pushViewController(editView, animated: false)
        
    }
    
    
    @IBAction func deleteBtn(sender: AnyObject)
    {
        let deleteView = storyboard?.instantiateViewControllerWithIdentifier("deleteView") as! DeleteViewController
        
        self.navigationController?.pushViewController(deleteView, animated: false)
    }
    
    
   //MARK:- Back Button

    @IBAction func backbtn(sender: AnyObject)
    
    {
        if backfromEditDeleteChngePicBool == true
        {
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(ClassNameAndDetailViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
            
        }
            
        else
        {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKindOfClass(ClassListingViewController) {
                    self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
        }

    }

    //MARK:- Image Button

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
                imgaeBool = true
                ChngeImage.contentMode = .ScaleAspectFit
                ChngeImage.image = pickedImage
                
                self.dismissViewControllerAnimated(false, completion: nil)
                
                
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
    
    //MARK:- Save Button
    
    @IBAction func saveBtn(sender: AnyObject)
    {
        if imgaeBool == true
        {
        uploadImageApi()
        }
        
        else
        {
            let alert  = UIAlertView(title: "Alert", message: "Please Select the image", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    
    
    
    // MARK:- Upload Image Api
    
    
    func uploadImageApi()
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
            
            
            createMultipart(ChngeImage.image!, callback: { success in
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
        
       print(image)
        let cls_createdby_userID =  NSUserDefaults.standardUserDefaults().valueForKey("cls_createdby_userID") as! String
        let cla_classid_eid =       NSUserDefaults.standardUserDefaults().valueForKey("cla_classid_eid") as! String

        
        let param = [
            "classid" : cla_classid_eid,
            "userid" : cls_createdby_userID,
           
        ]
        
        print(param)
       
        Alamofire.upload(
            .POST,
            "http://digitallearningtree.com/digitalapi/class_image.php",
            multipartFormData: { multipartFormData in
                
                let imageData = UIImagePNGRepresentation(image)
              
                
                multipartFormData.appendBodyPart(data: imageData!, name: "cls_image", fileName: "iosFile.png", mimeType: "cls_image/*")
                
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
                         NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(image), forKey: "ClassListAndChangeImage")
                        //ClassListAndChangeImage = image
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKindOfClass(ClassNameAndDetailViewController) {
                                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                                break
                            }
                        }

                         self.spinningIndicator.hide(true)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    
                }
            }
        )
        
        
    }
    

    
}
