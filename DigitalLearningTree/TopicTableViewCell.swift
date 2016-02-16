//
//  TopicTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/18/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    @IBOutlet var topicLbl: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
