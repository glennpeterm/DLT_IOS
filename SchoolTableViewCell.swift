//
//  SchoolTableViewCell.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 11/18/15.
//  Copyright © 2015 mrinal khullar. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell
{

    @IBOutlet var schoolLogoImage: UIImageView!
    @IBOutlet var schoolName: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        
    }

}
