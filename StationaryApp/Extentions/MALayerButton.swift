//
//  MALayerButton.swift
//  MALayerButton
//
//  Created by Mohd Arsad on 4/12/19.
//  Copyright © 2019 Mohd Arsad. All rights reserved.
//

import Foundation
import UIKit

class MALayerButton: UIButton {
    var bottomBorder = UIView()
    
    override func awakeFromNib() {
        
        updateBorderFrame()
        self.addSubview(bottomBorder)
        
    }
    override func updateConstraints() {
        super.updateConstraints()
        updateBorderFrame()
    }
    func updateBorderFrame() {
        let height: CGFloat = 3.0
        let width: CGFloat = (frame.size.width - 10)
        let xpos: CGFloat = (frame.size.width - width) / 2
        let ypos: CGFloat = (frame.size.height - height)
        
        bottomBorder = UIView(frame: CGRect(x: xpos, y: ypos, width: width, height: height))
        bottomBorder.backgroundColor = UIColor.green
        bottomBorder.layer.cornerRadius = height/2
    }
}
