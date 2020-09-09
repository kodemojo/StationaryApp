//
//  FilterLeftCell.swift
//  StationaryApp
//
//  Created by Admin on 12/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class FilterLeftCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var bottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class FilterRightCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
