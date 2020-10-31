//
//  CartTableViewCell.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var removePriceLbl: UILabel!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var productsTitle: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var strikeView: UIView!
    
    @IBOutlet weak var substractBtn: UIButton!
    @IBOutlet weak var additionBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    
    var item: ProductItem? {
        didSet {
            self.updateAllDetails()
        }
    }
    
    //MARK:- Variable
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateAllDetails() {
        guard let itemDetail = self.item else {
            return
        }
        self.productsTitle.text = itemDetail.name ?? ""
        self.itemCountLbl.text = "\(itemDetail.qty ?? 0)"
        self.priceLbl.text = "\("QAR".localized) \(itemDetail.price ?? 0.0)"
        
        self.removePriceLbl.text = "QAR 0.0".localized
        self.discountLbl.text = "0% Off".localized
        
        let imageMainUrl = APIConstant.ImageMainUrl + (itemDetail.image ?? "")
        self.productImg.imageFromServerURL(imageMainUrl, placeHolder: UIImage(named: "logo"))
        
        self.removePriceLbl.isHidden = true
        self.discountLbl.isHidden = true
        self.strikeView.isHidden = true
        
        
        /*
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
         
         @IBOutlet weak var discountLbl: UILabel!
         @IBOutlet weak var priceLbl: UILabel!
         @IBOutlet weak var removePriceLbl: UILabel!
         @IBOutlet weak var itemCountLbl: UILabel!
         @IBOutlet weak var productsTitle: UILabel!
         @IBOutlet weak var productImg: UIImageView!
         
         {
             "item_id" = 54423;
             name = Notebook;
             price = 20;
             "product_type" = simple;
             qty = 8;
             "quote_id" = 9664;
             sku = Notebook;
         }
         */
    }
}
