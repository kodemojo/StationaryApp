//
//  ProductListReusableCell.swift
//  StationaryApp
//
//  Created by Admin on 12/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Cosmos

class ProductListReusableCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var isTrend: UIButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var wishList: UIButton!
    @IBOutlet weak var sortDesc: UILabel!
    @IBOutlet weak var discountprice: UILabel!
    @IBOutlet weak var actualPrice: UILabel!
    @IBOutlet weak var offer: UILabel!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var strikeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addWishList(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.6,
        animations: {
            self.wishList.setImage(ProjectImages.fill_heart, for: .normal)
            self.wishList.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
        },
        completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.wishList.transform = CGAffineTransform.identity
            }
        })
        
    }
    
    var product: Product? {
        didSet {
            self.updateDetails()
        }
    }
    
    private func updateDetails() {
        guard let product = self.product else {
            return
        }
        self.sortDesc.text = product.name ?? ""
        self.discountprice.text = "\("QAR:".localized) \(product.price ?? 0.0)"
        self.actualPrice.isHidden = true
        self.strikeView.isHidden = true
        self.strikeView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        
        for object in product.custom_attributes {
            if object.attribute_code == "special_price" {
                self.actualPrice.text = "\("QAR:".localized) \(product.price ?? 0.0)"
                self.discountprice.text = "\("QAR:".localized) \(Double(object.value ?? "0.0") ?? 0.0)"
                self.actualPrice.isHidden = false
                self.strikeView.isHidden = false
                return
            }
        }
        let imageUrl = APIConstant.ImageMainUrl + (product.media_gallery_entries.first?.file ?? "")
        self.img.imageFromServerURL(imageUrl, placeHolder: UIImage(named: "logo"))
    }
}
