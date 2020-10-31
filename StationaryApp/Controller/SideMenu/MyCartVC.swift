//
//  MyCartVC.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FirebaseAnalytics

protocol MyCartRefreshDelegate {
    func refreshMyCartData()
}

class MyCartVC: UIViewController {

    @IBOutlet weak var nodataLbl: UILabel!
    //IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var overallAmountLbl: UILabel!
    @IBOutlet weak var saveAmountLbl: UILabel! //You will save QAR 00.00 on this order
    @IBOutlet weak var totalamountLbl: UILabel!
    @IBOutlet weak var deleveryLbl: UILabel!
    @IBOutlet weak var priceFixedLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var mycartProducts: UILabel!
    @IBOutlet weak var tableviewheight: NSLayoutConstraint!
    @IBOutlet weak var promoBtn: UIButton!
    
    //MARK:- Variable
    private let singleTblCellHeight: CGFloat = 180.0
    private var cartItems: [ProductItem] = []
    private var cartResponse: [String: Any]?
    var delegate: MyCartRefreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nodataLbl.isHidden = true
        self.scrollView.isHidden = true
        setupTableView()
        logScreenEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if checkInternet() {
            if isLogged {
                self.getMyCartAPI()
            } else {
                self.executeGetGuestCartItemsAPI()
            }
        }
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    func storyBoardMain() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //MARK:- IBAction
    @IBAction func applyBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func placeorderBtnTapped(_ sender: UIButton) {
        if cartItems.count > 0 {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: DeliveryAddressVC.self)) as! DeliveryAddressVC
            vc.cartItems = self.cartItems
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showMAAlert(message: "Please add some items in your cart", type: .success)
        }
    }
}

//MARK:- tableview delegate
extension MyCartVC : UITableViewDelegate,UITableViewDataSource {
    private func setupTableView() {
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    private func refreshTableView() {
        DispatchQueue.main.async {
            self.tableviewheight.constant = self.singleTblCellHeight * CGFloat(self.cartItems.count)
            self.tableview.layoutIfNeeded()
            self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.item = self.cartItems[indexPath.row]
        
        cell.additionBtn.tag = indexPath.row
        cell.substractBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        
        cell.additionBtn.addTarget(self, action: #selector(plusCellBtnTapped(_:)), for: .touchUpInside)
        cell.substractBtn.addTarget(self, action: #selector(minusCellBtnTapped(_:)), for: .touchUpInside)
        cell.removeBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    @IBAction func plusCellBtnTapped(_ sender: UIButton) {
        print("Addition: \(sender.tag)")
        if checkInternet() {
            if sender.tag < self.cartItems.count {
                let product = self.cartItems[sender.tag]
                guard let itemId = product.item_id, let sku = product.sku else {
                    return
                }
                self.executeForUpdateProductCountInCart(productSku: sku, itemId: "\(itemId)", count: "\((product.qty ?? 0) + 1)")
            }
        }
    }
    
    @IBAction func minusCellBtnTapped(_ sender: UIButton) {
        print("Substraction: \(sender.tag)")
        if checkInternet() {
            if sender.tag < self.cartItems.count {
                let product = self.cartItems[sender.tag]
                if (product.qty ?? 0) == 1 { //Move to remove
                    guard let itemId = product.item_id else {
                        return
                    }
                    self.executeForRemoveProductCountInCart(itemId: "\(itemId)")
                } else {
                    guard let itemId = product.item_id, let sku = product.sku else {
                        return
                    }
                    self.executeForUpdateProductCountInCart(productSku: sku, itemId: "\(itemId)", count: "\((product.qty ?? 0) - 1)")
                }
            }
        }
    }
    
    @IBAction func removeCellBtnTapped(_ sender: UIButton) {
        print("Remove: \(sender.tag)")
        if sender.tag < self.cartItems.count {
            let product = self.cartItems[sender.tag]
            guard let itemId = product.item_id else {
                return
            }
            self.executeForRemoveProductCountInCart(itemId: "\(itemId)")
        }
    }
}

//MARK: - MARK
extension MyCartVC {
    
    //For Guest User
    func executeGetGuestCartItemsAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getCartProductList() { (itemsList, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    if let arr = itemsList, arr.count > 0 {
                        self.scrollView.isHidden = false
                        self.nodataLbl.isHidden = true

                        self.mycartProducts.text = "(\(arr.count) \("products".localized)"
                        self.cartItems = arr
                        self.refreshTableView()
                        
                        for item in arr {
                            if self.checkInternet() {
                                self.executeGetProductDetailAPI(productItem: item)
                            }
                        }
                        self.updateAllAmount()
                    } else {
                        self.scrollView.isHidden = true
                        self.nodataLbl.isHidden = false
                    }
                } else {
                    self.scrollView.isHidden = true
                    self.nodataLbl.isHidden = false
                }
            }
        }
    }
    
    //For Logged User
    func getMyCartAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProductCart() { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    print("Cart Found\n\(response ?? [:])")
                    self.scrollView.isHidden = false
                    self.nodataLbl.isHidden = true
                    self.cartResponse = response
                    self.refreshCartDetails()
                } else {
                    self.scrollView.isHidden = true
                    self.nodataLbl.isHidden = false
                }
            }
        }
    }
    
    private func refreshCartDetails() {
        guard let serverDetail = self.cartResponse else {
            return
        }
        if let itemsObject = serverDetail["items"] as? [[String: Any]] {
            var arr: [ProductItem] = []
            for object in itemsObject {
                let item = ProductItem(serverData: object)
                arr.append(item)
            }
            self.mycartProducts.text = "(\(arr.count) \("products".localized))"
            self.cartItems = arr
            self.refreshTableView()
            
            for item in arr {
                if checkInternet() {
                    self.executeGetProductDetailAPI(productItem: item)
                }
            }
        }
        let count = cartItems.count
        UserDefaults.standard.setValue("\(count)", forKey: Constant.UserDefaultKeys.cartCount)
        
        self.updateAllAmount()
    }
    
    private func updateAllAmount() {
        var totalPrice: Double = 0.0
        for object in self.cartItems {
            totalPrice += ((object.price ?? 0) * (Double(object.qty ?? 0)))
        }
        let count = self.cartItems.count
        self.priceFixedLbl.text = "\("Products".localized) (\(count) item\(count > 1 ? "s" : ""))"
        self.overallAmountLbl.text = "\("QAR:".localized) \(totalPrice)" //Total Cart Amount
        self.priceLbl.text = "\("QAR:".localized) \(totalPrice)" //Price (items) Amount
        self.deleveryLbl.text = "QAR: 0.0".localized //Delivery Charge
        self.totalamountLbl.text = "\("QAR:".localized) \(totalPrice)" //Payable Amount
        self.saveAmountLbl.text = "You will save QAR 0.0 on this order".localized
    }
   
    func executeForUpdateProductCountInCart(productSku: String, itemId: String, count: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.updateProductCountInCart(productSku: productSku, itemId: itemId, count: count) { (item, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                if self.isLogged {
                    self.getMyCartAPI()
                } else {
                    self.executeGetGuestCartItemsAPI()
                }
            } else {
                self.showMAAlert(message: message, type: .success)
            }
            self.delegate?.refreshMyCartData()
        }
    }
    func executeForRemoveProductCountInCart(itemId: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.removeProductFromCart(itemId: itemId) { (message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                if self.isLogged {
                    self.getMyCartAPI()
                } else {
                    self.executeGetGuestCartItemsAPI()
                }
            } else {
                self.showMAAlert(message: message, type: .success)
            }
            self.delegate?.refreshMyCartData()
        }
    }
    
    //Work for car item image
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
                    self.cartItems = self.cartItems.map({ (item) -> ProductItem in
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
}
