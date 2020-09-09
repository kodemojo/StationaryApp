//
//  MyAddressTableViewCell.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol AddressListActionDelegate {
    func addressListDelegate(isEdit: Bool, index: Int)
}
class MyAddressTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var radioImg: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    var delegate: AddressListActionDelegate?
    var index: IndexPath?
    
    var address: Address? {
        didSet {
            self.updateDetail()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.removeBtn.setBorder(color: .lightShadowGray, width: 1.0, radius: 5.0)
        self.editBtn.setBorder(color: .lightShadowGray, width: 1.0, radius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBAction
    @IBAction func editBtnTapped(_ sender: UIButton) {
        self.delegate?.addressListDelegate(isEdit: true, index: self.index?.row ?? 0)
    }
    @IBAction func removeBtnTapped(_ sender: UIButton) {
        self.delegate?.addressListDelegate(isEdit: false, index: self.index?.row ?? 0)
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
        let city = address.city ?? ""
        
        self.nameLbl.text = "\(firstName) \(lastName)"
        self.mobileLbl.text = "\(countryCode) \(mobileNo)"
        self.addressLbl.text = "\(buildingNo) \(streetNo), \(city) \(countryName)"
        self.radioImg.image = (address.isSelected ?? false) ? UIImage(named: "radio_fill") : UIImage(named: "radio_unfill")
        
        self.removeBtn.isHidden = !SupportMethod.isLogged
        self.editBtn.isHidden = !SupportMethod.isLogged
    }
}


// 9598438188 - Pradeep Plumber
