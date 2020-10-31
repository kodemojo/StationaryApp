//
//  ProductListVC.swift
//  StationaryApp
//
//  Created by Admin on 12/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class ProductListVC: BaseViewController {
    
    enum Navigation {
        case category
        case subCategory
        case popularProduct
    }
    
    @IBOutlet weak var hdrLbl: UILabel!
    @IBOutlet weak var gridBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var bottomAnimateView: UIView!
    @IBOutlet weak var productListColctnView: UICollectionView!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var totalProductLbl: UILabel!
    @IBOutlet weak var cartCountLbl: UILabel!
    
    private let cellIdentifier = "ProductListReusableCell"
    private var isGridView = true
    private var lastContentOffset:CGFloat = 0
    private var pageNo: Int = 1
    
    var productArr = [Product]()
    var navigation: Navigation = .popularProduct
    var categoryId: Int?
    var categoryName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listBtn.isHidden = true
        self.gridBtn.isHidden = true
        
        self.setBorder(viw: nil, btn: [gridBtn, listBtn], color: ProjectColor.borderGrayColor)
        scrlView.delegate = self
        
        // Do any additional setup after loading the view.
        self.productListColctnView.register(UINib(nibName: String(describing: ProductListReusableCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductListReusableCell.self))
        
        if checkInternet() {
            switch self.navigation {
            case .popularProduct:
                self.executeGetAllProductAPI(key: "sw_featured", value: "1", isPaging: false)
                break
            case .category, .subCategory:
                if let categoryId = self.categoryId {
                    self.hdrLbl.text = self.categoryName?.localized
                    self.executeGetAllProductAPI(key: "category_id", value: "\((categoryId))", isPaging: false)
                }
                break
            }
            self.getCartCount { (count) in
                UserDefaults.standard.setValue("\(count)", forKey: Constant.UserDefaultKeys.cartCount)
                self.refreshCart()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.bottomAnimateView.setSideDropShadow(isUp: true)
        self.cartCountLbl.setCircleCorner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.gridBtn.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        self.refreshCart()
    }
    
    private func refreshCart() {
        self.cartCountLbl.text = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartCount)?.localized ?? "0".localized
    }
    
    @IBAction func gridAct(_ sender: UIButton) {
        isGridView = true
        self.gridBtn.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        self.listBtn.backgroundColor = .clear
        self.productListColctnView.reloadData()
    }
    
    @IBAction func listAct(_ sender: UIButton) {
        isGridView = false
        self.listBtn.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        self.gridBtn.backgroundColor = .clear
        self.productListColctnView.reloadData()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartBtnTapped(_ sender: UIButton) {
        activeBottomTabMainMenu = .cart
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: SearchVC.self)) as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterAct(_ sender: UIButton) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: FilterVC.self)) as! FilterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickSortBtn(_ sender: Any) {
        self.showSortingAlert()
    }
}

//MARK: - Sorting
private extension ProductListVC {
    func showSortingAlert() {
        let controller = UIAlertController(title: "Sort By".localized, message: nil, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Recently Added".localized, style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
            self.sortByRecentlyAdded()
        }))
        controller.addAction(UIAlertAction(title: "Oldest to Newest".localized, style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
            self.sortByOldestoNewest()
        }))
        controller.addAction(UIAlertAction(title: "Price: Low to High".localized, style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
            self.sortByPrice(isLowToHight: true)
        }))
        controller.addAction(UIAlertAction(title: "Price: High to Low".localized, style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
            self.sortByPrice(isLowToHight: false)
        }))
        controller.addAction(UIAlertAction(title: "Name: A to Z".localized, style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
            self.sortByName(isAtoZ: true)
        }))
        controller.addAction(UIAlertAction(title: "Name: Z to A".localized, style: .default, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
            self.sortByName(isAtoZ: false)
        }))
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
        })
        let tintColor = UIColor(red: 32/255.0, green: 108/255.0, blue: 181/255.0, alpha: 1.0)
        cancel.setValue(tintColor, forKey: "titleTextColor")
        controller.addAction(cancel)
        controller.view.tintColor = .black
        self.present(controller, animated: true, completion: nil)
    }
    
    func sortByRecentlyAdded() {
        var sortedArr: [Product] = []
        sortedArr = self.productArr.sorted(by: { (prod1, prod2) -> Bool in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let firstDate = formatter.date(from: prod1.created_at ?? ""), let secondDate = formatter.date(from: prod2.created_at ?? "") else {
                return true
            }
            return (firstDate.compare(secondDate) == .orderedDescending)
        })
        self.productArr = sortedArr
        self.productListColctnView.reloadData()
    }
    func sortByOldestoNewest() {
        var sortedArr: [Product] = []
        sortedArr = self.productArr.sorted(by: { (prod1, prod2) -> Bool in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let firstDate = formatter.date(from: prod1.created_at ?? ""), let secondDate = formatter.date(from: prod2.created_at ?? "") else {
                return true
            }
            return (firstDate.compare(secondDate) == .orderedAscending)
        })
        self.productArr = sortedArr
        self.productListColctnView.reloadData()
    }
    func sortByPrice(isLowToHight: Bool) {
        var sortedArr: [Product] = []
        sortedArr = self.productArr.sorted(by: { (prod1, prod2) -> Bool in
            return isLowToHight ? (prod1.price ?? 0.0 < prod2.price ?? 0.0) : (prod1.price ?? 0.0 > prod2.price ?? 0.0)
        })
        self.productArr = sortedArr
        self.productListColctnView.reloadData()
    }
    func sortByName(isAtoZ: Bool) {
        var sortedArr: [Product] = []
        sortedArr = self.productArr.sorted(by: { (prod1, prod2) -> Bool in
            return isAtoZ ? (prod1.name ?? "" < prod2.name ?? "") : (prod1.name ?? "" > prod2.name ?? "")
        })
        self.productArr = sortedArr
        self.productListColctnView.reloadData()
    }
}

extension ProductListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListReusableCell.self), for: indexPath) as! ProductListReusableCell
        cell.isTrend.isHidden = true
        cell.product = self.productArr[indexPath.row]
        
        cell.rating.isHidden = true
        cell.star.isHidden = true
        
        if (productArr.count % 20 == 0) && (indexPath.row == productArr.count - 4) {
            if checkInternet() {
                switch self.navigation {
                case .popularProduct:
                    self.executeGetAllProductAPI(key: "sw_featured", value: "1", isPaging: true)
                    break
                case .category, .subCategory:
                    if let categoryId = self.categoryId {
                        self.executeGetAllProductAPI(key: "category_id", value: "\((categoryId))", isPaging: true)
                    }
                    break
                }
            }
        }
        cell.wishList.isHidden = true
        cell.sortDesc.textAlignment = .left
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView == true {
            let width = (collectionView.frame.width - 20) / 2
            return CGSize(width: width , height: width + 10)
        } else {
            return CGSize(width: collectionView.frame.width, height: 150.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ProductDetailVC.self)) as! ProductDetailVC
        vc.selectedProduct = productArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - APIs
extension ProductListVC {
    func executeGetAllProductAPI(key: String, value: String, isPaging: Bool) {
        if !isPaging {
            self.productArr = []
            self.productListColctnView.reloadData()
            self.totalProductLbl.text = "(\(self.productArr.count) \("Products".localized))"
            self.showActivityIndicator(uiView: self.view)
        }
        RestAPI.shared.getProducts(pageNo: "\(self.pageNo)", key: key, value: value) { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.pageNo += 1
                    self.productArr += (response?.items ?? [])
                    self.productListColctnView.reloadData()
                    self.totalProductLbl.text = "(\(self.productArr.count) \("Products".localized)))"
                }
            }
        }
    }
}
