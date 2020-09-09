//
//  AddReviewVC.swift
//  StationaryApp
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import FirebaseAnalytics

protocol AddReviewDelegate {
    func onAddReviewComplete()
}
class AddReviewVC: UIViewController {

    @IBOutlet weak var rate1Btn: UIButton!
    @IBOutlet weak var rate2Btn: UIButton!
    @IBOutlet weak var rate3Btn: UIButton!
    @IBOutlet weak var rate4Btn: UIButton!
    @IBOutlet weak var rate5Btn: UIButton!
    
    @IBOutlet weak var value1Btn: UIButton!
    @IBOutlet weak var value2Btn: UIButton!
    @IBOutlet weak var value3Btn: UIButton!
    @IBOutlet weak var value4Btn: UIButton!
    @IBOutlet weak var value5Btn: UIButton!
    
    @IBOutlet weak var price1Btn: UIButton!
    @IBOutlet weak var price2Btn: UIButton!
    @IBOutlet weak var price3Btn: UIButton!
    @IBOutlet weak var price4Btn: UIButton!
    @IBOutlet weak var price5Btn: UIButton!
    
    @IBOutlet weak var quality1Btn: UIButton!
    @IBOutlet weak var quality2Btn: UIButton!
    @IBOutlet weak var quality3Btn: UIButton!
    @IBOutlet weak var quality4Btn: UIButton!
    @IBOutlet weak var quality5Btn: UIButton!
    
    @IBOutlet weak var feedbackTV: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    //1 102 103
    private let placeholderText = "Write here..."
    private var rate: Int = 1
    private var value: Int = 1
    private var price: Int = 1
    private var quality: Int = 1
    var delegate: AddReviewDelegate?
    var selectedProduct: Product?
    var entityPkValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.feedbackTV.text = placeholderText
        self.feedbackTV.textColor = .lightGray
        self.feedbackTV.delegate = self
        
        self.submitBtn.backgroundColor = UIColor(red: 33/255.0, green: 108/255.0, blue: 181/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        logScreenEvent()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        }
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    @IBAction func onClickCloseBtn(_ sender: Any) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickSubmitBt(_ sender: Any) {
        self.updateProductReviews()
    }
    
    @IBAction func onClickRate1Btn(_ sender: Any) {
        self.rate = 1
        SupportMethod.updateRatingOnButton(img1: self.rate1Btn, img2: self.rate2Btn, img3: self.rate3Btn, img4: self.rate4Btn, img5: self.rate5Btn, rate: 1)
    }
    @IBAction func onClickRate2Btn(_ sender: Any) {
        self.rate = 2
        SupportMethod.updateRatingOnButton(img1: self.rate1Btn, img2: self.rate2Btn, img3: self.rate3Btn, img4: self.rate4Btn, img5: self.rate5Btn, rate: 2)
    }
    @IBAction func onClickRate3Btn(_ sender: Any) {
        self.rate = 3
        SupportMethod.updateRatingOnButton(img1: self.rate1Btn, img2: self.rate2Btn, img3: self.rate3Btn, img4: self.rate4Btn, img5: self.rate5Btn, rate: 3)
    }
    @IBAction func onClickRate4Btn(_ sender: Any) {
        self.rate = 4
        SupportMethod.updateRatingOnButton(img1: self.rate1Btn, img2: self.rate2Btn, img3: self.rate3Btn, img4: self.rate4Btn, img5: self.rate5Btn, rate: 4)
    }
    @IBAction func onClickRate5Btn(_ sender: Any) {
        self.rate = 5
        SupportMethod.updateRatingOnButton(img1: self.rate1Btn, img2: self.rate2Btn, img3: self.rate3Btn, img4: self.rate4Btn, img5: self.rate5Btn, rate: 5)
    }
    
    @IBAction func onClickValue1Btn(_ sender: Any) {
        self.value = 1
        SupportMethod.updateRatingOnButton(img1: self.value1Btn, img2: self.value2Btn, img3: self.value3Btn, img4: self.value4Btn, img5: self.value5Btn, rate: 1)
    }
    @IBAction func onClickValue2Btn(_ sender: Any) {
        self.value = 2
        SupportMethod.updateRatingOnButton(img1: self.value1Btn, img2: self.value2Btn, img3: self.value3Btn, img4: self.value4Btn, img5: self.value5Btn, rate: 2)
    }
    @IBAction func onClickValue3Btn(_ sender: Any) {
        self.value = 3
        SupportMethod.updateRatingOnButton(img1: self.value1Btn, img2: self.value2Btn, img3: self.value3Btn, img4: self.value4Btn, img5: self.value5Btn, rate: 3)
    }
    @IBAction func onClickValue4Btn(_ sender: Any) {
        self.value = 4
        SupportMethod.updateRatingOnButton(img1: self.value1Btn, img2: self.value2Btn, img3: self.value3Btn, img4: self.value4Btn, img5: self.value5Btn, rate: 4)
    }
    @IBAction func onClickValue5Btn(_ sender: Any) {
        self.value = 5
        SupportMethod.updateRatingOnButton(img1: self.value1Btn, img2: self.value2Btn, img3: self.value3Btn, img4: self.value4Btn, img5: self.value5Btn, rate: 5)
    }
    
    @IBAction func onClickPrice1Btn(_ sender: Any) {
        self.price = 1
        SupportMethod.updateRatingOnButton(img1: self.price1Btn, img2: self.price2Btn, img3: self.price3Btn, img4: self.price4Btn, img5: self.price5Btn, rate: 1)
    }
    @IBAction func onClickPrice2Btn(_ sender: Any) {
        self.price = 2
        SupportMethod.updateRatingOnButton(img1: self.price1Btn, img2: self.price2Btn, img3: self.price3Btn, img4: self.price4Btn, img5: self.price5Btn, rate: 2)
    }
    @IBAction func onClickPrice3Btn(_ sender: Any) {
        self.price = 3
        SupportMethod.updateRatingOnButton(img1: self.price1Btn, img2: self.price2Btn, img3: self.price3Btn, img4: self.price4Btn, img5: self.price5Btn, rate: 3)
    }
    @IBAction func onClickPrice4Btn(_ sender: Any) {
        self.price = 4
        SupportMethod.updateRatingOnButton(img1: self.price1Btn, img2: self.price2Btn, img3: self.price3Btn, img4: self.price4Btn, img5: self.price5Btn, rate: 4)
    }
    @IBAction func onClickPrice5Btn(_ sender: Any) {
        self.price = 5
        SupportMethod.updateRatingOnButton(img1: self.price1Btn, img2: self.price2Btn, img3: self.price3Btn, img4: self.price4Btn, img5: self.price5Btn, rate: 5)
    }
    
    @IBAction func onClickQuality1Btn(_ sender: Any) {
        self.quality = 1
        SupportMethod.updateRatingOnButton(img1: self.quality1Btn, img2: self.quality2Btn, img3: self.quality3Btn, img4: self.quality4Btn, img5: self.quality5Btn, rate: 1)
    }
    @IBAction func onClickQuality2Btn(_ sender: Any) {
        self.quality = 2
        SupportMethod.updateRatingOnButton(img1: self.quality1Btn, img2: self.quality2Btn, img3: self.quality3Btn, img4: self.quality4Btn, img5: self.quality5Btn, rate: 2)
    }
    @IBAction func onClickQuality3Btn(_ sender: Any) {
        self.quality = 3
        SupportMethod.updateRatingOnButton(img1: self.quality1Btn, img2: self.quality2Btn, img3: self.quality3Btn, img4: self.quality4Btn, img5: self.quality5Btn, rate: 3)
    }
    @IBAction func onClickQuality4Btn(_ sender: Any) {
        self.quality = 4
        SupportMethod.updateRatingOnButton(img1: self.quality1Btn, img2: self.quality2Btn, img3: self.quality3Btn, img4: self.quality4Btn, img5: self.quality5Btn, rate: 4)
    }
    @IBAction func onClickQuality5Btn(_ sender: Any) {
        self.quality = 5
        SupportMethod.updateRatingOnButton(img1: self.quality1Btn, img2: self.quality2Btn, img3: self.quality3Btn, img4: self.quality4Btn, img5: self.quality5Btn, rate: 5)
    }
}

extension AddReviewVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if feedbackTV.text == placeholderText {
            self.feedbackTV.text = ""
        }
        self.feedbackTV.textColor = .darkGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if feedbackTV.text == "" {
            self.feedbackTV.text = placeholderText
            self.feedbackTV.textColor = .lightGray
        } else {
            self.feedbackTV.textColor = .darkGray
        }
    }
}

//MARK: - APIs
extension AddReviewVC {
    
    func validate() -> [String: Any] {
        var params: [String: Any] = [:]
        params["title"] = self.selectedProduct?.name ?? ""
        params["detail"] = (self.feedbackTV.text == placeholderText) ? "" : self.feedbackTV.text
        params["nickname"] = "\(UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.firstName) ?? "") \(UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.lastName) ?? "")"
        params["review_entity"] = "product"
        params["review_status"] = "2"
        params["entity_pk_value"] = self.entityPkValue
        
        var ratingArr: [[String : Any]] = []
        ratingArr.append(["rating_name": "Rating", "value" : rate])
        ratingArr.append(["rating_name": "Value", "value" : value])
        ratingArr.append(["rating_name": "Price", "value" : price])
        ratingArr.append(["rating_name": "Quality", "value" : quality])
        params["ratings"] = ratingArr
        return params
    }
    
    func updateProductReviews() {
        self.showActivityIndicator(uiView: self.view)
        let params = ["review": validate()]
        RestAPI.shared.updateProductReviews(params: params) { (response, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            if (errorCode == APIHelper.apiResponseSuccessCode) {
                let reviews = response?.reviews?.count ?? 0
                print("Total Reviews: \(reviews)")
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.dismiss(animated: true) {
                    self.delegate?.onAddReviewComplete()
                }
            }
        }
    }
}
