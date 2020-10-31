//
//  DealsVC.swift
//  StationaryApp
//
//  Created by Admin on 12/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FSPagerView
import CHIPageControl

class DealsVC: BaseViewController {
    
    //@IBOutlet weak var headershadowView: UIView!
    @IBOutlet weak var headerPagerView: FSPagerView! {
        didSet {
            self.headerPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var pageControl: CHIPageControlAleppo!
    @IBOutlet weak var pageControlView: UIView!
    
    var headerSlider = [ProjectImages.bannerDemo_01, ProjectImages.extraDemo1, ProjectImages.bannerDemo_01, ProjectImages.extraDemo2]
    var productArr = [[Product1]]()
    var colctnHeader = ["SCHOOL SUPPLIES DEALS","ENVELOPE DEAL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.setShadowinHeader(headershadowView: headershadowView)
        productArr.append([Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg1),Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2),Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2),Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2)])
        productArr.append([Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg1),Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2),Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2)])
    }
    
    override func viewWillLayoutSubviews() {
        self.pageControlView.setCircleCorner()
    }
}
extension DealsVC: FSPagerViewDelegate, FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == headerPagerView {
            return headerSlider.count
        } else {
            return 0
        }
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == headerPagerView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            //pageControl.set(progress: index, animated: true)
            cell.imageView?.image = headerSlider[index]
            return cell
        } else {
            return FSPagerViewCell()
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if pagerView == headerPagerView {
            pageControl.set(progress: targetIndex, animated: true)
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        if pagerView == headerPagerView {
            pageControl.set(progress: pagerView.currentIndex, animated: true)
        }
    }
}

extension DealsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colctnHeader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DealCell.self)) as! DealCell
        cell.name.text = colctnHeader[indexPath.row].localized
        cell.selectedData = productArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
}
















//MARK:- DEALS
class DealCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameData: UICollectionView!
    
    var selectedData: [Product1]?
    
    //load productList collectionview xib
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameData.register(UINib(nibName: String(describing: ProductListReusableCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductListReusableCell.self))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DealCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListReusableCell.self), for: indexPath) as! ProductListReusableCell
//        cell.img.image = selectedData?[indexPath.row].img
        cell.isTrend.isHidden = true
        
//        cell.sortDesc.text = selectedData?[indexPath.row].desc
        cell.rating.isHidden = true
        cell.star.isHidden = true
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2 , height: collectionView.frame.size.height)
    }
    
}
