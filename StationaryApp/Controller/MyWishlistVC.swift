//
//  MyWishlistVC.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class MyWishlistVC: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var productListColctnView: UICollectionView!
    
    //MARK:-Variable
    var isGridView = true
    var productArr = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.setShadowinHeader(headershadowView: shadowview)
        //load productList collectionview xib
        self.productListColctnView.register(UINib(nibName: String(describing: ProductListReusableCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductListReusableCell.self))
        logScreenEvent()
        
        //Append data to ProductList Array ----Testing purpose
//        productArr.append(Product(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg1))
//        productArr.append(Product(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2))
//        productArr.append(Product(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg3))
//        productArr.append(Product(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg4))
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    //MARK:-IBAction
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyWishlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(productArr.count)
        return productArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListReusableCell.self), for: indexPath) as! ProductListReusableCell
//        cell.img.image = productArr[indexPath.row].img
        cell.isTrend.isHidden = true
        
//        cell.sortDesc.text = productArr[indexPath.row].desc
        cell.rating.isHidden = true
        cell.star.isHidden = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if isGridView == true {
        return CGSize(width: collectionView.frame.width / 2.2, height: collectionView.frame.width / 2.2 + 30)
        
    }
}
