//
//  StaticWebViewVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import WebKit

class StaticWebViewVC: BaseViewController {
    
    enum Navigation {
        case returnPolicy
        case shippingPolicy
        case warrantyPolicy
        case privacyPolicy
        case termsConditon
        case aboutUs
    }
    
    //MARK:-IBOutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var navigation: Navigation = .returnPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadowinHeader(headershadowView: shadowview)
        self.initiateWebView()
    }
    
    //MARK:-IBAction
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initiateWebView() {
        //Only work for terms and about us
        
        var urlStr: String = ""
        switch navigation {
        case .returnPolicy:
            self.titleLbl.text = "Return Policy"
            urlStr = ""
            break
        case .shippingPolicy:
            self.titleLbl.text = "Shipping Policy"
            urlStr = "https://www.alrawnaqwebstore.com/shipping-policy"
            if let url = URL(string: urlStr) {
                let urlRequest = URLRequest(url: url)
                self.webview.load(urlRequest)
            }
            break
        case .warrantyPolicy:
            self.titleLbl.text = "Warranty policy"
            urlStr = "https://www.alrawnaqwebstore.com/warranty-policy"
            if let url = URL(string: urlStr) {
                let urlRequest = URLRequest(url: url)
                self.webview.load(urlRequest)
            }
            break
        case .privacyPolicy:
            self.titleLbl.text = "Privacy Policy"
            urlStr = "https://www.alrawnaqwebstore.com/privacy-policy"
            if let url = URL(string: urlStr) {
                let urlRequest = URLRequest(url: url)
                self.webview.load(urlRequest)
            }
            break
        case .termsConditon:
            self.titleLbl.text = "Terms & Conditions"
//            urlStr = "https://www.alrawnaqwebstore.com/terms-and-conditions"
            let mainData = "<html><body><h1><strong>Terms and Conditions</strong></h1><p>Welcome to Al Rawnaq Online Store!</p><p>These terms and conditions outline the rules and regulations for the use of Al Rawnaq Trading Company's Website, located at https://www.alrawnaqwebstore.com.</p><p>By accessing this website we assume you accept these terms and conditions. Do not continue to use Al Rawnaq Online Store if you do not agree to take all of the terms and conditions stated on this page. </p><p>The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: \"Client\", \"You\" and \"Your\" refers to you, the person log on this website and compliant to the Company’s terms and conditions. \"The Company\", \"Ourselves\", \"We\", \"Our\" and \"Us\", refers to our Company. \"Party\", \"Parties\", or \"Us\", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.</p><h1><strong>Cookies</strong></h1><p>We employ the use of cookies. By accessing Al Rawnaq Online Store, you agreed to use cookies in agreement with the Al Rawnaq Trading Company's Privacy Policy.</p><p>Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.</p><h1><strong>License</strong></h1><p>Unless otherwise stated, Al Rawnaq Trading Company and/or its licensors own the intellectual property rights for all material on Al Rawnaq Online Store. All intellectual property rights are reserved. You may access this from Al Rawnaq Online Store for your own personal use subjected to restrictions set in these terms and conditions.</p><p>You must not:</p><ul><li>Republish material from Al Rawnaq Online Store</li><li>Sell, rent or sub-license material from Al Rawnaq Online Store</li><li>Reproduce, duplicate or copy material from Al Rawnaq Online Store</li><li>Redistribute content from Al Rawnaq Online Store</li></ul><p>This Agreement shall begin on the date hereof.</p><p>Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Al Rawnaq Trading Company does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Al Rawnaq Trading Company,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Al Rawnaq Trading Company shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.</p><p>Al Rawnaq Trading Company reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.</p><p>You warrant and represent that:</p><ul><li>You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;</li><li>The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;</li><li>The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy</li><li>The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.</li></ul><p>You hereby grant Al Rawnaq Trading Company a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.</p><h1><strong>Hyperlinking to our Content</strong></h1><p>The following organizations may link to our Website without prior written approval:</p><ul><li>Government agencies;</li><li>Search engines;</li><li>News organizations;</li><li>Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and</li><li>System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.</li></ul><p>These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.</p><p>We may consider and approve other link requests from the following types of organizations:</p><ul><li>commonly-known consumer and/or business information sources;</li><li>dot.com community sites;</li><li>associations or other groups representing charities;</li><li>online directory distributors;</li><li>internet portals;</li><li>accounting, law and consulting firms; and</li><li>educational institutions and trade associations.</li></ul><p>We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Al Rawnaq Trading Company; and (d) the link is in the context of general resource information.</p><p>These organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party’s site.</p><p>If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Al Rawnaq Trading Company. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.</p><p>Approved organizations may hyperlink to our Website as follows:</p><ul><li>By use of our corporate name; or</li><li>By use of the uniform resource locator being linked to; or</li><li>By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.</li></ul><p>No use of Al Rawnaq Trading Company's logo or other artwork will be allowed for linking absent a trademark license agreement.</p><h1><strong>iFrames</strong></h1><p>Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.</p><h1><strong>Content Liability</strong></h1><p>We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.</p><h1><strong>Your Privacy</strong></h1><p>Please read Privacy Policy</p><h1><strong>Reservation of Rights</strong></h1><p>We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.</p><h1><strong>Removal of links from our website</strong></h1><p>If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.</p><p>We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.</p><h1><strong>Disclaimer</strong></h1><p>To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:</p><ul><li>limit or exclude our or your liability for death or personal injury;</li><li>limit or exclude our or your liability for fraud or fraudulent misrepresentation;</li><li>limit any of our or your liabilities in any way that is not permitted under applicable law; or</li><li>exclude any of our or your liabilities that may not be excluded under applicable law.</li></ul><p>The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.</p><p>As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.</p></body></html>"
            let fontSize = 24
            let fontSetting = "<span style=\"font-size: \(fontSize)\"</span>"
            self.webview.loadHTMLString(fontSetting + mainData, baseURL: nil)
            break
        case .aboutUs:
            self.titleLbl.text = "About Us"
            let mainData = "<html><body><h1>l Rawnaq Trading Company</h1><p>Al-Rawnaq Trading Company is one of the leading listed companies in Qatar. The activities of the company include trading in Office and School Supplies, Children’s Toys and Educational Aids, Arabic and English Books and Publications, Arts and Crafts Materials, Computer Peripherals and Software, Mobile Phones, and Accessories, Audio Visual Instruments, Photography Tools, and Kitchen Tools. Al-Rawnaq is operating through two divisions namely Retail and Wholesale under the trademark of Al-Rawnaq Trading Company. The companies headquarter is located in Doha, Qatar</p><br><p>Al-Rawnaq Trading Company was established in Doha in 1992 under CR No. 14336. Al-Rawnaq Trading Company is a retailer and wholesaler of its products in Qatar and in other GCC countries Bahrain. We have 6 branches in Qatar and 3 branches in Bahrain.</p><br><p>Our Objective to maintain leadership in quality of service to our customers, provide products of superior quality at the best price to our customers, to be the market leader in Office Supplies, I.T. Products, Books, respect individual initiative and provide opportunities for personal growth to our employees, build a strong management team with effective leadership skills, serve and give back to the community, as we believe it is our social responsibility and to achieve profit and growth as means to make all of the other values and objectives possible.</p><br><p>With 27 years in the business, our company diversified its business into different fields allowing the company to increase its sales outlets</p><br></body></html>"
            let fontSize = 24
            let fontSetting = "<span style=\"font-size: \(fontSize)\"</span>"
            self.webview.loadHTMLString(fontSetting + mainData, baseURL: nil)
            break
        }
    }
}
