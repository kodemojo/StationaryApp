//
//  DeliveryAddressTableViewCell.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class DeliveryAddressTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var radioImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var index: IndexPath?
    
    var address: Address? {
        didSet {
            self.updateDetail()
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
    
    private func updateDetail() {
        guard let address = self.address else {
            return
        }
        let firstName = address.firstname ?? ""
        let lastName = address.lastname ?? ""
        
        let countryCode = address.fax ?? "+91"
        let mobileNo = address.telephone ?? ""
        
        let buildingNo = address.vat_id ?? ""
        let streetNo = (address.street ?? []).joined(separator: ",")
        let countryName = address.company ?? ""
//        let postCode = address.postcode ?? ""
        let city = address.city ?? ""
        
        self.nameLbl.text = "\(firstName) \(lastName)"
        self.mobileLbl.text = "\(countryCode) \(mobileNo)"
        self.addressLbl.text = "\(buildingNo) \(streetNo), \(city) \(countryName)"
        
        self.radioImg.image = (address.isSelected ?? false) ? UIImage(named: "radio_fill") : UIImage(named: "radio_unfill")
    }

}
