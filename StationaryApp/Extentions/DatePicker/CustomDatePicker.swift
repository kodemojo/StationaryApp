//
//  CustomDatePicker.swift
//  SaudiCalendar
//
//  Created by TechGropse on 10/15/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import UIKit

class CustomDatePicker: UIView {
    @IBOutlet var datePickerHeader: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var doneBtn: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupdatePicker()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupdatePicker()
    
    }
    private func setupdatePicker(){
        print("DatePicker setup")
    }
}
