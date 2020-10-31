//
//  NotificationVC.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var shadowview: UIView!
    
    
    //MARK:- Variable
    var orderTitle = ["Order placed successfully !".localized,"Order arrived soon".localized]
    var orderDescription = ["",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadowinHeader(headershadowView: shadowview)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- tableview delegate
extension NotificationVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        switch indexPath.row {
        case 0:
            cell.view.backgroundColor = #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1)
        case 1:
            cell.view.backgroundColor = #colorLiteral(red: 0.9178448319, green: 0.9322038889, blue: 0.9487980008, alpha: 1)
        default:
            break
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
}




//MARK:- CELL
class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

