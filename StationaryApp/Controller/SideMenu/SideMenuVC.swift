//
//  SideMenuVC.swift
//  StationaryApp
//
//  Created by Admin on 12/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class SideMenuVC: BaseViewController {
    
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var imgArr = [model]()
    var delegate: BottomVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        imgArr.append(model(img: ProjectImages.my_address, name: "My Address"))
        imgArr.append(model(img: ProjectImages.orders, name: "My Order's"))
//        imgArr.append(model(img: ProjectImages.my_wishlist, name: "My Wishlist"))
        imgArr.append(model(img: ProjectImages.my_wishlist, name: "Brands"))
        //imgArr.append(model(img: ProjectImages.my_wishlist, name: "Deals"))
//        imgArr.append(model(img: ProjectImages.promocodes, name: "Promocode / GiftVoucher's"))
//        imgArr.append(model(img: ProjectImages.returnPolicy, name: "Return Policy"))
//        imgArr.append(model(img: ProjectImages.notification, name: "Notificaiton"))
//        imgArr.append(model(img: nil, name: "Shipping Policy"))
//        imgArr.append(model(img: nil, name: "Warranty policy"))
//        imgArr.append(model(img: nil, name: "Privacy Policy"))
        imgArr.append(model(img: nil, name: "Terms & Conditions"))
        imgArr.append(model(img: nil, name: "About Us"))
        imgArr.append(model(img: nil, name: "Contact Us"))
        if isLogged {
            imgArr.append(model(img: nil, name: "Logout"))
        } else {
            imgArr.append(model(img: nil, name: "Login"))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let firstName = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.firstName) ?? ""
        let lastName = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.lastName) ?? ""
        let email = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.email) ?? ""
        
        self.nameLbl.text = isLogged ? "\(firstName) \(lastName)" : "Guest User"
        self.emailLbl.text = email
    }
    
    @IBAction func pushToMyProfile(_ sender: UIButton) {
//        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: MyProfileVC.self)) as! MyProfileVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SideMenuCell.self), for: indexPath) as! SideMenuCell
        cell.img.image = imgArr[indexPath.row].img
        cell.name.text = imgArr[indexPath.row].name
        if imgArr[indexPath.row].name == "Notificaiton" {
            cell.bottomBorder.isHidden = false
        } else {
            cell.bottomBorder.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if imgArr[indexPath.row].name == "My Address" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: MyAddressVC.self)) as! MyAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "My Order's" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: MyOrderVC.self)) as! MyOrderVC
            vc.isMoveForRating = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "My Wishlist" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: MyWishlistVC.self)) as! MyWishlistVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Brands" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: BrandsVC.self)) as! BrandsVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Deals" {
            self.sideMenuController?.hideMenu()
            self.delegate?.onChangeBottomMenu(menu: .deals)
        } else if imgArr[indexPath.row].name == "Promocode / GiftVoucher's" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: PromocodeVC.self)) as! PromocodeVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Return Policy" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: StaticWebViewVC.self)) as! StaticWebViewVC
            vc.navigation = .returnPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Notificaiton" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: NotificationVC.self)) as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Shipping Policy" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: StaticWebViewVC.self)) as! StaticWebViewVC
            vc.navigation = .shippingPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Warranty policy" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: StaticWebViewVC.self)) as! StaticWebViewVC
            vc.navigation = .warrantyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Privacy Policy" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: StaticWebViewVC.self)) as! StaticWebViewVC
            vc.navigation = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Terms & Conditions" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: StaticWebViewVC.self)) as! StaticWebViewVC
            vc.navigation = .termsConditon
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "About Us" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: StaticWebViewVC.self)) as! StaticWebViewVC
            vc.navigation = .aboutUs
            self.navigationController?.pushViewController(vc, animated: true)
        } else if imgArr[indexPath.row].name == "Contact Us" {
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ContactUsVC.self)) as! ContactUsVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (imgArr[indexPath.row].name == "Logout" || imgArr[indexPath.row].name == "Login") {
            SupportMethod.cachedClearedData()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
