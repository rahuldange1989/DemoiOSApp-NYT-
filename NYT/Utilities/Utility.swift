//
//  Util.swift
//  NYT
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    static func showAlert(_ parent: UIViewController?, title:String, message:String) {
        if let p = parent {
            let alertView: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            // Add the actions.
            alertView.addAction(okAction)
            p.present(alertView, animated: true, completion: nil)
        }
    }
    
    static func showActivityIndicatory(_ uiView: UIView) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.init(netHex: 0xFFFFFF, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.init(netHex: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0);
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        container.tag = 2134
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    static func hideActivityIndicatory(_ uiView: UIView) {
        if let viewWithTag = uiView.viewWithTag(2134) {
            viewWithTag.removeFromSuperview()
        }
        else {
            print("hideActivityIndicatory: tag not found")
        }
    }
    
    static func getDateStringFrom(isoDateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDateString) ?? Date()
        let requiredDateFormater = DateFormatter()
        requiredDateFormater.dateFormat = DATE_FORMAT
        return requiredDateFormater.string(from: date)
    }
    
    static func getBoudingRectForText(text: String, font: UIFont, boundingRect: CGSize) -> CGSize {
        
        let context: NSStringDrawingContext = NSStringDrawingContext()
        
        let size: CGSize = text.boundingRect(with: boundingRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): font]), context: context).size as CGSize
        
        return size
    }
}

// MARK: - UIColor Extension for implementing nethex value acceptance -
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha:CGFloat, dummy: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(netHex:Int, alpha: CGFloat) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alpha:alpha, dummy: 0)
    }
}

// -- To remove Back button text from navigation bar
extension UIViewController {
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
