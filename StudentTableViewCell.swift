//
//  StudentTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/7/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet var enrollStudentNameLbl: UILabel!
    @IBOutlet var archivedStudentNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
