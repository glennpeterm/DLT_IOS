//
//  QuizTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/6/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet var imageWebView: UIWebView!
    @IBOutlet var lastModeiftDate: UILabel!
    @IBOutlet var quizNameLbl: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
