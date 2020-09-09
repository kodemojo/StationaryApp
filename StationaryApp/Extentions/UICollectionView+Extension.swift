//
//  UICollectionView+Extension.swift
//  GetAFix
//
//  Created by Anup Kumar on 5/30/18.
//  Copyright © 2018 Mohd Arsad. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func showBackgroundMsg(msg : String)  {
        
        let label = UILabel(frame: self.bounds)
        label.text = msg
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        self.backgroundView = label
        
    }
    func showBackgroundSmallMsg(msg : String)  {
        
        let label = UILabel(frame: self.bounds)
        label.text = msg
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        self.backgroundView = label
        
    }
}
extension UICollectionViewCell {
    func setCellDropShadow(cornerRadius : CGFloat) {
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:(self.bounds), cornerRadius: cornerRadius).cgPath
    }
}
