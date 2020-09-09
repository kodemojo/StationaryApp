//
//  ViewController.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift
import FirebaseAnalytics

class TutoCollCell: UICollectionViewCell {
    
    @IBOutlet weak var mainIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
}

class TutorialVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSlider()
        logScreenEvent()
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    override func viewWillLayoutSubviews() {
        self.signUpBtn.setBorder(color: .black, width: 1.0, radius: 25.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: Constant.UserDefaultKeys.kIsRegistered) || UserDefaults.standard.bool(forKey: Constant.UserDefaultKeys.kIsGuestRegistered) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    @IBAction func onClickGuestUserBtn(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey:Constant.UserDefaultKeys.kIsGuestRegistered)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickSignInBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickSignUpBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Setup Slider
extension TutorialVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupSlider() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.pageControl.numberOfPages = 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TutoCollCell", for: indexPath) as! TutoCollCell
        if indexPath.row == 1 {
            cell.mainIV.image = UIImage(named: "tuto1")
            cell.titleLbl.text = "Easy Purchase"
            cell.descriptionLbl.text = "Find your favourite product that you\nwant to buy easily"
        } else if indexPath.row == 2 {
            cell.mainIV.image = UIImage(named: "tuto2")
            cell.titleLbl.text = "Safe Payment"
            cell.descriptionLbl.text = "Pay for the products you buy safely\nand easily"
        } else { //3
            cell.mainIV.image = UIImage(named: "tuto3")
            cell.titleLbl.text = "Fast Delivery"
            cell.descriptionLbl.text = "Your products is delivered to your home\nsafely and securely"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.bounds.width
        let height = self.collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x / UIScreen.main.bounds.width).rounded()
        self.pageControl.currentPage = Int(index)
    }
}

