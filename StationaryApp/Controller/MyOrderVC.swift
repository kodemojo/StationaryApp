//
//  MyOrderVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class MyOrderVC: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var hdrLbl: UILabel!
    @IBOutlet weak var addReviewBtn: UIButton!
    
    private var orders: [Order] = []
    private var reviews: [Review] = []
    var isMoveForRating: Bool = false
    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadowinHeader(headershadowView: shadowview)
        self.tableview.register(UINib(nibName: "ReviewTblCell", bundle: Bundle.main), forCellReuseIdentifier: "ReviewTblCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isMoveForRating {
            self.hdrLbl.text = "Review & Rating".localized
            self.addReviewBtn.isHidden = false
            if checkInternet() {
                self.executeForGetProductReviews(productSku: self.selectedProduct?.sku ?? "")
            }
        } else {
            self.hdrLbl.text = "My Orders".localized
            self.addReviewBtn.isHidden = true
            if checkInternet() {
                self.executeGetOrderListAPI()
            }
        }
    }
    
    //MARK:- IBAction
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickAddReviewBtn(_ sender: Any) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: AddReviewVC.self)) as! AddReviewVC
        vc.selectedProduct = self.selectedProduct
        vc.delegate = self
        vc.entityPkValue = "\(self.reviews.first?.entity_pk_value ?? 1)"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func viewOrderDetailBtntapped(_ sender: UIButton) {
        print("Index: \(sender.tag)")
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: OrderDetailVC.self)) as! OrderDetailVC
        vc.order = orders[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyOrderVC: AddReviewDelegate {
    func onAddReviewComplete() {
        print("Review Added")
        if checkInternet() {
            self.executeForGetProductReviews(productSku: self.selectedProduct?.sku ?? "")
        }
    }
}

//MARK:- tableview delegate
extension MyOrderVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isMoveForRating ? self.reviews.count : self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isMoveForRating {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTblCell", for: indexPath) as! ReviewTblCell
            cell.review = self.reviews[indexPath.row]
            cell.cardView.setBorder(color: UIColor.lightGray.withAlphaComponent(0.6), width: 1.0, radius: 10.0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
            cell.order = self.orders[indexPath.row]
            cell.orderDetailBtn.tag = indexPath.row
            cell.orderDetailBtn.addTarget(self, action: #selector(viewOrderDetailBtntapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isMoveForRating {
            return UITableView.automaticDimension
        } else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isMoveForRating {
            return 185.0
        } else {
            return 200
        }
    }
}


//MARK: - APIs
extension MyOrderVC {
    func executeGetOrderListAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getOrders() { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    print(response ?? [:])
                    if let orderDatas = response?["items"] as? [[String: Any]] {
                        self.orders = []
                        for object in orderDatas {
                            self.orders.append(Order(serverData: object))
                        }
                        self.orders = self.orders.sorted(by: { (first, second) -> Bool in
                            let firstDate = first.updated_at ?? ""
                            let secondDate = second.updated_at ?? ""
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            guard let firstD = formatter.date(from: firstDate), let secondD = formatter.date(from: secondDate) else {
                                return true
                            }
                            return (firstD.compare(secondD) == .orderedDescending)
                        })
                        self.tableview.reloadData()
                    }
                }
            }
        }
    }
    func executeForGetProductReviews(productSku: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProductReviews(productSku: productSku) { (response, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                let reviews = response?.reviews?.count ?? 0
                print("Total Reviews: \(reviews)")
                self.reviews = response?.reviews ?? []
                self.tableview.reloadData()
            }
        }
    }
}
