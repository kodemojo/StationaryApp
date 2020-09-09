//
//  BrandsVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class BrandsVC: BaseViewController {

    //MARK:- IBOutlet
   
    @IBOutlet weak var collectionview: UICollectionView!
    
    //MARK:-variable
    var headerArray: [String] = []
    var imageArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //load productList collectionview xib
        self.collectionview.register(UINib(nibName: String(describing: HeaderCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HeaderCollectionReusableView.self))
        self.headerArray.append("C")
        self.imageArray.append("brand_t_6")
        self.headerArray.append("D")
        self.imageArray.append("brand_t_1")
        self.headerArray.append("F")
        self.imageArray.append("brand_t_2")
        self.headerArray.append("K")
        self.imageArray.append("brand_t_3")
        self.headerArray.append("P")
        self.imageArray.append("brand_t_4")
        self.headerArray.append("S")
        self.imageArray.append("brand_t_5")
    }
    
    override func storyBoardMain() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //MARK:- IBAction
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: SearchVC.self)) as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cartBtnTapped(_ sender: UIButton) {
//        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: MyCartVC.self)) as! MyCartVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Collectionview delegate
extension BrandsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BrandsItemCollectionViewCell.self), for: indexPath) as! BrandsItemCollectionViewCell
        cell.itemImg.image = UIImage(named: self.imageArray[indexPath.section])
        cell.itemImg.contentMode = .left
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if isGridView == true {
        return CGSize(width: collectionView.frame.width / 2.2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        reusableview.headerLbl.text = headerArray[indexPath.section]
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}
