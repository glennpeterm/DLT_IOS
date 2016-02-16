//
//  StudentQuizResultViewController.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 12/18/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import AVFoundation
class StudentQuizResultViewController: UIViewController
{

    var arrayResult  = NSMutableArray()
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomScrollView: UIScrollView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var resultLbl: UILabel!
    @IBOutlet var MinLbl: UILabel!
    @IBOutlet var answeredLbl: UILabel!
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    
     var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //(arrayResult)
        
        nameLbl.text = ""
        
        if let name = arrayResult[0].valueForKey("username")
        {
            nameLbl.text = "Name : \(name)"
        }
        
        scoreLbl.text = ""
        
        if let score = arrayResult[0].valueForKey("scoring")
        {
            scoreLbl.text = "Your Score : \(score)"
        }
        
        answeredLbl.text = ""
        
        if let ans = arrayResult[0].valueForKey("correct")
        {
            answeredLbl.text = "Answered Correctly : \(ans)"
        }
        
        MinLbl.text = ""
        
        if let min = arrayResult[0].valueForKey("min_score")
        {
            MinLbl.text = "Min. Pass % : \(min)%"
        }

        
        resultLbl.text = ""
        
        if let result = arrayResult[0].valueForKey("result_grade")
        {
            resultLbl.text = "Result : \(result)"
        }


        timeLbl.text = ""
        
        if let tim = arrayResult[0].valueForKey("total_time")
        {
            timeLbl.text = "Time Taken : \(tim)"
        }
        
        do
        {
            
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("sounds-882-solemn", ofType: "mp3")!), fileTypeHint:nil)

            //(audioPlayer)
            
            self.audioPlayer.prepareToPlay()
            
            self.audioPlayer.play()
            
        }
        catch
        {
            //("Fetch failed: \((error as NSError).localizedDescription)")
        }
        
        


        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Back Button
    
    @IBAction func backBtn(sender: AnyObject)
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKindOfClass(StudentQuizViewController) {
                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                break
            }
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


    
}
