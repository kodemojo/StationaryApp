//
//  ProductDetailVC.swift
//  StationaryApp
//
//  Created by Admin on 12/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Cosmos
import SideMenuSwift

class ProductDetailVC: BaseViewController {
    
    @IBOutlet weak var bigImagesColctnView: UICollectionView!
    @IBOutlet weak var smallImagesColctnView: UICollectionView!
    @IBOutlet weak var smallImagesColctnHeight: NSLayoutConstraint!
    @IBOutlet weak var smallImagesColctnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var discountPriceLbl: UILabel!
    @IBOutlet weak var mainPriceLbl: UILabel!
    @IBOutlet weak var mainPriceStrikeView: UIView!
    @IBOutlet weak var discountPercentLbl: UILabel!
    
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityParentView: UIView!
    @IBOutlet weak var quantityLbl: UILabel!
    
    @IBOutlet weak var aboutProductTblView: UITableView!
    @IBOutlet weak var aboutProductTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var addToWishList: UIButton!
    @IBOutlet weak var hdrLbl: UILabel!
    
    @IBOutlet weak var simillarProductColctnView: UICollectionView!
    @IBOutlet weak var simillarProductColctnHeight: NSLayoutConstraint!
    @IBOutlet weak var recentViewedColctnView: UICollectionView!
    @IBOutlet weak var recentViewedColctnHeight: NSLayoutConstraint!
    @IBOutlet weak var cartCountLbl: UILabel!
    
//    private var imgArr = [ProjectImages.demoImg1, ProjectImages.demoImg2, ProjectImages.demoImg3, ProjectImages.demoImg1, ProjectImages.demoImg2, ProjectImages.demoImg3, ProjectImages.demoImg1, ProjectImages.demoImg2, ProjectImages.demoImg3]
    private var aboutProductArr = [AboutProduct]()
    private var productArr = [Product1]()
    private var productQnt: Int = 1
    private var galleryArr: [Gallery] = []
    private var cartItemId: Int?
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialization()
        self.quantityLbl.text = "\(productQnt)"
        self.quantityView.isHidden = true
        self.addToCartBtn.isHidden = false
        
        self.refreshProductDetails()
        if checkInternet() {
            if let sku = self.selectedProduct?.sku {
                self.executeGetProductDetailAPI(productSku: sku)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.cartCountLbl.setCircleCorner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshCart()
    }
    
    private func refreshCart() {
        self.cartCountLbl.text = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartCount) ?? "0"
    }
    
    @IBAction func quantityMinusAct(_ sender: UIButton) {
        if checkInternet() {
            if productQnt == 1 { //Move to remove
                guard let itemId = self.cartItemId else {
                    return
                }
                self.executeForRemoveProductCountInCart(itemId: "\(itemId)")
            } else {
                guard let itemId = self.cartItemId, let sku = self.selectedProduct?.sku else {
                    return
                }
                self.executeForUpdateProductCountInCart(productSku: sku, itemId: "\(itemId)", count: "\(productQnt - 1)")
            }
        }
    }
    
    @IBAction func quantityPlusAct(_ sender: UIButton) {
        if checkInternet() {
            guard let itemId = self.cartItemId, let sku = self.selectedProduct?.sku else {
                return
            }
            self.executeForUpdateProductCountInCart(productSku: sku, itemId: "\(itemId)", count: "\(productQnt + 1)")
        }
    }
    
    func highlightSelectedImg(indx: IndexPath) {
        guard let customCellCall = smallImagesColctnView.cellForItem(at: indx) as? ProductDetailSmallCell else { return }
        //smallImagesColctnView.delegate?.collectionView?(smallImagesColctnView, didDeselectItemAt: indx)
        smallImagesColctnView.delegate?.collectionView?(smallImagesColctnView, willDisplay: customCellCall, forItemAt: indx)
        smallImagesColctnView.delegate?.collectionView?(smallImagesColctnView, didEndDisplaying: customCellCall, forItemAt: indx)
        //smallImagesColctnView.delegate?.collectionView?(smallImagesColctnView, didSelectItemAt: indx)
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
        guard let attribute = self.selectedProduct?.custom_attributes else {
            return
        }
        if let attribute = attribute.filter({ $0.attribute_code == "url_key" }).first {
            let name = self.selectedProduct?.name ?? ""
            let url = "\(APIConstant.websiteUrl)/\(attribute.value ?? "").html"
            if let mainUrl = URL(string: url) {
                let objectsToShare = [name, mainUrl] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if checkInternet() {
            if isLogged {
                guard let sku = self.selectedProduct?.sku else {
                    return
                }
                self.executeForCreateCart(productSku: sku)
            } else {
                guard let sku = self.selectedProduct?.sku else {
                    return
                }
                if UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) == nil  {
                    self.executeForCreateCart(productSku: sku)
                } else {
                    self.executeForAddProductInCart(productSku: sku)
                }
            }
        }
    }
    
    @IBAction func addToWish(_ sender: UIButton) {
        
    }
    
    private func initialization() {
        //load productList collectionview xib
        self.recentViewedColctnView.register(UINib(nibName: String(describing: ProductListReusableCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductListReusableCell.self))
        
        //load productList collectionview xib
        self.simillarProductColctnView.register(UINib(nibName: String(describing: ProductListReusableCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductListReusableCell.self))
        
        self.setBorder(viw: [quantityParentView], btn: [addToWishList], color: ProjectColor.borderGrayColor)
        
        self.aboutProductArr.append(AboutProduct(title: "Product Detail", desc: "\(self.selectedProduct?.name ?? "")"))
        self.aboutProductArr.append(AboutProduct(title: "Delivery", desc: "Please note that estimated delivery is 4-7 working days"))
        self.aboutProductArr.append(AboutProduct(title: "Review", desc: "0 Reviews & Ratings"))
        self.aboutProductTblView.reloadData()
        
        DispatchQueue.main.async {
            self.aboutProductTblHeight.constant = self.aboutProductTblView.contentSize.height
            self.aboutProductTblView.layoutIfNeeded()
            self.smallImagesColctnHeight.constant = self.smallImagesColctnView.contentSize.height
            self.smallImagesColctnWidth.constant = self.smallImagesColctnView.contentSize.width
            self.simillarProductColctnHeight.constant = self.simillarProductColctnView.contentSize.height
            self.recentViewedColctnHeight.constant = self.recentViewedColctnView.contentSize.height
        }
        self.aboutProductTblView.layoutIfNeeded()
        self.smallImagesColctnView.layoutIfNeeded()
        self.simillarProductColctnView.layoutIfNeeded()
        self.recentViewedColctnView.layoutIfNeeded()
    }
}


extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutProductArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutProductCell.self), for: indexPath) as! AboutProductCell
        cell.desc.text = aboutProductArr[indexPath.row].desc
        cell.titl.text = aboutProductArr[indexPath.row].title
        cell.desc.textColor = UIColor.darkGray.withAlphaComponent(0.6)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            print("Move for review")
            let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: MyOrderVC.self)) as! MyOrderVC
            vc.isMoveForRating = true
            vc.selectedProduct = self.selectedProduct
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bigImagesColctnView {
            if self.galleryArr.count >= 6 {
                return 6
            } else {
                return self.galleryArr.count
            }
        } else if collectionView == smallImagesColctnView {
            if self.galleryArr.count >= 6 {
                return 6
            } else {
                return self.galleryArr.count
            }
        } else if collectionView == simillarProductColctnView {
            return productArr.count
        }  else if collectionView == recentViewedColctnView {
            return productArr.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bigImagesColctnView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductDetailBigCell.self), for: indexPath) as! ProductDetailBigCell
            cell.gallery = self.galleryArr[indexPath.row]
            return cell
        } else if collectionView == smallImagesColctnView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductDetailSmallCell.self), for: indexPath) as! ProductDetailSmallCell
//            if indexPath.row == 5 {
//                cell.moreParentView.isHidden = false
//            } else {
//                cell.moreParentView.isHidden = true
//            }
            cell.moreParentView.isHidden = true
            cell.gallery = self.galleryArr[indexPath.row]
            return cell

        } else if collectionView == simillarProductColctnView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListReusableCell.self), for: indexPath) as! ProductListReusableCell
//            cell.img.image = productArr[indexPath.row].img
//            cell.sortDesc.text = productArr[indexPath.row].desc
//            cell.rating.text = "\(productArr[indexPath.row].rating!)"
            return cell
        } else if collectionView == recentViewedColctnView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListReusableCell.self), for: indexPath) as! ProductListReusableCell
//            cell.img.image = productArr[indexPath.row].img
//            cell.sortDesc.text = productArr[indexPath.row].desc
//            cell.rating.text = "\(productArr[indexPath.row].rating!)"
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bigImagesColctnView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == smallImagesColctnView {
            return CGSize(width: 25, height: 25)
        } else if collectionView == simillarProductColctnView {
            return CGSize(width: collectionView.frame.width / 2.2 , height: collectionView.frame.size.height)
        } else if collectionView == recentViewedColctnView {
            return CGSize(width: collectionView.frame.width / 2.2 , height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == bigImagesColctnView {
            guard let customCellCall = smallImagesColctnView.cellForItem(at: indexPath) as? ProductDetailSmallCell else { return }
            DispatchQueue.main.async {
                customCellCall.parentView.layer.borderColor = ProjectColor.defaultBlue.cgColor
                customCellCall.parentView.layer.borderWidth = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == bigImagesColctnView {
            guard let customCellCall = smallImagesColctnView.cellForItem(at: indexPath) as? ProductDetailSmallCell else { return }
            DispatchQueue.main.async {
                customCellCall.parentView.layer.borderColor = UIColor.white.cgColor
                customCellCall.parentView.layer.borderWidth = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bigImagesColctnView {
            let cell = self.bigImagesColctnView.cellForItem(at: indexPath) as? ProductDetailBigCell
            self.imageTapped(cell?.img.image)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bigImagesColctnView {
            let xPos = self.bigImagesColctnView.contentOffset.x / self.bigImagesColctnView.bounds.width
            self.highlightSelectedImg(indx: [0,Int(xPos)])
            //self.pageControl.currentPage = Int(xPos)
        }
    }
    
    func imageTapped(_ image: UIImage?) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}

extension ProductDetailVC {
    func executeGetProductDetailAPI(productSku: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProductDetail(productSku: productSku) { (response, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    if let product = response {
                        self.selectedProduct = product
                        self.refreshProductDetails()
                        self.executeGetCartItemsAPI()
                        self.executeForGetProductReviews(productSku: productSku)
                    }
                }
            }
        }
    }
    private func refreshProductDetails() {
        guard let product = self.selectedProduct else {
            return
        }
        self.productNameLbl.text = product.name ?? ""
        self.hdrLbl.text = product.name ?? ""
        self.discountPriceLbl.text = "QAR: \(product.price ?? 0.0)"
        self.mainPriceLbl.isHidden = true
        self.mainPriceStrikeView.isHidden = true
        self.mainPriceStrikeView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        
        self.galleryArr = product.media_gallery_entries
        self.bigImagesColctnView.reloadData()
        self.smallImagesColctnView.reloadData()
        self.smallImagesColctnWidth.constant = ((CGFloat(self.galleryArr.count) * 25.0) + 10.0 * (CGFloat(self.galleryArr.count - 1)))
        self.smallImagesColctnView.reloadData()
        
        self.totalAmountLbl.text = self.discountPriceLbl.text
        
        for object in product.custom_attributes {
            if object.attribute_code == "special_price" {
                self.mainPriceLbl.text = "QAR: \(product.price ?? 0.0)"
                self.discountPriceLbl.text = "QAR: \(Double(object.value ?? "0.0") ?? 0.0)"
                self.mainPriceLbl.isHidden = false
                self.mainPriceStrikeView.isHidden = false
                return
            }
        }
    }
    
    func executeGetCartItemsAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getCartProductList() { (itemsList, message, errorCode) in
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view)
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    if let products = itemsList {
                        let filtered = products.filter({ $0.sku == self.selectedProduct?.sku })
                        if filtered.count > 0 {
                            self.cartItemId = filtered[0].item_id
                            let count = filtered[0].qty ?? 0
                            self.productQnt = count
                            self.quantityLbl.text = "\(count)"
                            self.totalAmountLbl.text = "QAR:\((filtered[0].price ?? 0.0) * (Double(self.productQnt)))"
                            self.quantityView.isHidden = false
                            self.addToCartBtn.isHidden = true
                        } else {
                            self.productQnt = 0
                            self.quantityLbl.text = "0"
                            self.totalAmountLbl.text = "QAR: 0.0"
                            self.quantityView.isHidden = true
                            self.addToCartBtn.isHidden = false
                        }
                    }
                }
                
                self.getCartCount { (count) in
                    UserDefaults.standard.setValue("\(count)", forKey: Constant.UserDefaultKeys.cartCount)
                    self.refreshCart()
                }
            }
        }
    }
    
    func executeForCreateCart(productSku: String) {
        RestAPI.shared.createProductCart { (message, errorCode) in
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                let cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
                print("Cart Created ID: \(cartId)")
                self.executeForAddProductInCart(productSku: productSku)
            }
        }
    }
    func executeForAddProductInCart(productSku: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.addSigleProductInCart(productSku: productSku) { (item, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                self.cartItemId = item?.item_id
                self.productQnt = item?.qty ?? 0
                self.quantityLbl.text = "\(self.productQnt)"
                self.totalAmountLbl.text = "QAR:\((item?.price ?? 0) * (Double(self.productQnt)))"
                self.addToCartBtn.isHidden = true
                self.quantityView.isHidden = false
                
                self.getCartCount { (count) in
                    UserDefaults.standard.setValue("\(count)", forKey: Constant.UserDefaultKeys.cartCount)
                    self.refreshCart()
                }
            } else {
                self.showMAAlert(message: message, type: .success)
            }
        }
    }
    func executeForUpdateProductCountInCart(productSku: String, itemId: String, count: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.updateProductCountInCart(productSku: productSku, itemId: itemId, count: count) { (item, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                self.cartItemId = item?.item_id
                self.productQnt = item?.qty ?? 0
                self.quantityLbl.text = "\(self.productQnt)"
                self.totalAmountLbl.text = "QAR:\((item?.price ?? 0) * (Double(self.productQnt)))"
                self.addToCartBtn.isHidden = true
                self.quantityView.isHidden = false
                
                self.getCartCount { (count) in
                    UserDefaults.standard.setValue("\(count)", forKey: Constant.UserDefaultKeys.cartCount)
                    self.refreshCart()
                }
            } else {
                self.showMAAlert(message: message, type: .success)
            }
        }
    }
    func executeForRemoveProductCountInCart(itemId: String) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.removeProductFromCart(itemId: itemId) { (message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                self.executeGetCartItemsAPI()
            } else {
                self.showMAAlert(message: message, type: .success)
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
                if self.aboutProductArr.count == 3 {
                    self.aboutProductArr[2] = AboutProduct(title: "Review", desc: "\(reviews) Reviews & Ratings")
                }
                self.aboutProductTblView.reloadData()
            }
        }
    }
}





//MARK:- Cell
//Tableviewcell
class AboutProductCell: UITableViewCell {
    
    @IBOutlet weak var titl: UILabel!
    @IBOutlet weak var desc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//Collectionviewcell
class ProductDetailSmallCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var moreParentView: UIView!
    @IBOutlet weak var moreText: UILabel!
    
    @IBAction func moreBtnAct(_ sender: UIButton) {
        
    }
    
    var gallery: Gallery? {
        didSet {
            if let imageUrl = self.gallery?.file {
                let imageMainUrl = APIConstant.ImageMainUrl + imageUrl
                self.img.imageFromServerURL(imageMainUrl, placeHolder: UIImage(named: "logo"))
            }
        }
    }
}
class ProductDetailBigCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    
    var gallery: Gallery? {
        didSet {
            if let imageUrl = self.gallery?.file {
                let imageMainUrl = APIConstant.ImageMainUrl + imageUrl
                self.img.imageFromServerURL(imageMainUrl, placeHolder: UIImage(named: "logo"))
            }
        }
    }
}


