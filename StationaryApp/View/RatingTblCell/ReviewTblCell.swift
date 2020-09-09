//
//  ReviewTblCell.swift
//  StationaryApp
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReviewTblCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var rate1IV: UIImageView!
    @IBOutlet weak var rate2IV: UIImageView!
    @IBOutlet weak var rate3IV: UIImageView!
    @IBOutlet weak var rate4IV: UIImageView!
    @IBOutlet weak var rate5IV: UIImageView!
    
    @IBOutlet weak var value1IV: UIImageView!
    @IBOutlet weak var value2IV: UIImageView!
    @IBOutlet weak var value3IV: UIImageView!
    @IBOutlet weak var value4IV: UIImageView!
    @IBOutlet weak var value5IV: UIImageView!
    
    @IBOutlet weak var price1IV: UIImageView!
    @IBOutlet weak var price2IV: UIImageView!
    @IBOutlet weak var price3IV: UIImageView!
    @IBOutlet weak var price4IV: UIImageView!
    @IBOutlet weak var price5IV: UIImageView!
    
    @IBOutlet weak var quality1IV: UIImageView!
    @IBOutlet weak var quality2IV: UIImageView!
    @IBOutlet weak var quality3IV: UIImageView!
    @IBOutlet weak var quality4IV: UIImageView!
    @IBOutlet weak var quality5IV: UIImageView!
    
    var review: Review? {
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
        guard let review = self.review else {
            return
        }
        self.nameLbl.text = review.nickname ?? ""
        self.dateTimeLbl.text = review.created_at ?? ""
        self.messageLbl.text = review.detail ?? ""
        
        if (review.ratings?.count ?? 0) > 3 {
            let rate = review.ratings?[0].value ?? 0
            let value = review.ratings?[1].value ?? 0
            let price = review.ratings?[2].value ?? 0
            let quality = review.ratings?[3].value ?? 0
            
            SupportMethod.updateRating(img1: self.rate1IV, img2: self.rate2IV, img3: self.rate3IV, img4: self.rate4IV, img5: self.rate5IV, rate: rate)
            SupportMethod.updateRating(img1: self.value1IV, img2: self.value2IV, img3: self.value3IV, img4: self.value4IV, img5: self.value5IV, rate: value)
            SupportMethod.updateRating(img1: self.price1IV, img2: self.price2IV, img3: self.price3IV, img4: self.price4IV, img5: self.price5IV, rate: price)
            SupportMethod.updateRating(img1: self.quality1IV, img2: self.quality2IV, img3: self.quality3IV, img4: self.quality4IV, img5: self.quality5IV, rate: quality)
        } else {
            SupportMethod.updateRating(img1: self.rate1IV, img2: self.rate2IV, img3: self.rate3IV, img4: self.rate4IV, img5: self.rate5IV, rate: 0)
            SupportMethod.updateRating(img1: self.value1IV, img2: self.value2IV, img3: self.value3IV, img4: self.value4IV, img5: self.value5IV, rate: 0)
            SupportMethod.updateRating(img1: self.price1IV, img2: self.price2IV, img3: self.price3IV, img4: self.price4IV, img5: self.price5IV, rate: 0)
            SupportMethod.updateRating(img1: self.quality1IV, img2: self.quality2IV, img3: self.quality3IV, img4: self.quality4IV, img5: self.quality5IV, rate: 0)
        }
    }
}

