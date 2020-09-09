//
//  ContactUsVC.swift
//  StationaryApp
//
//  Created by Admin on 7/9/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAnalytics

class ContactUsVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logScreenEvent()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickHelpCenterBtn(_ sender: Any) {
        self.openCall(number: "+97455950008")
    }
    @IBAction func onClickPhoneSupportBtn(_ sender: Any) {
        self.openCall(number: "+97455950001")
    }
    
    @IBAction func onClickMailBtn(_ sender: Any) {
        //info@rawnaq-qatar.com
        self.sendEmail()
    }
    
    func logScreenEvent() {
        Analytics.logEvent("Opened_screen", parameters: [
            "screen": self.className as NSObject,
          ])
    }
    
    private func openCall(number: String) {
        if let phoneCallURL = URL(string: "tel://\(number)") {
          let application:UIApplication = UIApplication.shared
          if (application.canOpenURL(phoneCallURL)) {
              application.open(phoneCallURL, options: [:], completionHandler: nil)
          }
        }
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@rawnaq-qatar.com"])
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
