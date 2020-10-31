//
//  DeliveryAddressVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift
import QpayPayment

class DeliveryAddressVC: BaseViewController {

    //MARK:- IBOutlet
    
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var shadowheaderview: UIView!
    @IBOutlet weak var checkboxBtn: UIButton!
    @IBOutlet weak var placeOrderBtnTappd: UIButton!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var saveAmountLbl: UILabel! //You will save QAR 35.00 on this order
    @IBOutlet weak var totalPayLbl: UILabel!
    @IBOutlet weak var deliveryPriceLbl: UILabel!
    @IBOutlet weak var priceFixedLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var promoCodeBtn: UIButton!
    
    @IBOutlet weak var shippingMethodTitleLbl: UILabel!
    @IBOutlet weak var shippingMethodLbl: UILabel!
    @IBOutlet weak var shippingMethodView: UIView!
    
    
    //MARK:-Variable
    var bRec:Bool = false
    var cartItems: [ProductItem]?
    
    private var addresses: [Address] = []
    private var carrierData: [[String: Any]] = []
    private var carrier_code: String?
    private var method_code: String?
    private var deliveryAmount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.shippingMethodTitleLbl.isHidden = true
        self.shippingMethodView.isHidden = true
        
        self.addAddressBtn.isHidden = true
        self.refreshTable()
        self.setShadowinHeader(headershadowView: shadowheaderview)
        self.refreshCartDetails()
    }
    
    override func viewWillLayoutSubviews() {
        self.shippingMethodView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkInternet() {
            if isLogged {
                self.addAddressBtn.isHidden = false
                self.executeGetProfileAPI()
            } else {
                self.executeGetGuestUserAddressAPI()
            }
        }
    }
    
    private func refreshCartDetails() {
        guard let items = self.cartItems else {
            return
        }
        self.updateAllAmount(items: items)
    }
    
    private func updateAllAmount(items: [ProductItem]) {
        var totalPrice: Double = 0.0
        for object in items {
            totalPrice += ((object.price ?? 0) * (Double(object.qty ?? 0)))
        }
        self.priceLbl.text = "\("QAR:".localized) \(totalPrice)" //Price (items) Amount
        totalPrice += deliveryAmount
        let count = items.count
        self.priceFixedLbl.text = "\("Price".localized) (\(count) item\(count > 1 ? "s" : ""))"
        self.totalAmountLbl.text = "\("\("QAR:".localized)".localized) \(totalPrice)" //Total Cart Amount
        self.deliveryPriceLbl.text = "\("QAR:".localized) \(self.deliveryAmount)" //Delivery Charge
        self.totalPayLbl.text = "\("QAR:".localized) \(totalPrice)" //Payable Amount
        self.saveAmountLbl.text = "You will save QAR 0.00 on this order".localized
        self.promoCodeBtn.setTitle("Promo Code".localized, for: .normal)
    }
    
    //MARK:-IBAction
    @IBAction func promocodeBtnTapped(_ sender: UIButton) {
//        self.initiatePayment(currencyCode: "QAR", price: 0.1, orderId: "123")
    }
    
    @IBAction func checkboxBtnTapped(_ sender: UIButton) {
        bRec = !bRec
        if bRec {
            checkboxBtn.setImage(UIImage(named: "green_tick"), for: .normal)
        } else {
            checkboxBtn.setImage(UIImage(named: "green_untick"), for: .normal)
        }
    }
    @IBAction func addnewAddressBtnTapped(_ sender: UIButton) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: AddNewAddressVC.self)) as! AddNewAddressVC
        vc.allAddress = self.addresses
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickPlaceOrderBtn(_ sender: Any) {
        let selectedAdds = self.addresses.filter({ $0.isSelected ?? false })
        if selectedAdds.count > 0 {
            guard let billingAddress = selectedAdds.first,  let carrier_code = carrier_code, let method_code = method_code else {
                self.showMAAlert(message: "Please choose shipping method".localized, type: .success)
                return
            }
            var innerParams: [String: Any] = [:]
            innerParams["shipping_address"] = self.getParam(by: billingAddress)
            innerParams["shipping_carrier_code"] = carrier_code
            innerParams["shipping_method_code"] = method_code
            self.executeForShippingInformation(params: ["addressInformation" : innerParams])
        } else {
            self.showMAAlert(message: "Please choose your address".localized, type: .success)
        }
    }
    @IBAction func onClickShippingMethodBtn(_ sender: Any) {
        self.showCarriedMethod()
    }
}

//MARK:- tableview delegate
extension DeliveryAddressVC : UITableViewDelegate,UITableViewDataSource {
    
    private func refreshTable() {
        DispatchQueue.main.async {
            if self.addresses.count == 0 {
                self.tableviewheight.constant = 140.0
            } else {
                self.tableviewheight.constant = CGFloat(140 * self.addresses.count)
            }
            self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressTableViewCell", for: indexPath) as! DeliveryAddressTableViewCell
        cell.index = indexPath
        cell.address = addresses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addresses = self.addresses.map({ (object) -> Address in
            var add = object
            add.isSelected = false
            return add
        })
        self.addresses[indexPath.row].isSelected = true
        self.tableview.reloadData()
        self.executeToEstimateShippingAddress()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
}

extension DeliveryAddressVC {
    
    /// Profile API
    /// - Parameter params: params to valudate on server
    func executeGetProfileAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProfile(params: [:]) { (profile, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    var address = profile?.addresses ?? []
                    if address.count > 0 {
                        address[0].isSelected = true
                    }
                    self.addresses = address
                    self.refreshTable()
                    self.executeToEstimateShippingAddress()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
    
    func getParam(by address: Address) -> [String: Any] {
        var params: [String: Any] = [:]
        params["city"] = address.city ?? ""
        params["company"] = address.company ?? ""
        params["region_code"] = address.region?.region_code ?? ""
        params["region"] = address.region?.region ?? ""
        params["region_id"] = 0
        params["firstname"] = address.firstname ?? ""
        params["lastname"] = address.lastname ?? ""
        params["country_id"] = address.country_id ?? "0"
        params["telephone"] = address.telephone ?? ""
        params["vat_id"] = address.vat_id ?? ""
        params["postcode"] = address.postcode ?? ""
        params["street"] = address.street ?? []
        params["fax"] = address.fax ?? ""
        params["same_as_billing"] = 1
        return params
    }
    
    func getBillingParam(by address: Address) -> [String: Any] {
        var params: [String: Any] = [:]
        params["region"] = address.region?.region ?? ""
        params["region_id"] = 0
        params["country_id"] = address.country_id ?? "0"
        params["street"] = address.street ?? []
        params["company"] = address.company ?? ""
        params["telephone"] = address.telephone ?? ""
        params["fax"] = address.fax ?? ""
        params["postcode"] = address.postcode ?? ""
        params["city"] = address.city ?? ""
        params["firstname"] = address.firstname ?? ""
        params["lastname"] = address.lastname ?? ""
        
        return params
    }
    
    //Guest User Section
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
                    if self.addresses.count > 0 {
                        self.addAddressBtn.isHidden = true
                    } else {
                        self.addAddressBtn.isHidden = false
                    }
                    self.refreshTable()
                } else {
                    self.addAddressBtn.isHidden = false
                }
            }
        }
    }
}

//MARK: - Order Setup APIs
private extension DeliveryAddressVC {
    
    func showCarriedMethod() {
        
        if carrierData.count > 0 {
            let controller = UIAlertController(title: "Select Shipping Method".localized, message: nil, preferredStyle: .actionSheet)
            for object in carrierData {
                let carrier_title = object["method_title"] as? String ?? ""
                let action = UIAlertAction(title: carrier_title, style: .default) { (action) in
                    self.shippingMethodLbl.text = action.title ?? ""
                    guard let carrier_title = object["method_title"] as? String, let carrier_code = object["carrier_code"] as? String, let method_code = object["method_code"] as? String else {
                        print("No carrier code and method found")
                        return
                    }
                    self.shippingMethodLbl.text = carrier_title
                    self.method_code = method_code
                    self.carrier_code = carrier_code
                    self.deliveryAmount = object["amount"] as? Double ?? 0.0
                    self.refreshCartDetails()
                }
                controller.addAction(action)
            }
            let cancelA = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
            }
            controller.addAction(cancelA)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    func executeToEstimateShippingAddress() {
        guard let billingAddress = self.addresses.filter({ $0.isSelected == true }).first else {
            print("No Address Selected")
            return
        }
        var params: [String: Any] = [:]
        params["address"] = self.getParam(by: billingAddress)
        
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.estimateShippingAddress(params: params) { (response, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.carrierData = response ?? []
                    
                    if let items = self.cartItems {
                        var totalPrice: Double = 0.0
                        for object in items {
                            totalPrice += ((object.price ?? 0) * (Double(object.qty ?? 0)))
                        }
                        
                        if totalPrice < 150.0 {
                            if let method = self.carrierData.first {
                                guard let carrier_title = method["method_title"] as? String, let carrier_code = method["carrier_code"] as? String, let method_code = method["method_code"] as? String else {
                                    print("No carrier code and method found")
                                    return
                                }
                                self.shippingMethodLbl.text = carrier_title
                                self.method_code = method_code
                                self.carrier_code = carrier_code
                                self.deliveryAmount = method["amount"] as? Double ?? 0.0
                                self.refreshCartDetails()
                                self.shippingMethodTitleLbl.isHidden = false
                                self.shippingMethodView.isHidden = false
                            }
                        } else {
                            if let method = self.carrierData.last {
                                guard let carrier_title = method["method_title"] as? String, let carrier_code = method["carrier_code"] as? String, let method_code = method["method_code"] as? String else {
                                    print("No carrier code and method found")
                                    return
                                }
                                self.shippingMethodLbl.text = carrier_title
                                self.method_code = method_code
                                self.carrier_code = carrier_code
                                self.deliveryAmount = method["amount"] as? Double ?? 0.0
                                self.refreshCartDetails()
                                self.shippingMethodTitleLbl.isHidden = false
                                self.shippingMethodView.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func executeForShippingInformation(params: [String: Any]) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.estimateShippingInformation(params: params) { (response, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    guard let mainObject = response else {
                        return
                    }
                    guard let paymentMethodObject = mainObject["payment_methods"] as? [[String: Any]], let paymentMethod = paymentMethodObject.first?["code"] as? String, let totalObject = mainObject["totals"] as? [String: Any], let currencyCode = totalObject["base_currency_code"] as? String, let totalCost = totalObject["grand_total"] as? Double else {
                        return
                    }
                    self.executePlaceOrderAPI(paymentMethod: paymentMethod, currencyCode: currencyCode, price: totalCost)
                }
            }
        }
    }
    
    private func executePlaceOrderAPI(paymentMethod: String, currencyCode: String, price: Double) {
        guard let billingAddress = self.addresses.filter({ $0.isSelected == true }).first else {
            return
        }
        let mainParams: [String: Any] = ["paymentMethod": ["method" : paymentMethod], "billing_address" : getBillingParam(by: billingAddress)]
        self.showActivityIndicator(uiView: self.view)
        
        if self.isLogged {
            RestAPI.shared.createOrder(params: mainParams) { (orderId, message, errorCode) in
                self.hideActivityIndicator(uiView: self.view)
                DispatchQueue.main.async {
                    if (errorCode == APIHelper.apiResponseSuccessCode), let orderId = orderId {
                        self.initiatePayment(currencyCode: currencyCode, price: price, orderId: orderId)
                    }
                }
            }
        } else {
            RestAPI.shared.createGuestOrder(params: mainParams) { (orderId, message, errorCode) in
                self.hideActivityIndicator(uiView: self.view)
                DispatchQueue.main.async {
                    if (errorCode == APIHelper.apiResponseSuccessCode), let orderId = orderId {
                        UserDefaults.standard.setValue(nil, forKey: Constant.UserDefaultKeys.guestCartId)
                        self.initiatePayment(currencyCode: currencyCode, price: price, orderId: orderId)
                    }
                }
            }
        }
    }
}
extension DeliveryAddressVC: QPRequestProtocol {
    
    private func initiatePayment(currencyCode: String, price: Double, orderId: String) {
        
        
        DispatchQueue.main.async {
            
            if let billingAddress = self.addresses.filter({ $0.isSelected == true }).first {
                
                let email = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.email) ?? "iostest1@yopmail.com"
                let mobilNo = billingAddress.telephone ?? ""
                let buildingNo = billingAddress.vat_id ?? ""
                let streetNo = (billingAddress.street ?? []).joined(separator: ",")
                let countryName = billingAddress.company ?? ""
                let postCode = billingAddress.postcode ?? ""
                let city = billingAddress.city ?? ""
                
                let countryId = billingAddress.country_id ?? "IN"
                let address = "\(buildingNo) \(streetNo), \(city) \(countryName), \(postCode)"
                let name = ((billingAddress.firstname ?? "") + (billingAddress.lastname ?? ""))
                
                let orderIdStr = (orderId.replacingOccurrences(of: "\\", with: "")).replacingOccurrences(of: "\"", with: "")
                
                var qpRequestParams : QPRequestParameters!
                qpRequestParams = QPRequestParameters(viewController: self)
                qpRequestParams.delegate = self
                qpRequestParams.gatewayId = "018835267"
                qpRequestParams.secretKey = "2-BYGfUpf0+8EMLO"
                qpRequestParams.name = name
                qpRequestParams.address = address
                qpRequestParams.city = city
                qpRequestParams.state = city
                qpRequestParams.country = countryId
                qpRequestParams.email = email
                qpRequestParams.currency = currencyCode
                qpRequestParams.referenceId = orderIdStr
                qpRequestParams.phone = mobilNo//customer contact number
                qpRequestParams.amount = price //any float value
                qpRequestParams.mode = "live"  //live
                qpRequestParams.productDescription = "product description"
                qpRequestParams.sendRequest()
                
            }
        }
    }
    
    func qpResponse(_ response: NSDictionary) {
        print("Payment Response: \(response)")
        
        DispatchQueue.main.async {
            if let orderId = response["orderId"] as? String, let status = response["status"] as? String, status == "success"
            {
                var orderParams: [String: Any] = [:]
                orderParams["capture"] = true
                orderParams["notify"] = true
                self.showActivityIndicator(uiView: self.view)
                RestAPI.shared.confirmSuccessfulOrder(params: orderParams, orderId: orderId) { (orderId, message, errorCode) in
                    self.hideActivityIndicator(uiView: self.view)
                    PopUp.showAlert(message: message, type: .success)
                }
            }
            else if let errorMsg = response["reason"] as? String
            {
                PopUp.showAlert(message: errorMsg, type: .error)
            }
            else
            {
                PopUp.showAlert(message: APIHelper.apiFailedMessage, type: .error)
            }
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}
