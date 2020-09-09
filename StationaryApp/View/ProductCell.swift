//
//  ProductCell.swift
//  StationaryApp
//
//  Created by Admin on 12/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var isTrend: UIButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var wishList: UIButton!
    @IBOutlet weak var sortDesc: UILabel!
    @IBOutlet weak var discountprice: UILabel!
    @IBOutlet weak var actualPrice: UILabel!
    @IBOutlet weak var offer: UILabel!
    @IBOutlet weak var strikeView: UIView!
    
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
        self.sortDesc.textAlignment = .left
        self.sortDesc.text = product.name ?? ""
        self.discountprice.text = "QAR: \(product.price ?? 0.0)"
        self.actualPrice.isHidden = true
        self.strikeView.isHidden = true
        self.strikeView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        
        for object in product.custom_attributes {
            if object.attribute_code == "special_price" {
                self.actualPrice.text = "QAR: \(product.price ?? 0.0)"
                self.discountprice.text = "QAR: \(Double(object.value ?? "0.0") ?? 0.0)"
                self.actualPrice.isHidden = false
                self.strikeView.isHidden = false
                return
            }
        }
        
        if let imageUrl = product.media_gallery_entries.first?.file {
            let imageMainUrl = APIConstant.ImageMainUrl + imageUrl
            self.img.imageFromServerURL(imageMainUrl, placeHolder: UIImage(named: "logo"))
        }
    }
}
