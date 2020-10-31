//
//  OrderDetailVC.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class OrderDetailVC: BaseViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addressNameLbl: UILabel!
    @IBOutlet weak var addressMobileLbl: UILabel!
    @IBOutlet weak var addressLocationLbl: UILabel!
    
    @IBOutlet weak var priceItemFixedLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var deliveryChargeLbl: UILabel!
    @IBOutlet weak var promoCodeLbl: UILabel!
    @IBOutlet weak var paybleBtn: UILabel!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var cancelNoteLbl: UILabel!
    @IBOutlet weak var shippingMethodLbl: UILabel!
    @IBOutlet weak var pendingStatusLbl: UILabel!
    
    var order: Order?
    private var orderItems: [ProductItem] = []
    private let singleCellHeight: CGFloat = 140.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadowinHeader(headershadowView: shadowview)
        self.updateOrderDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func updateOrderDetails() {
        guard let orderDetail = self.order else {
            return
        }
        self.orderItems = orderDetail.items ?? []
        self.refreshTable()
        for item in self.orderItems {
            self.executeGetProductDetailAPI(productItem: item)
        }
        self.priceItemFixedLbl.text = "\("Price".localized)(\(self.orderItems.count) items)"
        self.orderIdLbl.text = "#\(orderDetail.increment_id ?? "0")"
        
        self.priceLbl.text = "\("QAR".localized) \(orderDetail.grand_total ?? 0.0)"
        self.deliveryChargeLbl.text = "\("QAR 0.0".localized)"
        self.promoCodeLbl.text = "\("QAR 0.0".localized)"
        self.paybleBtn.text = "\("QAR".localized) \(orderDetail.grand_total ?? 0.0)"
        self.pendingStatusLbl.text = orderDetail.paymentStatus ?? ""
        self.shippingMethodLbl.text = orderDetail.shippingDescription ?? ""
        
        let updatedAt = orderDetail.updated_at ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = formatter.date(from: updatedAt) {
            formatter.dateFormat = "dd MMM, yyyy | hh:mm a"
            formatter.timeZone = TimeZone.current
            self.dateTimeLbl.text = formatter.string(from: date)
        }
        
        if let address = orderDetail.billing_address {
            let firstName = address.firstname ?? ""
            let lastName = address.lastname ?? ""
            
            let countryCode = address.fax ?? "+91"
            let mobileNo = address.telephone ?? ""
            
            let buildingNo = address.vat_id ?? ""
            let streetNo = (address.street ?? []).joined(separator: ",")
            let countryName = address.company ?? ""
            let city = address.city ?? ""
            
            self.addressNameLbl.text = "\(firstName) \(lastName)"
            self.addressMobileLbl.text = "\(countryCode) \(mobileNo)"
            self.addressLocationLbl.text = "\(buildingNo) \(streetNo), \(city) \(countryName)"
        }
        
        let status: String = orderDetail.status ?? ""
        if status == "canceled" {
            self.cancelOrderBtn.isHidden = true
            self.cancelNoteLbl.isHidden = false
        } else {
            self.cancelOrderBtn.isHidden = false
            self.cancelNoteLbl.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.cancelNoteLbl.layer.cornerRadius = 8.0
        self.cancelNoteLbl.clipsToBounds = true
    }

    //MARK:-IBAction
    @IBAction func backBtnTappd(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickCancelOrderBtn(_ sender: Any) {
        guard let orderId = self.order?.entity_id else {
            return
        }
        if checkInternet() {
            self.executeCancelOrderAPI(orderId: "\(orderId)")
        }
    }
}

extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    private func refreshTable() {
        DispatchQueue.main.async {
            self.tableviewheight.constant = self.singleCellHeight * CGFloat(self.orderItems.count)
            self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        cell.item = self.orderItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return singleCellHeight
    }
}

extension OrderDetailVC {
    func executeGetProductDetailAPI(productItem: ProductItem) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProductDetail(productSku: productItem.sku ?? "") { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    guard let image = response?.media_gallery_entries.first?.file else {
                        return
                    }
                    print("Image Url: \(image)")
                    self.orderItems = self.orderItems.map({ (item) -> ProductItem in
                        var t = item
                        if t.sku == response?.sku {
                            t.image = image
                        }
                        return t
                    })
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func executeCancelOrderAPI(orderId: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.cancelOrder(orderId: orderId) { (message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                self.showMAAlert(message: message, type: .success)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
