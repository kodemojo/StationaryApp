//
//  ProductTableViewCell.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var item: ProductItem? {
        didSet {
            self.updateDetails()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateDetails() {
        guard let itemDetail = self.item else {
            return
        }
        self.nameLbl.text = itemDetail.name ?? ""
        self.quantityLbl.text = "\(itemDetail.qty_ordered ?? 0)"
        self.priceLbl.text = "QAR \(itemDetail.price ?? 0.0)"
        
        let imageUrl = APIConstant.ImageMainUrl + (itemDetail.image ?? "")
        self.productIV.imageFromServerURL(imageUrl, placeHolder: UIImage(named: "logo"))
    }
}
