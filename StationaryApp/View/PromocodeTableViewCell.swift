//
//  PromocodeTableViewCell.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class PromocodeTableViewCell: UITableViewCell {

    //MARK:-IBOutlet
    @IBOutlet weak var dotedviewLbl: UIView!
    @IBOutlet weak var promocodeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var validLbl: UILabel!
    
    //MARK:- Variable
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:-IBAction
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        
    }
}

class DashedLineView: UIView {

    private let borderLayer = CAShapeLayer()

    override func awakeFromNib() {

        super.awakeFromNib()

        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineDashPattern = [1,1]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(borderLayer)
    }

    override func draw(_ rect: CGRect) {

        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).cgPath
    }
}
