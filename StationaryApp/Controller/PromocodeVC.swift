//
//  PromocodeVC.swift
//  StationaryApp
//
//  Created by Anup Kumar on 12/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class PromocodeVC: BaseViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    
    //MARK:- variable
    
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadowinHeader(headershadowView: shadowview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK:- IBAction
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- tableview delegate
extension PromocodeVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromocodeTableViewCell", for: indexPath) as! PromocodeTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
