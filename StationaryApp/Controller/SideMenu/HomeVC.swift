//
//  HomeVC.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FSPagerView
import CHIPageControl

class CategoryCollCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageMainView: UIView!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    //90, 120
}

class ExploreCollCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var leadingLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    
    //90, 120
}

var activeBottomTabMainMenu: TabMenu?
class HomeVC: BaseViewController {
    
    @IBOutlet weak var headerMainView: UIView!
    @IBOutlet weak var homeView: UIScrollView!
    @IBOutlet weak var categoryMainView: UIView!
    @IBOutlet weak var dealMainView: UIView!
    @IBOutlet weak var cartMainVIew: UIView!
    @IBOutlet weak var profileMainView: UIView!
    
    @IBOutlet weak var bannerPagerView: FSPagerView! {
        didSet {
            self.bannerPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var bannerPagerControl: CHIPageControlAleppo!
    @IBOutlet weak var bannerPagerControlView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var popularCV: UICollectionView!
    @IBOutlet weak var popularProductHdrView: UIView!
    
    @IBOutlet weak var brandPagerView: FSPagerView! {
        didSet {
            self.brandPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var exploreView: UIView!
    @IBOutlet weak var exploreCV: UICollectionView!
    @IBOutlet weak var exploreCVHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    private var categoryArr: [Category] = []
    private var popularProductArr: [Product] = []
    private var bannerArr: [[String: Any]] = [] //ProjectImages.bannerDemo_01, ProjectImages.bannerDemo_01
    private var exploreArr: [Category] = []
    private var brandArr: [String] = []
    private var activeTabMenu: TabMenu = .home
    private var bottomController: BottomTabVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let menu = activeBottomTabMainMenu {
            self.activeTabMenu = menu
            activeBottomTabMainMenu = nil
        }
        
        self.brandArr.append("brand_t_1")
        self.brandArr.append("brand_t_2")
        self.brandArr.append("brand_t_3")
        self.brandArr.append("brand_t_4")
        self.brandArr.append("brand_t_5")
        self.brandArr.append("brand_t_6")
        
        self.categoryArr.append(Category(id: 37, name: "Toys", imageStr: "cat_toy_gray"))
        self.categoryArr.append(Category(id: 3, name: "Office", imageStr: "cat_office_gray"))
        self.categoryArr.append(Category(id: 3, name: "School", imageStr: "cat_school_gray"))
        self.categoryArr.append(Category(id: 35, name: "Kitchen", imageStr: "cat_kitchen_gray"))
        self.categoryArr.append(Category(id: 70, name: "Occasions", imageStr: "cat_event_gray"))
        self.categoryArr.append(Category(id: 41, name: "Home", imageStr: "cat_home_gray"))
        self.categoryArr.append(Category(id: 37, name: "Art", imageStr: "cat_art_gray"))
        
        self.setupCollectionView()
        self.setupPagerView()
        
        bottomController = self.addBottomBar(menu: .home, bottomView: self.bottomView) as? BottomTabVC
        bottomController?.delegate = self
        self.refreshMenuView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("User Token: \(RestAPI.shared.headerData)", "\nAdmin Token: \(RestAPI.shared.headerAdminData)")
        if checkInternet() {
            self.executeGetCategoryAPI()
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.headerMainView.setSideDropShadow(isUp: false)
        self.bannerPagerControlView.setCircleCorner()
        self.bottomView.setSideDropShadow(isUp: true)
    }
    
    //MARK: - All IBActions
    @IBAction func menuToggle(_ sender: UIButton) {
        if let controller = self.sideMenuController?.menuViewController as? SideMenuVC {
            controller.delegate = self
        }
        self.sideMenuController?.revealMenu()
    }
    @IBAction func onClickSearchBtn(_ sender: Any) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: SearchVC.self)) as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickMorePopularProductBtn(_ sender: Any) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ProductListVC.self)) as! ProductListVC
        vc.navigation = .popularProduct
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: BottomVCDelegate, MyCartRefreshDelegate {
    func refreshMyCartData() {
        self.bottomController?.refreshCart()
    }
    func onChangeBottomMenu(menu: TabMenu) {
        self.activeTabMenu = menu
        self.refreshMenuView()
        self.bottomController?.refreshCart()
    }
    
    private func refreshMenuView() {
        self.bottomController?.setActiveMenu(menu: self.activeTabMenu)
        self.homeView.isHidden = true
        self.categoryMainView.isHidden = true
        self.dealMainView.isHidden = true
        self.cartMainVIew.isHidden = true
        self.profileMainView.isHidden = true
        
        switch self.activeTabMenu {
        case .home:
            self.homeView.isHidden = false
            break
        case .categories:
            self.categoryMainView.isHidden = false
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                vc.view.frame = self.categoryMainView.bounds
                self.addChild(vc)
                self.categoryMainView.addSubview(vc.view)
            }
            break
        case .deals:
            self.dealMainView.isHidden = false
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DealsVC") as! DealsVC
                vc.view.frame = self.dealMainView.bounds
                self.addChild(vc)
                self.dealMainView.addSubview(vc.view)
            }
            break
        case .cart:
            self.cartMainVIew.isHidden = false
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
                vc.delegate = self
                vc.view.frame = self.cartMainVIew.bounds
                self.addChild(vc)
                self.cartMainVIew.addSubview(vc.view)
            }
            break
        case .account:
            if isLogged {
                self.profileMainView.isHidden = false
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                    vc.view.frame = self.profileMainView.bounds
                    self.addChild(vc)
                    self.profileMainView.addSubview(vc.view)
                }
            } else {
                self.showLoginAlert { (isLogin) in
                    if isLogin {
                        SupportMethod.cachedClearedData()
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                }
            }
            break
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        self.categoryCV.delegate = self
        self.categoryCV.dataSource = self
        self.categoryCV.reloadData()
        
        self.popularCV.delegate = self
        self.popularCV.dataSource = self
        self.popularCV.reloadData()
        
        self.exploreCV.isScrollEnabled = false
        self.exploreCV.delegate = self
        self.exploreCV.dataSource = self
        self.exploreCV.reloadData()
    }
    
    private func refreshExploreCollectionView() {
        let rowsMain = self.exploreArr.count / 2
        let rows = (self.exploreArr.count % 2 == 0) ? rowsMain : (rowsMain + 1)
        
        let singleCellHeight = (UIScreen.main.bounds.width - 40.0) / 2
        self.exploreCVHeightConstraints.constant = singleCellHeight * CGFloat(rows)
        self.exploreCV.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return categoryArr.count
        } else if collectionView == popularCV {
            return popularProductArr.count
        } else if collectionView == exploreCV {
            return exploreArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollCell", for: indexPath) as! CategoryCollCell
            cell.imageMainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.imageMainView.layer.cornerRadius = 30.0
            
            cell.nameLbl.text = self.categoryArr[indexPath.row].name ?? ""
            cell.iconIV.image = UIImage(named: "\(self.categoryArr[indexPath.row].image ?? "")")
            
//            cell.nameLbl.text = self.categoryArr[indexPath.row].name ?? ""
//            cell.iconIV.image = UIImage(named: "deals")
            
            return cell
        } else if collectionView == popularCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
            cell.cardView.setBorder(color: UIColor.lightGray.withAlphaComponent(0.4), width: 1.0, radius: 5.0)
            cell.product = self.popularProductArr[indexPath.row]
            return cell
        } else if collectionView == exploreCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ExploreCollCell.self), for: indexPath) as! ExploreCollCell
            cell.nameLbl.text = self.exploreArr[indexPath.row].name ?? ""
            cell.iconIV?.imageFromServerURL(self.exploreArr[indexPath.row].image ?? "", placeHolder: UIImage(named: "logo"))
            
            cell.leadingLbl.setHorizontalDottedLine(color: UIColor.lightGray.withAlphaComponent(0.6))
            cell.bottomLbl.setDottedtLine(color: UIColor.lightGray.withAlphaComponent(0.6))
            
            let currentRow = (indexPath.row) / 2
            let rowsMain = self.exploreArr.count / 2
            let lastRow = (self.exploreArr.count % 2 == 0) ? rowsMain - 1 : (rowsMain)
            let isLastRow: Bool = (currentRow == lastRow)
            
            if indexPath.row == 0 {
                cell.leadingLbl.isHidden = true
                cell.bottomLbl.isHidden = isLastRow
            } else {
                if indexPath.row % 2 == 0 {
                    cell.leadingLbl.isHidden = true
                    cell.bottomLbl.isHidden = isLastRow
                } else {
                    cell.leadingLbl.isHidden = false
                    cell.bottomLbl.isHidden = isLastRow
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCV {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ProductListVC.self)) as! ProductListVC
            vc.navigation = .category
            vc.categoryId = self.categoryArr[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == exploreCV {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ProductListVC.self)) as! ProductListVC
            vc.navigation = .category
            vc.categoryId = self.exploreArr[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == popularCV {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ProductDetailVC.self)) as! ProductDetailVC
            vc.selectedProduct = popularProductArr[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            return CGSize(width: 75.0, height: 110.0)
        } else if collectionView == popularCV {
            return CGSize(width: 160.0 , height: 165.0)
        } else if collectionView == exploreCV {
            let width = (UIScreen.main.bounds.width - 40.0) / 2
            return CGSize(width: width, height: width)
        } else {
            return CGSize.zero
        }
    }
}

//MARK: - FSPagerViewDelegate, FSPagerViewDataSource
extension HomeVC: FSPagerViewDelegate, FSPagerViewDataSource {
    
    private func setupPagerView() {
        self.bannerPagerView.delegate = self
        self.bannerPagerView.dataSource = self
        self.bannerPagerView.reloadData()
        
        self.brandPagerView.delegate = self
        self.brandPagerView.dataSource = self
        self.brandPagerView.reloadData()
        
        self.bannerPagerControl.tintColor = .lightGray
        self.bannerPagerControl.currentPageTintColor = .white
        self.bannerPagerControl.numberOfPages = self.bannerArr.count
        
        self.refreshExploreCollectionView()
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == bannerPagerView {
            return bannerArr.count
        } else if pagerView == brandPagerView {
            return brandArr.count
        }
        return 0
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == bannerPagerView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            bannerPagerControl.set(progress: index, animated: true)
            var imageUrl = bannerArr[index]["image"] as? String ?? ""
            imageUrl = APIConstant.ImageBannerMainUrl + imageUrl
            cell.imageView?.imageFromServerURL(imageUrl, placeHolder: ProjectImages.bannerDemo_01)
            return cell
        } else if pagerView == brandPagerView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.image = UIImage(named: brandArr[index])//UIImage(named: "launch_logo")
            cell.imageView?.contentMode = .center
            return cell
        } else {
            return FSPagerViewCell()
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if pagerView == bannerPagerView {
            bannerPagerControl.set(progress: targetIndex, animated: true)
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        if pagerView == bannerPagerView {
            bannerPagerControl.set(progress: pagerView.currentIndex, animated: true)
        }
    }
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return false
    }
}

//MARK: - APIs
extension HomeVC {
    func executeGetCategoryAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getCategories(params: [:]) { (category, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    print("Category Found")
                    let data = category?.children_data ?? []
                    self.exploreArr = data.filter({ $0.is_active ?? false })
                    self.refreshExploreCollectionView()
                } else if (errorCode == APIHelper.apiResponseLoginFailedCode) {
                    self.doAdminLogin { (isSuccess) in
                        if isSuccess {
                            self.executeGetCategoryAPI()
                        }
                    }
                    return
                }
                self.executeGetAllProductAPI(key: "sw_featured", value: "1")
                self.executeGetHomeBannerAPI()
            }
        }
    }
    
    func executeGetAllProductAPI(key: String, value: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProducts(key: key, value: value) { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.popularProductArr = response?.items ?? []
                    self.popularCV.reloadData()
                }
            }
        }
    }
    func executeGetHomeBannerAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getHomeBanner() { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.bannerArr = response?["responseData"] as? [[String: Any]] ?? []
                    self.bannerPagerControl.numberOfPages = self.bannerArr.count
                    self.bannerPagerView.reloadData()
                }
            }
        }
    }
}

extension UIViewController {
    func doAdminLogin(completion: @escaping(_ isSuccess: Bool) -> ()) {
        RestAPI.shared.getAdminToken { (errorCode) in
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getCartCount(completion: @escaping(_ count: Int) -> ()) {
        if isLogged {
            RestAPI.shared.getProductCart() { (response, message, errorCode) in
                if let itemsObject = response?["items"] as? [[String: Any]] {
                    let count = itemsObject.count
                    completion(count)
                } else {
                    completion(0)
                }
            }
        } else {
            RestAPI.shared.getCartProductList() { (itemsList, message, errorCode) in
                let count = itemsList?.count ?? 0
                completion(count)
            }
        }
    }
    
    func showLoginAlert(completion: @escaping(_ isLogin: Bool) -> ()) {
        let alertController = UIAlertController(title: Constant.APP_NAME, message: Alert.doLoginMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: {
                completion(false)
            })
        }))
        alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: {
                completion(true)
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
