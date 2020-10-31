//
//  BottomTabVC.swift
//  White Box
//
//  Created by Admin on 3/16/20.
//  Copyright © 2020 Nitesh. All rights reserved.
//

import UIKit
import FirebaseAnalytics

enum TabMenu {
    case home
    case categories
    case deals
    case cart
    case account
}

protocol BottomVCDelegate {
    func onChangeBottomMenu(menu: TabMenu)
}

class BottomTabVC: UIViewController {
    
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var homeIV: UIImageView!
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var categoryIV: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var dealIV: UIImageView!
    @IBOutlet weak var dealLbl: UILabel!
    @IBOutlet weak var dealBtn: UIButton!
    @IBOutlet weak var cartIV: UIImageView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var cartCountLbl: UILabel!
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var dealView: UIView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    var activeMenu: TabMenu = .home
    var delegate: BottomVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setActiveMenu(menu: activeMenu)
        logScreenEvent()
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    override func viewWillLayoutSubviews() {
        self.cartCountLbl.setCircleCorner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshCart()
    }
    
    func refreshCart() {
        let cartCount = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartCount) ?? "0"
        self.cartCountLbl.text = cartCount.localized
        self.getCartCount { (count) in
            UserDefaults.standard.setValue("\(count)", forKey: Constant.UserDefaultKeys.cartCount)
            self.cartCountLbl.text = "\(count)".localized
        }
    }
    
    @IBAction func onClickHomeBtn(_ sender: Any) {
        self.setActiveMenu(menu: .home)
        self.delegate?.onChangeBottomMenu(menu: .home)
    }
    @IBAction func onClickCategoryBtn(_ sender: Any) {
        self.setActiveMenu(menu: .categories)
        self.delegate?.onChangeBottomMenu(menu: .categories)
    }
    @IBAction func onClickDealBtn(_ sender: Any) {
        self.setActiveMenu(menu: .deals)
        self.delegate?.onChangeBottomMenu(menu: .deals)
    }
    @IBAction func onClickCartBtn(_ sender: Any) {
        self.setActiveMenu(menu: .cart)
        self.delegate?.onChangeBottomMenu(menu: .cart)
    }
    @IBAction func onClickProfileBtn(_ sender: Any) {
        self.setActiveMenu(menu: .account)
        self.delegate?.onChangeBottomMenu(menu: .account)
    }
}

//MARK: - Manage Active Menu
extension BottomTabVC {
    
    func setActiveMenu(menu: TabMenu) {
        
        let activeColor: UIColor = UIColor(red: 60/255.0, green: 124/255.0, blue: 188/255.0, alpha: 1.0)
        let normalColor: UIColor = UIColor.darkGray.withAlphaComponent(0.9)
        
        func resetData() {
            self.homeIV.image = UIImage(named: "tab_home_normal")
            self.categoryIV.image = UIImage(named: "tab_category_normal")
            self.dealIV.image = UIImage(named: "tab_deal_normal")
            self.cartIV.image = UIImage(named: "tab_cart_normal")
            self.profileIV.image = UIImage(named: "tab_account_normal")
            
            self.homeLbl.textColor = normalColor
            self.categoryLbl.textColor = normalColor
            self.dealLbl.textColor = normalColor
            self.cartLbl.textColor = normalColor
            self.profileLbl.textColor = normalColor
        }
        self.activeMenu = menu
        resetData()
        
        switch menu {
        case .home:
            self.homeLbl.textColor = activeColor
            self.homeIV.image = UIImage(named: "tab_home_active")
            break
        case .categories:
            self.categoryLbl.textColor = activeColor
            self.categoryIV.image = UIImage(named: "tab_category_active")
            break
        case .deals:
            self.dealLbl.textColor = activeColor
            self.dealIV.image = UIImage(named: "tab_deal_active")
            break
        case .cart:
            self.cartLbl.textColor = activeColor
            self.cartIV.image = UIImage(named: "tab_cart_active")
            break
        case .account:
            self.profileLbl.textColor = activeColor
            self.profileIV.image = UIImage(named: "tab_account_active")
            break
        }
    }
}

extension UIViewController {
    func addBottomBar(menu: TabMenu, bottomView: UIView) -> UIViewController? {
        bottomView.backgroundColor = UIColor.white
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomTabVC") as! BottomTabVC
        vc.activeMenu = menu
        vc.view.frame = bottomView.bounds
        self.addChild(vc)
        bottomView.addSubview(vc.view)
        return vc
    }
}
