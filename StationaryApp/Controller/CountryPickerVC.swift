//
//  CountryPickerVC.swift
//  White Box
//
//  Created by Nitesh on 02/01/20.
//  Copyright © 2020 Nitesh. All rights reserved.
//

import UIKit
import FirebaseAnalytics

protocol CountryControllerDelegate {
    func countryPhoneCodePicker(countryName: String, countryCode: String, phoneCode: String, flag: UIImage)
}
class CountryPickerVC: UIViewController {
    
    @IBOutlet weak var countryPicker: CountryPicker!
    
    var selectedPhoneCode: String?
    var selectedCountryCode: String?
    var isShowPhoneNumber: Bool = false
    var delegate: CountryControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = isShowPhoneNumber
        //        let code = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
        print(selectedCountryCode ?? "QA")
        countryPicker.setCountry(selectedCountryCode ?? "QA")
        if let phoneCode = self.selectedPhoneCode {
            countryPicker.setCountryByPhoneCode(phoneCode)
        }
        logScreenEvent()
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    @IBAction func onClickDoneBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CountryPickerVC: CountryPickerDelegate {
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        delegate?.countryPhoneCodePicker(countryName: name, countryCode: countryCode, phoneCode: phoneCode, flag: flag)
        selectedCountryCode = countryCode
        selectedPhoneCode = phoneCode
    }
}
