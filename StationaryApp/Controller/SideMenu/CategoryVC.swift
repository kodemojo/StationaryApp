//
//  CategoryVC.swift
//  StationaryApp
//
//  Created by Admin on 6/5/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class CategoryVC: UIViewController {
    
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var subCategoryCV: UICollectionView!
    
    private var selectedCategoryIndex: Int = 0
    private var mainCategory: [Category] = []
    private var subCategory: [Category] = []
    private var categoryImageArr: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryImageArr.append(Category(id: 37, name: "Toys".localized, imageStr: "cat_toy_gray"))
        self.categoryImageArr.append(Category(id: 3, name: "Office".localized, imageStr: "cat_office_gray"))
        self.categoryImageArr.append(Category(id: 3, name: "School".localized, imageStr: "cat_school_gray"))
        self.categoryImageArr.append(Category(id: 35, name: "Kitchen".localized, imageStr: "cat_kitchen_gray"))
        self.categoryImageArr.append(Category(id: 70, name: "Occasions".localized, imageStr: "cat_event_gray"))
        self.categoryImageArr.append(Category(id: 41, name: "Home".localized, imageStr: "cat_home_gray"))
        self.categoryImageArr.append(Category(id: 37, name: "Art".localized, imageStr: "cat_art_gray"))
        self.categoryImageArr.append(Category(id: 93, name: "Books".localized, imageStr: "cat_books_gray"))
        self.categoryImageArr.append(Category(id: 105, name: "Eid Al Adha".localized, imageStr: "cat_eid_adha"))
        
        self.setupCollectionView()
        
        if checkInternet() {
            self.executeGetCategoryAPI()
        }
        logScreenEvent()
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        self.categoryCV.isScrollEnabled = true
        self.categoryCV.delegate = self
        self.categoryCV.dataSource = self
        self.categoryCV.reloadData()
        
        self.subCategoryCV.delegate = self
        self.subCategoryCV.dataSource = self
        self.subCategoryCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return mainCategory.count
        } else if collectionView == subCategoryCV {
            return subCategory.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollCell", for: indexPath) as! CategoryCollCell
            cell.imageMainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.imageMainView.layer.cornerRadius = 30.0
            cell.nameLbl.text = self.mainCategory[indexPath.row].name?.localized ?? ""
            cell.iconIV.image = UIImage(named: "logo")
            
            if let image = self.categoryImageArr.filter({ $0.id == self.mainCategory[indexPath.row].id }).first?.image {
                cell.iconIV.image = UIImage(named: image)
            } else {
                cell.iconIV.image = UIImage(named: "logo")
            }
            
            let blueSelectColor = UIColor(red: 32/255.0, green: 108/255.0, blue: 181/255.0, alpha: 1.0)
            
            if #available(iOS 13.0, *) {
                cell.iconIV.image = (indexPath.row == self.selectedCategoryIndex) ? cell.iconIV.image?.withTintColor(blueSelectColor) : cell.iconIV.image?.withTintColor(.darkGray)
            }
            
            if indexPath.row == self.selectedCategoryIndex {
                cell.cardView.backgroundColor = .white
                cell.nameLbl.textColor = blueSelectColor
            } else {
                cell.cardView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.7)
                cell.nameLbl.textColor = .darkGray
            }
            return cell
        } else if collectionView == subCategoryCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ExploreCollCell.self), for: indexPath) as! ExploreCollCell
            cell.nameLbl.text = self.subCategory[indexPath.row].name?.localized ?? ""
            cell.iconIV?.imageFromServerURL(self.subCategory[indexPath.row].image ?? "", placeHolder: UIImage(named: "logo"))
            cell.leadingLbl.isHidden = true
            cell.bottomLbl.isHidden = true
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCV {
            self.selectedCategoryIndex = indexPath.row
            if self.selectedCategoryIndex < self.mainCategory.count {
                self.subCategory = self.mainCategory[self.selectedCategoryIndex].children_data ?? []
            }
            self.categoryCV.reloadData()
            self.subCategoryCV.reloadData()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ProductListVC.self)) as! ProductListVC
            vc.navigation = .subCategory
            vc.categoryId = self.subCategory[indexPath.row].id
            vc.categoryName = self.subCategory[indexPath.row].name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            return CGSize(width: 85.0, height: 115.0)
        } else if collectionView == subCategoryCV {
            let width = (self.subCategoryCV.bounds.width - 40.0) / 2
            return CGSize(width: width, height: width + 20)
        } else {
            return CGSize.zero
        }
    }
}

extension CategoryVC {
    
    /// Profile API
    /// - Parameter params: params to valudate on server
    func executeGetCategoryAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getCategories(params: [:]) { (category, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    print("Category Found")
                    
                    let data = category?.children_data ?? []
                    self.mainCategory = data.filter({ $0.is_active ?? false })
                
                    if self.selectedCategoryIndex < self.mainCategory.count {
                        self.subCategory = self.mainCategory[self.selectedCategoryIndex].children_data ?? []
                    }
                    self.categoryCV.reloadData()
                    self.subCategoryCV.reloadData()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
}
