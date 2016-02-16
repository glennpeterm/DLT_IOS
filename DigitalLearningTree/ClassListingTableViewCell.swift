//
//  ClassListingTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/5/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class ClassListingTableViewCell: UITableViewCell {

    @IBOutlet var studentCount: UILabel!
    @IBOutlet var subjectName: UILabel!
    @IBOutlet var className: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
