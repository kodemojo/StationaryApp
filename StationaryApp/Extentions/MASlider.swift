//
//  MASlider.swift
//  HeyHang
//
//  Created by Anup Kumar on 7/1/19.
//  Copyright © 2019 Mohd Arsad. All rights reserved.
//

import Foundation
import UIKit

protocol MASliderDelegate {
    func onMASliderChanged(_ slider: MASlider, value: Float)
    func onMASliderFinishChanged(_ slider: MASlider, value: Float)
}

class MASlider: UISlider {
    
    var delegate: MASliderDelegate?
    
    override func draw(_ rect: CGRect) {
        self.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        self.delegate?.onMASliderChanged(self, value: slider.value)
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
            // handle drag began
                break
            case .moved:
            // handle drag moved
                break
            case .ended:
            // handle drag ended
                self.delegate?.onMASliderFinishChanged(self, value: slider.value)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.delegate?.onMASliderChanged(self, value: sender.value)
    }
    @IBAction func sliderValueFinishChanged(_ sender: UISlider) {
        self.delegate?.onMASliderFinishChanged(self, value: sender.value)
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider) -> CGPoint {
        let slidertTrack : CGRect = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm : CGRect = slider .thumbRect(forBounds: slider.bounds, trackRect: slidertTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + 8, y: slider.frame.origin.y + 20)
    }
    
    func animate(with value: Float) {
        let arr = getDifferenceBetweenValues(firstVal: self.value, secondVal: value)
        for val in arr {
            UIView.animate(withDuration: 0.3) {
                self.setValue(val, animated: true)
            }
        }
    }
    private func getDifferenceBetweenValues(firstVal: Float, secondVal: Float) -> [Float] {
        var tempArr = [Float]()
        if firstVal < secondVal {
            var currentVal = firstVal
            while (currentVal < secondVal) {
                tempArr.append(currentVal)
                currentVal += 0.1
            }
        } else {
            var currentVal = firstVal
            while (currentVal > secondVal) {
                tempArr.append(currentVal)
                currentVal -= 0.1
            }
        }
        return tempArr
    }
}
