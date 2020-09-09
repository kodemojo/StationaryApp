//
//  MyAddressVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class MyAddressVC: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    private var addresses: [Address] = []
    
    //MARK:- Viewlife cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadowinHeader(headershadowView: shadowview)
        
        self.addAddressBtn.isHidden = !isLogged
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkInternet() {
            if isLogged {
                self.executeGetProfileAPI()
            } else {
                self.executeGetGuestUserAddressAPI()
            }
        }
    }
    
    //MARK:- IBAction
    @IBAction func addnewAddressBtnTapped(_ sender: UIButton) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: AddNewAddressVC.self)) as! AddNewAddressVC
        vc.allAddress = self.addresses
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- tableview delegate
extension MyAddressVC : UITableViewDelegate,UITableViewDataSource, AddressListActionDelegate {
    func addressListDelegate(isEdit: Bool, index: Int) {
        if isEdit {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: AddNewAddressVC.self)) as! AddNewAddressVC
            vc.allAddress = self.addresses
            vc.selectedAdd = self.addresses[index]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let controller = UIAlertController(title: Constant.APP_NAME, message: "Are you sure want to delete this address?", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                controller.dismiss(animated: true, completion: nil)
            }))
            controller.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                controller.dismiss(animated: true, completion: nil)
                var add = self.addresses
                add.remove(at: index)
                self.deleteAndUpdateAddress(addresses: add)
            }))
            self.present(controller, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAddressTableViewCell", for: indexPath) as! MyAddressTableViewCell
        cell.index = indexPath
        cell.delegate = self
        cell.address = addresses[indexPath.row]
        cell.radioImg.isHidden = true
        return cell
    }
}

extension MyAddressVC {
    
    /// Profile API
    /// - Parameter params: params to valudate on server
    func executeGetProfileAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProfile(params: [:]) { (profile, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.addresses = profile?.addresses ?? []
                    self.tableview.reloadData()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
    
    func executeGetGuestUserAddressAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.guestUserShippingAddress() { (address, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    guard let address = address else {
                        return
                    }
                    self.addresses = [address]
                    self.tableview.reloadData()
                    
                }
            }
        }
    }

    /// Validate all fields for API input
    private func deleteAndUpdateAddress(addresses: [Address]) {
        
        var profileParams: [String: Any] = [:]
        profileParams["firstname"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.firstName) ?? ""
        profileParams["lastname"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.lastName) ?? ""
        profileParams["email"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.email) ?? ""
        profileParams["website_id"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.websiteId) ?? "0"
        
        profileParams["addresses"] = getRestAddressParams(addresses: addresses)
        
        var mainParams: [String: Any] = [:]
        mainParams["customer"] = profileParams
        print(mainParams)
        
        self.executeUpdateProfileAPI(params: mainParams)
    }
    
    private func getRestAddressParams(addresses: [Address]) -> [[String: Any]] {
        
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
        for address in addresses {
            paramsArr.append(getParam(by: address))
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
                    self.executeGetProfileAPI()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
}
