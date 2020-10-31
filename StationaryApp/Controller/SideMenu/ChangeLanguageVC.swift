//
//  ChangeLanguageVC.swift
//  StationaryApp
//
//  Created by Isac Joseph on 29/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ChangeLanguageVC: BaseViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var appLang = appLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        appLang = self.segmentControl.selectedSegmentIndex == 0 ? "en" : "ar"
    }
    
    
    @IBAction func applyChanges(_ sender: Any) {
        if appLang != appLanguage {
            promptAndRestartApp()
        }
    }
    
    @IBAction func cancelSelection(_ sender: Any) {
        configure()
    }
    
    func configure() {
        self.segmentControl.selectedSegmentIndex = appLanguage == "en" ? 0 : 1
    }
    
    func promptAndRestartApp() {
        let confirmationAlert = UIAlertController(title: "Change Language".localized, message: "App will reintialize to new language".localized, preferredStyle: UIAlertController.Style.alert)
        confirmationAlert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler:
            { (action: UIAlertAction!) in
                appLanguage = self.appLang
                if let window = self.view.window {
                    UIView.animate(withDuration: 0.2) {
                        window.rootViewController = self.storyboard?.instantiateInitialViewController()
                    }
                }
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            appLanguage = self.appLang
        }))
        
        if let popoverController = confirmationAlert.popoverPresentationController
        {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
}
