//
//  FilterVC.swift
//  StationaryApp
//
//  Created by Admin on 12/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class FilterVC: BaseViewController {
    
    @IBOutlet weak var headershadowView: UIView!
    @IBOutlet weak var leftTblView: UITableView!
    @IBOutlet weak var rightTblView: UITableView!
    
    var leftArr = ["Category", "Color", "Price", "Brands", "Discount", "Offers"]
    var rightArr = ["Desk Blotters", "Desk Calendar", "Stand Desk", "Items Desk", "Organizers Desk", "Sets Diaries and Organisers"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Shadow and Radius
        
        self.setShadowinHeader(headershadowView: headershadowView)
    }
    
    func setLeftSideCellDesign(indxPth: IndexPath) {
        for i in 0..<leftArr.count {
            if i == indxPth.row + 1 {
                guard let cell = leftTblView.cellForRow(at: IndexPath(item: indxPth.row + 1, section: indxPth.section)) as? FilterLeftCell else { return }
                cell.parentView.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
                cell.roundCorners(corners: [.topRight], radius: 10)
                cell.bottomView.isHidden = false
            } else if i == indxPth.row {
                guard let cell = leftTblView.cellForRow(at: indxPth) as? FilterLeftCell else { return }
                cell.bottomView.isHidden = true
                cell.parentView.backgroundColor = UIColor.white
                cell.roundCorners(corners: [.topRight], radius: 0)
                //rightArr = ""
            }
            else {
                guard let cell = leftTblView.cellForRow(at: IndexPath(item: i, section: indxPth.section)) as? FilterLeftCell else { return }
                cell.bottomView.isHidden = false
                cell.parentView.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
                cell.roundCorners(corners: [.topRight], radius: 0)
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilterSmt(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTblView {
            return leftArr.count
        } else {
            return rightArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == leftTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterLeftCell.self), for: indexPath) as! FilterLeftCell
            cell.parentView.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
            cell.name.text = leftArr[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterRightCell.self), for: indexPath) as! FilterRightCell
            if indexPath.row == 0 {
                cell.img.image = ProjectImages.tick_fill
            } else {
                cell.img.image = ProjectImages.tick_unfill
            }
            cell.name.text = rightArr[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTblView {
            setLeftSideCellDesign(indxPth: indexPath)
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) as? FilterRightCell else { return }
            cell.img.image = ProjectImages.tick_fill
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == rightTblView {
            guard let cell = tableView.cellForRow(at: indexPath) as? FilterRightCell else { return }
            cell.img.image = ProjectImages.tick_unfill
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == leftTblView {
            return 45
        } else {
            return UITableView.automaticDimension
        }
    }
    
    
}
