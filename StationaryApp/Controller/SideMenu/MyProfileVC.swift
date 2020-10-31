//
//  MyProfileVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class MyProfileVC: BaseViewController {

    //IBOutlet
    @IBOutlet weak var savechangeBtn: UIButton!
    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var firstNameTF: TweeActiveTextField!
    @IBOutlet weak var lastNameTF: TweeActiveTextField!
    @IBOutlet weak var emailTF: TweeActiveTextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var mobilenumberPlaceholderLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileCameraIV: UIImageView!
    
    private let imagePickerController = UIImagePickerController()
    private var isEdit: Bool = false
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mobilenumberPlaceholderLbl.textColor = .black
        self.disableEditing()
        
        self.refreshProfileData()
        if checkInternet() {
            self.executeGetProfileAPI()
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.savechangeBtn.layer.cornerRadius = 5
        self.profileImg.setCircleCorner()
        self.profileCameraIV.setCircleCorner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    //MARK:- IBAction
    @IBAction func countryListBtnTapped(_ sender: UIButton) {
    }
    @IBAction func savechangesBtnTapped(_ sender: UIButton) {
        if isEdit {
            if checkInternet() {
                if let params = validateParams() {
                    self.executeUpdateProfileAPI(params: params)
                }
            }
        } else {
            self.enableEditing()
        }
    }
    
    private func enableEditing() {
        self.isEdit = true
        self.firstNameTF.isEnabled = true
        self.lastNameTF.isEnabled = true
        self.emailTF.isEnabled = false
        self.mobileTF.isEnabled = true
        //self.chooseImageBtn.isUserInteractionEnabled = true
        self.profileCameraIV.isHidden = false
        self.savechangeBtn.setTitle("Save Profile".localized, for: .normal)
    }
    private func disableEditing() {
        self.isEdit = false
        self.firstNameTF.isEnabled = false
        self.lastNameTF.isEnabled = false
        self.emailTF.isEnabled = false
        self.mobileTF.isEnabled = false
        //self.chooseImageBtn.isUserInteractionEnabled = false
        self.profileCameraIV.isHidden = true
        self.savechangeBtn.setTitle("Edit Profile".localized, for: .normal)
    }
}

//MARK:- ProfilePic
extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func chooseImgBtnTapped(_ sender: UIButton) {
        if isEdit {
            self.imagePickerController.delegate = self
            self.showImageSelectionAlert(picker: self.imagePickerController)
        } else {
            let newImageView = UIImageView(image: self.profileImg.image)
            var frame = UIScreen.main.bounds
            frame.size.height -= 100.0
            newImageView.frame = frame
            newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        self.profileImg.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}

extension MyProfileVC {
    
    /// Validate all fields for API input
    private func validateParams() -> [String: Any]? {
        
        guard let firstName = self.firstNameTF.text, firstName.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyFirstName)
            return nil
        }
        guard let lastName = self.lastNameTF.text, lastName.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyLastName)
            return nil
        }
        
        var profileParams: [String: Any] = [:]
        profileParams["firstname"] = firstName
        profileParams["lastname"] = lastName
        profileParams["email"] = self.emailTF.text ?? ""
        profileParams["website_id"] = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.websiteId) ?? "0"
        
        var params: [String: Any] = [:]
        params["customer"] = profileParams
        print(params)
        return params
    }
    
    /// Profile API
    /// - Parameter params: params to valudate on server
    func executeGetProfileAPI() {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getProfile(params: [:]) { (profile, message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.refreshProfileData()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
    
    /// Update Profile API
    /// - Parameter params: params to valudate on server
    func executeUpdateProfileAPI(params: [String: Any]) {
        self.view.endEditing(true)
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.updateProfile(params: params) { (message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.refreshProfileData()
                    self.disableEditing()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
    
    private func refreshProfileData() {
        self.firstNameTF.text = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.firstName)
        self.lastNameTF.text = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.lastName)
        self.emailTF.text = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.email)
    }
}
