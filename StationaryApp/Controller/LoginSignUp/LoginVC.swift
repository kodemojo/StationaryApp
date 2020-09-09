//
//  LoginVC.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class LoginVC: BaseViewController {
    
    @IBOutlet weak var emailTF: TweeActiveTextField!
    @IBOutlet weak var passwordTF: TweeActiveTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBACTION
    @IBAction func smt(_ sender: UIButton) {
        if checkInternet() {
            if let params = validateParams() {
                self.executeLoginAPI(params: params)
            }
        }
//        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: OTPVerifyVC.self)) as! OTPVerifyVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pushToSignUp(_ sender: UIButton) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: RegisterVC.self)) as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginWithGust(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey:Constant.UserDefaultKeys.kIsGuestRegistered)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - APIs
extension LoginVC {
    /// Validate all fields for API input
    private func validateParams() -> [String: Any]? {
        
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
       /* guard isValidPassword(password) else {
            SupportMethod.showAlertMessage(messageStr: Alert.wrongPassword)
            return nil
        } */
        
        var params: [String: Any] = [:]
        params["username"] = email
        params["password"] = password
        print(params)
        return params
    }
    
    /// LoginAPI
    /// - Parameter params: params to valudate on server
    func executeLoginAPI(params: [String: Any]) {
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
