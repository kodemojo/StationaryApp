//
//  RegisterVC.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class RegisterVC: BaseViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var firstNameTF: TweeActiveTextField!
    @IBOutlet weak var lastNameTF: TweeActiveTextField!
    @IBOutlet weak var emailTF: TweeActiveTextField!
    @IBOutlet weak var passwordTF: TweeActiveTextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBACTION
    @IBAction func smt(_ sender: UIButton) {
        if checkInternet() {
            if let params = validateParams() {
                self.executeSignUpAPI(params: params)
            }
        }
    }
    
    @IBAction func goToSignin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginWithGust(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey:Constant.UserDefaultKeys.kIsGuestRegistered)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - APIs
extension RegisterVC {
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
        guard let email = self.emailTF.text, email.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyEmail)
            return nil
        }
        guard isValidEmail(email) else {
            SupportMethod.showAlertMessage(messageStr: Alert.wrongEmail)
            return nil
        }
        guard let password = self.passwordTF.text, password.count > 0 else {
            SupportMethod.showAlertMessage(messageStr: Alert.emptyPassword)
            return nil
        }
        guard isValidPassword(password) else {
            SupportMethod.showAlertMessage(messageStr: Alert.wrongPassword)
            return nil
        }
        
        var profileParams: [String: Any] = [:]
        profileParams["email"] = email
        profileParams["firstname"] = firstName
        profileParams["lastname"] = lastName
        
        var params: [String: Any] = [:]
        params["customer"] = profileParams
        params["password"] = password
        print(params)
        return params
    }
    
    /// SignUp API
    /// - Parameter params: params to valudate on server
    func executeSignUpAPI(params: [String: Any]) {
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.signUp(params: params) { (message, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    self.executeLoginAPI()
                } else {
                    SupportMethod.showAlertMessage(messageStr: message)
                }
            }
        }
    }
    
    /// LoginAPI
    /// - Parameter params: params to valudate on server
    func executeLoginAPI() {
        
        var params: [String: Any] = [:]
        params["username"] = self.emailTF.text ?? ""
        params["password"] = self.passwordTF.text ?? ""
        
        self.showActivityIndicator(uiView: self.view)
        RestAPI.shared.getToken(params: params) { (messageToken, errorCode) in
            self.hideActivityIndicator(uiView: self.view)
            DispatchQueue.main.async {
                if (errorCode == APIHelper.apiResponseSuccessCode) {
                    UserDefaults.standard.setValue(true, forKey: Constant.UserDefaultKeys.kIsRegistered)
                    let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    SupportMethod.showAlertMessage(messageStr: messageToken)
                }
            }
        }
    }
}
