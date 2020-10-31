//
//  SearchVC.swift
//  StationaryApp
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController {
    
    //MARK:-IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var productArr = [Product1]()
    var filterSearch = [Product1]()
    var isSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        
        productArr.append(Product1(isTrend: true, desc: "Office Stationary".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg1))
        productArr.append(Product1(isTrend: true, desc: "School Supplies".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg2))
        productArr.append(Product1(isTrend: true, desc: "Env".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg3))
        productArr.append(Product1(isTrend: true, desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized, rating: 4.2, addToWish: false, img: ProjectImages.demoProjectImg4))
    }
    
    //MARK:-IBAction
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch.filter { (product) -> Bool in
//            if (product.desc!.contains(searchText)) {
//                filterSearch.append(product)
//                isSearch = true
//                return true
//            } else {
//                isSearch = false
//                return false
//            }
            return false
        }
        self.tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}

extension SearchVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return filterSearch.count
        } else {
            return productArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearch == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchCell.self), for: indexPath) as! SearchCell
            cell.nameLbl.text = filterSearch[indexPath.row].desc
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchCell.self), for: indexPath) as! SearchCell
            cell.nameLbl.text = productArr[indexPath.row].desc
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyBoardMain().instantiateViewController(withIdentifier: String(describing: ProductListVC.self)) as! ProductListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DeliveryAddressTableViewCell else { return }
        cell.radioImg.image = UIImage(named: "radio_unfill")!
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
}




//MARK:- CELL
class SearchCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
