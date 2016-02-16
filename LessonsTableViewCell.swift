//
//  LessonsTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit
import QuartzCore
class LessonsTableViewCell: UITableViewCell
{
   
    @IBOutlet var videoWebView: UIWebView!
    @IBOutlet var socialMedia: UILabel!
    @IBOutlet var lessonNameLbl: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
       
        
        
    }

}
