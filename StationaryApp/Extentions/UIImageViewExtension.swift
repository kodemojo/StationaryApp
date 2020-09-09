//
//  UIImageViewExtension.swift
//  SaudiCalendar
//
//  Created by Anup Kumar on 10/29/18.
//  Copyright © 2018 TechGropse Pvt Limited. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = placeHolder
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error.debugDescription)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
extension UIImageView {
    func localizeIV(with name: String) {
        self.image = UIImage(named: name)
//        let str = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.kLanguageSelected) ?? ""
//        if str == "ar" {
//            self.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }
    }
    func flipImageView() {
        self.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
}
extension UIViewController {
    func loadImages(from urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage)
        }
        if let url = URL(string: urlString) {
            DispatchQueue.main.async(execute: { () -> Void in
                do{
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: NSString(string: urlString))
                        DispatchQueue.main.async { completion(image) }
                    } else {
                        completion(nil)
                        print("Could not decode image")
                    }
                } catch {
                    completion(nil)
                    print("Could not load URL: \(url): \(error)")
                }
            })
        } else {
            completion(nil)
        }
    }
}
