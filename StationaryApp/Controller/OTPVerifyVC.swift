//
//  OTPVerifyVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class OTPVerifyVC: BaseViewController {
    
    @IBOutlet weak var otp1TF: UITextField!
    @IBOutlet weak var otp2TF: UITextField!
    @IBOutlet weak var otp3TF: UITextField!
    @IBOutlet weak var otp4TF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupTextField()
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickVerifyBtn(_ sender: Any) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: SideMenuController.self)) as! SideMenuController
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if otp1TF.text?.isEmpty == false && otp2TF.text?.isEmpty == false && otp3TF.text?.isEmpty == false && otp4TF.text?.isEmpty == false {
//            if self.checkInternet() == true {
//
//                self.getSetAPIDATA()
//            } else {
//                self.showAlert(view: self, message: Constant.internetLost, compileAction: nil)
//            }
//        }
    }
}

extension OTPVerifyVC: UITextFieldDelegate {
    
    private func setupTextField() {
        self.otp1TF.delegate = self
        self.otp2TF.delegate = self
        self.otp3TF.delegate = self
        self.otp4TF.delegate = self
        
        self.otp1TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.otp2TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.otp3TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.otp4TF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length + range.location > (textField.text?.count)! {
            return false
        }
        let newLength: Int = (textField.text?.count)! + string.count - range.length
        return newLength <= 1
    }
    
    @objc func textFieldDidChange(_ theTextField: UITextField) {
        if theTextField == self.otp1TF {
            if theTextField.text?.count == 1 {
                self.otp1TF.resignFirstResponder()
                self.otp2TF.becomeFirstResponder()
            }
        }
        else if theTextField == self.otp2TF {
            if theTextField.text?.count == 1 {
                self.otp2TF.resignFirstResponder()
                self.otp3TF.becomeFirstResponder()
            } else {
                let  char = self.otp2TF.text?.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                
                if (isBackSpace == -92) {
                    self.otp2TF.resignFirstResponder()
                    self.otp1TF.becomeFirstResponder()
                }
            }
        }
        else if theTextField == self.otp3TF {
            if theTextField.text?.count == 1 {
                self.otp3TF.resignFirstResponder()
                self.otp4TF.becomeFirstResponder()
            } else {
                let  char = self.otp3TF.text?.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                
                if (isBackSpace == -92) {
                    self.otp3TF.resignFirstResponder()
                    self.otp2TF.becomeFirstResponder()
                }
            }
        }
        else if theTextField == self.otp4TF {
            if theTextField.text?.count == 1{
                self.otp4TF.resignFirstResponder()
            } else {
                let  char = self.otp4TF.text?.cString(using: String.Encoding.utf8)!
                let isBackSpace = strcmp(char, "\\b")
                
                if (isBackSpace == -92) {
                    self.otp4TF.resignFirstResponder()
                    self.otp3TF.becomeFirstResponder()
                }
            }
        }
    }
}
