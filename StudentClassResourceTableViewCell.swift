//
//  StudentClassResourceTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/9/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class StudentClassResourceTableViewCell: UITableViewCell {

    @IBOutlet var imageWebView: UIWebView!
    @IBOutlet var classresourceName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
