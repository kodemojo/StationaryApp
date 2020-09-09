//
//  BaseViewController.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SystemConfiguration
import FirebaseAnalytics

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logScreenEvent()
        // Do any additional setup after loading the view.
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    func storyBoardMain() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    
    
    func showNavigationBar(title: String?) {
        self.navigationController?.navigationBar.isHidden = false
        if title == title {
            self.navigationItem.title = title
        }
    }
    
    func setBorder(viw: [UIView]?, btn: [UIButton]?, color: UIColor) {
        
        if btn?.isEmpty == false {
            for i in btn! {
                i.layer.borderWidth = 1
                i.layer.borderColor = color.cgColor
            }
        }
        
        if viw?.isEmpty == false {
            for i in viw! {
                i.layer.borderWidth = 1
                i.layer.borderColor = color.cgColor
            }
        }
    }
    
    func setShadowinHeader(headershadowView: UIView) {
        // Shadow and Radius
        headershadowView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
        headershadowView.layer.shadowOffset = .zero
        headershadowView.layer.shadowOpacity = 2
        headershadowView.layer.shadowRadius = 5
        headershadowView.layer.masksToBounds = false
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideHideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension NSObject {
    
    var className: String {
        return String(describing: self)
    }
}
