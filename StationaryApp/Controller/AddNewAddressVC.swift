//
//  AddNewAddressVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AddNewAddressVC: BaseViewController {

    //MARK:- IBoutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var hdrLbl: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: TweeActiveTextField!
    @IBOutlet weak var firstNameTF: TweeActiveTextField!
    @IBOutlet weak var lastNameTF: TweeActiveTextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var mobilenumberPlaceholderLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    
    @IBOutlet weak var buildingNoTF: TweeActiveTextField!
    @IBOutlet weak var streetNoTF: TweeActiveTextField!
    @IBOutlet weak var countryTF: TweeActiveTextField!
    @IBOutlet weak var zoneTF: TweeActiveTextField!
    @IBOutlet weak var zipCodeTF: TweeActiveTextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    private var countryCode: String = "QA"
    var allAddress: [Address] = []
    var selectedAdd: Address?
    
    //MARK:- Viewlife cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTF.tweePlaceholder = "Email"
        self.emailTF.keyboardType = .emailAddress
        self.setShadowinHeader(headershadowView: shadowview)
        self.countryTF.isEnabled = false
        self.showCountryPickerController(isFirst: true)
        
        self.emailView.isHidden = isLogged
        if !isLogged {
            self.selectedAdd = allAddress.first
        }
        if let _ = self.selectedAdd {
            self.hdrLbl.text = "Update Address".localized
            self.updateSelectedAddress()
        } else {
            self.hdrLbl.text = "Add New Address".localized
        }
    }
    
    //MARK:- IBAction
    @IBAction func saveAddBtnTapped(_ sender: UIButton) {
        if let params = validateParams() {
            if isLogged {
                self.executeUpdateProfileAPI(params: params)
            } else {
                self.executeUpdateShippingAddressAPI(params: params)
            }
        }
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickCountryCodeBtn(_ sender: Any) {
//        self.showCountryPickerController(isFirst: false)
    }
    @IBAction func onClickCountryBtn(_ sender: Any) {
//        self.showCountryPickerController(isFirst: false)
    }
}

extension AddNewAddressVC: CountryControllerDelegate {
    private func showCountryPickerController(isFirst: Bool) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.selectedCountryCode = countryCode
        if isFirst {
            self.present(vc, animated: false, completion: {
                vc.dismiss(animated: false, completion: nil)
            })
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    func countryPhoneCodePicker(countryName: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.countryCode = countryCode
        self.countryTF.text = countryName
        self.countryCodeLbl.text = "\(phoneCode)"
    }
}

extension AddNewAddressVC {
    
    private func updateSelectedAddress() {
        guard let address = self.selectedAdd else {
            return
        }
        self.firstNameTF.text = address.firstname ?? ""
        self.lastNameTF.text = address.lastname ?? ""
        self.mobileTF.text = address.telephone ?? ""
        self.countryCodeLbl.text = address.fax ?? ""
        self.countryCode = address.fax ?? ""
        
        self.buildingNoTF.text = address.vat_id ?? ""
        self.streetNoTF.text = address.street?.first ?? ""
        self.countryTF.text = address.company ?? ""
        self.zoneTF.text = address.city ?? ""
        self.zipCodeTF.text = address.postcode ?? ""
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.selectedPhoneCode = self.countryCodeLbl.text
        self.present(vc, animated: false, completion: {
            vc.dismiss(animated: false, completion: nil)
        })
    }
    
    /// Validate all fields for API input
    private func validateParams() -> [String: Any]? {
        
        guard let firstName = self.firstNameTF.text, firstName.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyFirstName)
            return nil
        }
        guard let lastName = self.lastNameTF.text, lastName.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyLastName)
            return nil
        }
        guard let mobileNo = self.mobileTF.text, mobileNo.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyMobile)
            return nil
        }
        guard mobileNo.count < 9 else {
            SupportMethod.showAlertMessage(messageStr: Alert.wrongMobileLength)
            return nil
        }
        if !isLogged {
            guard let email = self.emailTF.text, email.count > 0 else {
                SupportMethod.showAlertMessage(messageStr: Alert.emptyEmail)
                return nil
            }
            guard isValidEmail(email) else {
                SupportMethod.showAlertMessage(messageStr: Alert.wrongEmail)
                return nil
            }
        }
        guard let buildingNo = self.buildingNoTF.text, buildingNo.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyBuildingNo)
            return nil
        }
        guard let streetNo = self.streetNoTF.text, streetNo.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyStreetNo)
            return nil
        }
        guard let countryName = self.countryTF.text, countryName.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyCountryName)
            return nil
        }
        guard let zone = self.zoneTF.text, zone.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyZone)
            return nil
        }
//        guard let zipCode = self.zipCodeTF.text, zipCode.count > 0 else {
//            SupportMethod.showAlertMessage(messageStr: Alert.emptyZipcode)
//            return nil
//        }
        
        if isLogged {
            
            var regionParams: [String: Any] = [:]
            regionParams["region_code"] = zone
            regionParams["region"] = zone
            regionParams["region_id"] = 0
            
            var params: [String: Any] = [:]
            params["region"] = regionParams
            params["country_id"] = countryCode
            params["street"] = [streetNo]
            params["company"] = countryName
            params["telephone"] = mobileNo
            params["default_shipping"] = true
            params["default_billing"] = true
            params["postcode"] = "000000"
            params["city"] = zone
            params["firstname"] = firstName
            params["lastname"] = lastName
            params["fax"] = self.countryCodeLbl.text
            params["vat_id"] = buildingNo
            
            var profileParams: [String: Any] = [:]
            profileParams["firstname"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.firstName) ?? ""
            profileParams["lastname"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.lastName) ?? ""
            profileParams["email"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.email) ?? ""
            profileParams["website_id"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.websiteId) ?? "0"
            
            if let selAdd = self.selectedAdd {
                params["id"] = selAdd.id ?? 0
                params["customer_id"] = selAdd.customer_id ?? 0
                var restObject = getRestAddressParams()
                restObject.append(params)
                profileParams["addresses"] = restObject
            } else {
                var restObject = getRestAddressParams()
                restObject.append(params)
                profileParams["addresses"] = restObject
            }
            var mainParams: [String: Any] = [:]
            mainParams["customer"] = profileParams
            print(mainParams)
            return mainParams
        } else {
            var params: [String: Any] = [:]
            params["region_code"] = zone
            params["region"] = zone
            params["region_id"] = 0
            params["country_id"] = countryCode
            params["street"] = [streetNo]
            params["telephone"] = mobileNo
            params["postcode"] = "000000"
            params["city"] = zone
            params["firstname"] = firstName
            params["lastname"] = lastName
            params["email"] = self.emailTF.text
            params["same_as_billing"] = 1
            params["save_in_address_book"] = 0
            params["fax"] = self.countryCodeLbl.text
            params["company"] = countryName
            params["vat_id"] = buildingNo
            
            var mainParams: [String: Any] = [:]
            mainParams["address"] = params
            print(mainParams)
            return mainParams
        }
    }
    
    private func getRestAddressParams() -> [[String: Any]] {
        
        func getParam(by address: Address) -> [String: Any] {
            var params: [String: Any] = [:]
            
            var regionParams: [String: Any] = [:]
            regionParams["region_code"] = address.region?.region_code ?? ""
            regionParams["region"] = address.region?.region ?? ""
            regionParams["region_id"] = 0
            
            params["region"] = regionParams
            params["country_id"] = address.country_id ?? "0"
            params["street"] = address.street ?? []
            params["company"] = address.company ?? ""
            params["telephone"] = address.telephone ?? ""
            params["default_shipping"] = true
            params["default_billing"] = true
            params["postcode"] = address.postcode ?? ""
            params["city"] = address.city ?? ""
            params["firstname"] = address.firstname ?? ""
            params["lastname"] = address.lastname ?? ""
            params["fax"] = address.fax ?? ""
            params["vat_id"] = address.vat_id ?? ""
            return params
        }
        
        var paramsArr: [[String: Any]] = []
        if let selAdd = self.selectedAdd {
            let excludedAdd = self.allAddress.filter({ $0.id != selAdd.id })
            for address in excludedAdd {
                paramsArr.append(getParam(by: address))
            }
        } else {
            for address in self.allAddress {
                paramsArr.append(getParam(by: address))
            }
        }
        return paramsArr
    }
    
    /// Update Profile API
    /// - Parameter params: params to valudate on server
    func executeUpdateProfileAPI(params: [String: Any]) {
        self.view.endEditing(true)
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.updateProfile(params: params) { (message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
    
    func executeUpdateShippingAddressAPI(params: [String: Any]) {
        self.view.endEditing(true)
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.updateShippingAddress(params: params) { (message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    UserDefaults.standard.set(self.emailTF.text, forKey: Constant.UserDefaultKeys.email)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
}
/*
 
 {
     "base_currency_code" = QAR;
     "base_discount_amount" = 0;
     "base_discount_canceled" = 0;
     "base_discount_tax_compensation_amount" = 0;
     "base_grand_total" = "0.75";
     "base_shipping_amount" = 0;
     "base_shipping_canceled" = 0;
     "base_shipping_discount_amount" = 0;
     "base_shipping_discount_tax_compensation_amnt" = 0;
     "base_shipping_incl_tax" = 0;
     "base_shipping_tax_amount" = 0;
     "base_subtotal" = "0.75";
     "base_subtotal_canceled" = "0.75";
     "base_subtotal_incl_tax" = "0.75";
     "base_tax_amount" = 0;
     "base_tax_canceled" = 0;
     "base_to_global_rate" = 1;
     "base_to_order_rate" = 1;
     "base_total_canceled" = "0.75";
     "base_total_due" = "0.75";
     "billing_address" =     {
         "address_type" = billing;
         city = delhi;
         company = India;
         "country_id" = IN;
         email = "iostest4@yopmail.com";
         "entity_id" = 2058;
         fax = "+91";
         firstname = ios;
         lastname = add2;
         "parent_id" = 1031;
         postcode = 110096;
         region = delhi;
         "region_code" = delhi;
         street =         (
             qwerty
         );
         telephone = 9876543214;
     };
     "billing_address_id" = 2058;
     "created_at" = "2020-06-25 10:13:24";
     "customer_email" = "iostest4@yopmail.com";
     "customer_firstname" = ios;
     "customer_group_id" = 1;
     "customer_id" = 648;
     "customer_is_guest" = 0;
     "customer_lastname" = test4;
     "customer_note_notify" = 0;
     "discount_amount" = 0;
     "discount_canceled" = 0;
     "discount_tax_compensation_amount" = 0;
     "entity_id" = 1031;
     "extension_attributes" =     {
         "applied_taxes" =         (
         );
         "item_applied_taxes" =         (
         );
         "payment_additional_info" =         (
                         {
                 key = "method_title";
                 value = "Pay by Credit/Debit Card (QPay Secure Payment)";
             }
         );
         "shipping_assignments" =         (
                         {
                 items =                 (
                                         {
                         "amount_refunded" = 0;
                         "base_amount_refunded" = 0;
                         "base_discount_amount" = 0;
                         "base_discount_invoiced" = 0;
                         "base_discount_tax_compensation_amount" = 0;
                         "base_original_price" = "0.75";
                         "base_price" = "0.75";
                         "base_price_incl_tax" = "0.75";
                         "base_row_invoiced" = 0;
                         "base_row_total" = "0.75";
                         "base_row_total_incl_tax" = "0.75";
                         "base_tax_amount" = 0;
                         "base_tax_invoiced" = 0;
                         "created_at" = "2020-06-25 10:13:24";
                         "discount_amount" = 0;
                         "discount_invoiced" = 0;
                         "discount_percent" = 0;
                         "discount_tax_compensation_amount" = 0;
                         "discount_tax_compensation_canceled" = 0;
                         "free_shipping" = 0;
                         "is_qty_decimal" = 0;
                         "is_virtual" = 0;
                         "item_id" = 11283;
                         name = "TRI-MATTE CELLO BALL PEN 1.0mm BL";
                         "no_discount" = 0;
                         "order_id" = 1031;
                         "original_price" = "0.75";
                         price = "0.75";
                         "price_incl_tax" = "0.75";
                         "product_id" = 13;
                         "product_type" = simple;
                         "qty_canceled" = 1;
                         "qty_invoiced" = 0;
                         "qty_ordered" = 1;
                         "qty_refunded" = 0;
                         "qty_shipped" = 0;
                         "quote_item_id" = 59164;
                         "row_invoiced" = 0;
                         "row_total" = "0.75";
                         "row_total_incl_tax" = "0.75";
                         "row_weight" = 0;
                         sku = "TRI-MATTE CELLO BALL PEN 1.0mm BL";
                         "store_id" = 1;
                         "tax_amount" = 0;
                         "tax_canceled" = 0;
                         "tax_invoiced" = 0;
                         "tax_percent" = 0;
                         "updated_at" = "2020-07-16 09:52:07";
                     }
                 );
                 shipping =                 {
                     address =                     {
                         "address_type" = shipping;
                         city = delhi;
                         company = India;
                         "country_id" = IN;
                         email = "iostest4@yopmail.com";
                         "entity_id" = 2057;
                         fax = "+91";
                         firstname = ios;
                         lastname = add2;
                         "parent_id" = 1031;
                         postcode = 110096;
                         region = delhi;
                         "region_code" = delhi;
                         street =                         (
                             qwerty
                         );
                         telephone = 9876543214;
                         "vat_id" = c1;
                     };
                     method = "matrixrate_matrixrate_1";
                     total =                     {
                         "base_shipping_amount" = 0;
                         "base_shipping_canceled" = 0;
                         "base_shipping_discount_amount" = 0;
                         "base_shipping_discount_tax_compensation_amnt" = 0;
                         "base_shipping_incl_tax" = 0;
                         "base_shipping_tax_amount" = 0;
                         "shipping_amount" = 0;
                         "shipping_canceled" = 0;
                         "shipping_discount_amount" = 0;
                         "shipping_discount_tax_compensation_amount" = 0;
                         "shipping_incl_tax" = 0;
                         "shipping_tax_amount" = 0;
                     };
                 };
             }
         );
     };
     "global_currency_code" = QAR;
     "grand_total" = "0.75";
     "increment_id" = 000000916;
     "is_virtual" = 0;
     items =     (
                 {
             "amount_refunded" = 0;
             "base_amount_refunded" = 0;
             "base_discount_amount" = 0;
             "base_discount_invoiced" = 0;
             "base_discount_tax_compensation_amount" = 0;
             "base_original_price" = "0.75";
             "base_price" = "0.75";
             "base_price_incl_tax" = "0.75";
             "base_row_invoiced" = 0;
             "base_row_total" = "0.75";
             "base_row_total_incl_tax" = "0.75";
             "base_tax_amount" = 0;
             "base_tax_invoiced" = 0;
             "created_at" = "2020-06-25 10:13:24";
             "discount_amount" = 0;
             "discount_invoiced" = 0;
             "discount_percent" = 0;
             "discount_tax_compensation_amount" = 0;
             "discount_tax_compensation_canceled" = 0;
             "free_shipping" = 0;
             "is_qty_decimal" = 0;
             "is_virtual" = 0;
             "item_id" = 11283;
             name = "TRI-MATTE CELLO BALL PEN 1.0mm BL";
             "no_discount" = 0;
             "order_id" = 1031;
             "original_price" = "0.75";
             price = "0.75";
             "price_incl_tax" = "0.75";
             "product_id" = 13;
             "product_type" = simple;
             "qty_canceled" = 1;
             "qty_invoiced" = 0;
             "qty_ordered" = 1;
             "qty_refunded" = 0;
             "qty_shipped" = 0;
             "quote_item_id" = 59164;
             "row_invoiced" = 0;
             "row_total" = "0.75";
             "row_total_incl_tax" = "0.75";
             "row_weight" = 0;
             sku = "TRI-MATTE CELLO BALL PEN 1.0mm BL";
             "store_id" = 1;
             "tax_amount" = 0;
             "tax_canceled" = 0;
             "tax_invoiced" = 0;
             "tax_percent" = 0;
             "updated_at" = "2020-07-16 09:52:07";
         }
     );
     "order_currency_code" = QAR;
     payment =     {
         "account_status" = "<null>";
         "additional_information" =         (
             "Pay by Credit/Debit Card (QPay Secure Payment)"
         );
         "amount_ordered" = "0.75";
         "base_amount_ordered" = "0.75";
         "base_shipping_amount" = 0;
         "cc_last4" = "<null>";
         "entity_id" = 1031;
         method = "qpay_hosted";
         "parent_id" = 1031;
         "shipping_amount" = 0;
     };
     "protect_code" = 72f7139923c26df70b848b2c6c533149;
     "quote_id" = 10349;
     "remote_ip" = "111.223.26.177";
     "shipping_amount" = 0;
     "shipping_canceled" = 0;
     "shipping_description" = "Select Shipping Method - Pick up from Store";
     "shipping_discount_amount" = 0;
     "shipping_discount_tax_compensation_amount" = 0;
     "shipping_incl_tax" = 0;
     "shipping_tax_amount" = 0;
     state = canceled;
     status = canceled;
     "status_histories" =     (
                 {
             comment = "<null>";
             "created_at" = "2020-06-25 10:13:24";
             "entity_id" = 2148;
             "entity_name" = order;
             "is_customer_notified" = 0;
             "is_visible_on_front" = 0;
             "parent_id" = 1031;
             status = "pending_payment";
         }
     );
     "store_currency_code" = QAR;
     "store_id" = 1;
     "store_name" = "Main Website\nMain Website Store\nEnglish ";
     "store_to_base_rate" = 0;
     "store_to_order_rate" = 0;
     subtotal = "0.75";
     "subtotal_canceled" = "0.75";
     "subtotal_incl_tax" = "0.75";
     "tax_amount" = 0;
     "tax_canceled" = 0;
     "total_canceled" = "0.75";
     "total_due" = "0.75";
     "total_item_count" = 1;
     "total_qty_ordered" = 1;
     "updated_at" = "2020-07-16 09:52:06";
     weight = 0;
 }
 
 {
     "base_currency_code" = QAR;
     "base_discount_amount" = 0;
     "base_discount_tax_compensation_amount" = 0;
     "base_grand_total" = 21;
     "base_shipping_amount" = 0;
     "base_shipping_discount_amount" = 0;
     "base_shipping_discount_tax_compensation_amnt" = 0;
     "base_shipping_incl_tax" = 0;
     "base_shipping_tax_amount" = 0;
     "base_subtotal" = 21;
     "base_subtotal_incl_tax" = 21;
     "base_tax_amount" = 0;
     "base_to_global_rate" = 1;
     "base_to_order_rate" = 1;
     "base_total_due" = 21;
     "billing_address" =     {
         "address_type" = billing;
         city = delhi;
         company = India;
         "country_id" = IN;
         email = "iostest4@yopmail.com";
         "entity_id" = 2394;
         fax = "+91";
         firstname = ios;
         lastname = add2;
         "parent_id" = 1199;
         postcode = 110096;
         region = delhi;
         "region_code" = delhi;
         street =         (
             qwerty
         );
         telephone = 9876543214;
     };
     "billing_address_id" = 2394;
     "created_at" = "2020-07-15 11:29:41";
     "customer_email" = "iostest4@yopmail.com";
     "customer_firstname" = ios;
     "customer_group_id" = 1;
     "customer_id" = 648;
     "customer_is_guest" = 0;
     "customer_lastname" = test4;
     "customer_note_notify" = 0;
     "discount_amount" = 0;
     "discount_tax_compensation_amount" = 0;
     "entity_id" = 1199;
     "extension_attributes" =     {
         "applied_taxes" =         (
         );
         "item_applied_taxes" =         (
         );
         "payment_additional_info" =         (
                         {
                 key = "method_title";
                 value = "Pay by Credit/Debit Card (QPay Secure Payment)";
             }
         );
         "shipping_assignments" =         (
                         {
                 items =                 (
                                         {
                         "amount_refunded" = 0;
                         "base_amount_refunded" = 0;
                         "base_discount_amount" = 0;
                         "base_discount_invoiced" = 0;
                         "base_discount_tax_compensation_amount" = 0;
                         "base_original_price" = 20;
                         "base_price" = 20;
                         "base_price_incl_tax" = 20;
                         "base_row_invoiced" = 0;
                         "base_row_total" = 20;
                         "base_row_total_incl_tax" = 20;
                         "base_tax_amount" = 0;
                         "base_tax_invoiced" = 0;
                         "created_at" = "2020-07-15 11:29:41";
                         "discount_amount" = 0;
                         "discount_invoiced" = 0;
                         "discount_percent" = 0;
                         "discount_tax_compensation_amount" = 0;
                         "free_shipping" = 0;
                         "is_qty_decimal" = 0;
                         "is_virtual" = 0;
                         "item_id" = 13316;
                         name = "Sharpie pens";
                         "no_discount" = 0;
                         "order_id" = 1199;
                         "original_price" = 20;
                         price = 20;
                         "price_incl_tax" = 20;
                         "product_id" = 1;
                         "product_type" = simple;
                         "qty_canceled" = 0;
                         "qty_invoiced" = 0;
                         "qty_ordered" = 1;
                         "qty_refunded" = 0;
                         "qty_shipped" = 0;
                         "quote_item_id" = 59169;
                         "row_invoiced" = 0;
                         "row_total" = 20;
                         "row_total_incl_tax" = 20;
                         "row_weight" = 1;
                         sku = "\U0623\U0642\U0644\U0627\U0645 \U0634\U0631\U0628\U064a";
                         "store_id" = 1;
                         "tax_amount" = 0;
                         "tax_invoiced" = 0;
                         "tax_percent" = 0;
                         "updated_at" = "2020-07-15 11:29:41";
                         weight = 1;
                     },
                                         {
                         "amount_refunded" = 0;
                         "base_amount_refunded" = 0;
                         "base_discount_amount" = 0;
                         "base_discount_invoiced" = 0;
                         "base_discount_tax_compensation_amount" = 0;
                         "base_original_price" = 1;
                         "base_price" = 1;
                         "base_price_incl_tax" = 1;
                         "base_row_invoiced" = 0;
                         "base_row_total" = 1;
                         "base_row_total_incl_tax" = 1;
                         "base_tax_amount" = 0;
                         "base_tax_invoiced" = 0;
                         "created_at" = "2020-07-15 11:29:41";
                         "discount_amount" = 0;
                         "discount_invoiced" = 0;
                         "discount_percent" = 0;
                         "discount_tax_compensation_amount" = 0;
                         "free_shipping" = 0;
                         "is_qty_decimal" = 0;
                         "is_virtual" = 0;
                         "item_id" = 13317;
                         name = "White Glue 100g(1)";
                         "no_discount" = 0;
                         "order_id" = 1199;
                         "original_price" = 1;
                         price = 1;
                         "price_incl_tax" = 1;
                         "product_id" = 3015;
                         "product_type" = simple;
                         "qty_canceled" = 0;
                         "qty_invoiced" = 0;
                         "qty_ordered" = 1;
                         "qty_refunded" = 0;
                         "qty_shipped" = 0;
                         "quote_item_id" = 64787;
                         "row_invoiced" = 0;
                         "row_total" = 1;
                         "row_total_incl_tax" = 1;
                         "row_weight" = 0;
                         sku = 6921583109215;
                         "store_id" = 1;
                         "tax_amount" = 0;
                         "tax_invoiced" = 0;
                         "tax_percent" = 0;
                         "updated_at" = "2020-07-15 11:29:41";
                     }
                 );
                 shipping =                 {
                     address =                     {
                         "address_type" = shipping;
                         city = delhi;
                         company = India;
                         "country_id" = IN;
                         email = "iostest4@yopmail.com";
                         "entity_id" = 2393;
                         fax = "+91";
                         firstname = ios;
                         lastname = add2;
                         "parent_id" = 1199;
                         postcode = 110096;
                         region = delhi;
                         "region_code" = delhi;
                         street =                         (
                             qwerty
                         );
                         telephone = 9876543214;
                         "vat_id" = c1;
                     };
                     method = "matrixrate_matrixrate_1";
                     total =                     {
                         "base_shipping_amount" = 0;
                         "base_shipping_discount_amount" = 0;
                         "base_shipping_discount_tax_compensation_amnt" = 0;
                         "base_shipping_incl_tax" = 0;
                         "base_shipping_tax_amount" = 0;
                         "shipping_amount" = 0;
                         "shipping_discount_amount" = 0;
                         "shipping_discount_tax_compensation_amount" = 0;
                         "shipping_incl_tax" = 0;
                         "shipping_tax_amount" = 0;
                     };
                 };
             }
         );
     };
     "global_currency_code" = QAR;
     "grand_total" = 21;
     "increment_id" = 000001057;
     "is_virtual" = 0;
     items =     (
                 {
             "amount_refunded" = 0;
             "base_amount_refunded" = 0;
             "base_discount_amount" = 0;
             "base_discount_invoiced" = 0;
             "base_discount_tax_compensation_amount" = 0;
             "base_original_price" = 20;
             "base_price" = 20;
             "base_price_incl_tax" = 20;
             "base_row_invoiced" = 0;
             "base_row_total" = 20;
             "base_row_total_incl_tax" = 20;
             "base_tax_amount" = 0;
             "base_tax_invoiced" = 0;
             "created_at" = "2020-07-15 11:29:41";
             "discount_amount" = 0;
             "discount_invoiced" = 0;
             "discount_percent" = 0;
             "discount_tax_compensation_amount" = 0;
             "free_shipping" = 0;
             "is_qty_decimal" = 0;
             "is_virtual" = 0;
             "item_id" = 13316;
             name = "Sharpie pens";
             "no_discount" = 0;
             "order_id" = 1199;
             "original_price" = 20;
             price = 20;
             "price_incl_tax" = 20;
             "product_id" = 1;
             "product_type" = simple;
             "qty_canceled" = 0;
             "qty_invoiced" = 0;
             "qty_ordered" = 1;
             "qty_refunded" = 0;
             "qty_shipped" = 0;
             "quote_item_id" = 59169;
             "row_invoiced" = 0;
             "row_total" = 20;
             "row_total_incl_tax" = 20;
             "row_weight" = 1;
             sku = "\U0623\U0642\U0644\U0627\U0645 \U0634\U0631\U0628\U064a";
             "store_id" = 1;
             "tax_amount" = 0;
             "tax_invoiced" = 0;
             "tax_percent" = 0;
             "updated_at" = "2020-07-15 11:29:41";
             weight = 1;
         },
                 {
             "amount_refunded" = 0;
             "base_amount_refunded" = 0;
             "base_discount_amount" = 0;
             "base_discount_invoiced" = 0;
             "base_discount_tax_compensation_amount" = 0;
             "base_original_price" = 1;
             "base_price" = 1;
             "base_price_incl_tax" = 1;
             "base_row_invoiced" = 0;
             "base_row_total" = 1;
             "base_row_total_incl_tax" = 1;
             "base_tax_amount" = 0;
             "base_tax_invoiced" = 0;
             "created_at" = "2020-07-15 11:29:41";
             "discount_amount" = 0;
             "discount_invoiced" = 0;
             "discount_percent" = 0;
             "discount_tax_compensation_amount" = 0;
             "free_shipping" = 0;
             "is_qty_decimal" = 0;
             "is_virtual" = 0;
             "item_id" = 13317;
             name = "White Glue 100g(1)";
             "no_discount" = 0;
             "order_id" = 1199;
             "original_price" = 1;
             price = 1;
             "price_incl_tax" = 1;
             "product_id" = 3015;
             "product_type" = simple;
             "qty_canceled" = 0;
             "qty_invoiced" = 0;
             "qty_ordered" = 1;
             "qty_refunded" = 0;
             "qty_shipped" = 0;
             "quote_item_id" = 64787;
             "row_invoiced" = 0;
             "row_total" = 1;
             "row_total_incl_tax" = 1;
             "row_weight" = 0;
             sku = 6921583109215;
             "store_id" = 1;
             "tax_amount" = 0;
             "tax_invoiced" = 0;
             "tax_percent" = 0;
             "updated_at" = "2020-07-15 11:29:41";
         }
     );
     "order_currency_code" = QAR;
     payment =     {
         "account_status" = "<null>";
         "additional_information" =         (
             "Pay by Credit/Debit Card (QPay Secure Payment)"
         );
         "amount_ordered" = 21;
         "base_amount_ordered" = 21;
         "base_shipping_amount" = 0;
         "cc_last4" = "<null>";
         "entity_id" = 1199;
         method = "qpay_hosted";
         "parent_id" = 1199;
         "shipping_amount" = 0;
     };
     "protect_code" = 5d9b4e8ec4b19e6b2df92ffd230945c5;
     "quote_id" = 10354;
     "remote_ip" = "2405:204:a4ac:1dee:b03f:3838:db7e:387a";
     "shipping_amount" = 0;
     "shipping_description" = "Select Shipping Method - Pick up from Store";
     "shipping_discount_amount" = 0;
     "shipping_discount_tax_compensation_amount" = 0;
     "shipping_incl_tax" = 0;
     "shipping_tax_amount" = 0;
     state = "pending_payment";
     status = "pending_payment";
     "status_histories" =     (
                 {
             comment = "<null>";
             "created_at" = "2020-07-15 11:29:41";
             "entity_id" = 2480;
             "entity_name" = order;
             "is_customer_notified" = 0;
             "is_visible_on_front" = 0;
             "parent_id" = 1199;
             status = "pending_payment";
         }
     );
     "store_currency_code" = QAR;
     "store_id" = 1;
     "store_name" = "Main Website\nMain Website Store\nEnglish ";
     "store_to_base_rate" = 0;
     "store_to_order_rate" = 0;
     subtotal = 21;
     "subtotal_incl_tax" = 21;
     "tax_amount" = 0;
     "total_due" = 21;
     "total_item_count" = 2;
     "total_qty_ordered" = 2;
     "updated_at" = "2020-07-15 11:29:41";
     weight = 1;
     "x_forwarded_for" = "2405:204:a4ac:1dee:b03f:3838:db7";
 }
 */
