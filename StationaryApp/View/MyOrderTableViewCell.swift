//
//  MyOrderTableViewCell.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var datetimeLbl: UILabel!
    @IBOutlet weak var orderidLbl: UILabel!
    @IBOutlet weak var orderDetailBtn: UIButton!
    
    var order: Order? {
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
        guard let order = self.order else {
            return
        }
        
        self.orderidLbl.text = "#\(order.increment_id ?? "0")"
        
        if let address = order.billing_address {
            let firstName = address.firstname ?? ""
            let lastName = address.lastname ?? ""
            
            let countryCode = address.fax ?? "+91"
            let mobileNo = address.telephone ?? ""
            
            let buildingNo = address.vat_id ?? ""
            let streetNo = (address.street ?? []).joined(separator: ",")
            let countryName = address.company ?? ""
            let city = address.city ?? ""
            
            self.nameLbl.text = "\(firstName) \(lastName)"
            self.mobileLbl.text = "\(countryCode) \(mobileNo)"
            self.addressLbl.text = "\(buildingNo) \(streetNo), \(city) \(countryName)"
        }
        //"2020-06-17 09:39:04"
        let updatedAt = order.updated_at ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formatter.date(from: updatedAt) {
            formatter.dateFormat = "dd MMM, yyyy | hh:mm a"
            formatter.timeZone = TimeZone.current
            self.datetimeLbl.text = formatter.string(from: date)
        }
    }
}
